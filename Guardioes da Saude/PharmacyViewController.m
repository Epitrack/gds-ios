//
//  PharmacyViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "PharmacyViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "User.h"
#import "PharmacyGoogleMapsViewController.h"
#import "SingleLocation.h"
#import "LocationUtil.h"
#import "ViewUtil.h"
#import "MBProgressHUD.h"
#import "Requester.h"
#import <Google/Analytics.h>

@interface PharmacyViewController () {
    
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
    User *user;
}

@end

@implementation PharmacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"pharmacy.title", @"");
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    user = [User getInstance];
    
    self.mapPharmacy.showsUserLocation = YES;
    self.mapPharmacy.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:NSLocalizedString(@"pharmacy.some_isnt_showing", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Pharmacy Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPointAnnotation *annotation = (MKPointAnnotation *)[view annotation];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude) addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:annotation.title];
    [mapItem openInMapsWithLaunchOptions:nil];
    
    request.destination = mapItem;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
     }];
}

- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
    MKAnnotationView *v = [views objectAtIndex:0];
    if ([v.reuseIdentifier isEqualToString:@"user"]) {
        CLLocationDistance distance = 400;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([v.annotation coordinate], distance, distance);
        
        [self.mapPharmacy setRegion:region animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self.view layoutIfNeeded];
    
    self.constPharmacyDetails.constant = -90.0f;
    
    
    [UIView animateWithDuration:.25 animations:^(){
        [self.view layoutIfNeeded];
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [self.view layoutIfNeeded];
    
    self.constPharmacyDetails.constant = 0.0f;
    
    MKPointAnnotation *annotation = (MKPointAnnotation *)[view annotation];
    self.lbPharmacyName.text = annotation.title;
    self.lbPharmacyAddress.text = annotation.subtitle;
    
    [UIView animateWithDuration:.25 animations:^(){
        [self.view layoutIfNeeded];
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != mV.userLocation) {
        static NSString *defaultPinID = @"upa";
        pinView = (MKAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = NO;
        pinView.image = [UIImage imageNamed:@"icon_pin_pharmacy.png"];
        // Add a detail disclosure button to the callout.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        
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

- (void) loadPharmacy {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [LocationUtil loadPharmacyWithLat:latitude
                               andLog:longitude
                         andOnSuccess:^(NSArray *pins){
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             [self.mapPharmacy addAnnotations:pins];
                         }
                           andOnError:^(NSError *error){
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               NSString *errorMsg;
                               if (error && error.code == -1009) {
                                   errorMsg = NSLocalizedString(kMsgConnectionError, @"");
                               } else {
                                   errorMsg = NSLocalizedString(kMsgApiError, @"");
                               }
                               
                               [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                           }];
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (!latitude && !longitude) {
        latitude = currentLocation.coordinate.latitude;
        longitude = currentLocation.coordinate.longitude;
        
        [self loadPharmacy];
    }
    
    user.lat = [NSString stringWithFormat:@"%f", latitude];
    user.lon = [NSString stringWithFormat:@"%f", longitude];
}

@end
