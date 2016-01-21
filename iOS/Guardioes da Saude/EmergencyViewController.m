//
//  EmergencyViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "EmergencyViewController.h"
#import "User.h"
#import "TipsRequester.h"
#import "MBProgressHUD.h"
#import "ViewUtil.h"

@interface EmergencyViewController () {

    CLLocationManager *locationManager;
    User *user;
}

@end

@implementation EmergencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"UPAs";
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;

    
    self.mapEmergency.showsUserLocation = YES;
    self.mapEmergency.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    [self.mapEmergency setUserTrackingMode:MKUserTrackingModeFollow];
    
    [self loadUpas];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
     //NSLog(@"didUpdateUserLocation just got called!");
    
    MKAnnotationView *v = [views objectAtIndex:0];
    if ([v.reuseIdentifier isEqualToString:@"user"]) {
        CLLocationDistance distance = 3000;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([v.annotation coordinate], distance, distance);
        
        [self.mapEmergency setRegion:region animated:YES];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != mV.userLocation) {
        static NSString *defaultPinID = @"upa";
        pinView = (MKAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"icon_pin_urgency.png"];
        // Add a detail disclosure button to the callout.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        // Add an image to the left callout.
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pin_urgency.png"]];
        pinView.leftCalloutAccessoryView = iconView;
        
    } else {
        [mV.userLocation setTitle:user.nick];
        static NSString *defaultPinID = @"user";

        pinView = (MKAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"icon_pin_userlocation.png"];
    }
    return pinView;
}

-(void) loadUpas {
    [[[TipsRequester alloc] init] loadUpasOnStart:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    } andOnSuccess:^(NSArray *upasPin){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.mapEmergency addAnnotations:upasPin];
    } andOnError:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *errorMsg;
        if (error && error.code == -1009) {
            errorMsg = kMsgConnectionError;
        } else {
            errorMsg = kMsgApiError;
        }
        
        [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
    }];
}

@end
