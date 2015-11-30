//
//  EmergencyViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "EmergencyViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"

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
        CLLocationDistance distance = 400;
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
    
    user = [User getInstance];
    NSString *url = @"http://api.guardioesdasaude.org/content/upas.json";
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *upas = responseObject;
             
             NSLog(@"UPAS %@", upas);
             
             for (NSDictionary *item in upas) {
                 
                 NSString *latitude = item[@"latitude"];
                 NSString *longitude = item[@"longitude"];
                 NSString *name = item[@"name"];
                 NSString *logradouro = item[@"logradouro"];
                 
                 if (![latitude isKindOfClass:[NSNull class]] && ![longitude isKindOfClass:[NSNull class]]) {
                     CLLocationCoordinate2D annotationCoord;
                     annotationCoord.latitude = [latitude doubleValue];
                     annotationCoord.longitude = [longitude doubleValue];
                     
                     MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
                     pin.coordinate = annotationCoord;
                     pin.title = name;
                     pin.subtitle = logradouro;
                     
                     [self.mapEmergency addAnnotation:pin];
                 }
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"You pressed button OK");
         }];
    
}

@end
