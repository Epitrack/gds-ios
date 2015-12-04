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
    self.navigationItem.title = @"Farmácias";
    
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
    
    [self loadPharmacy];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Algumas farmácias podem não ser exibidas no mapa." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
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
    id <MKAnnotation> annotation = [view annotation];
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]){
        PharmacyGoogleMapsViewController *pharmacyGoogleMapsViewController = [[PharmacyGoogleMapsViewController alloc] init];
        [self.navigationController pushViewController:pharmacyGoogleMapsViewController animated:YES];
    }
    //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    //[alertView show];
}


- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    //NSLog(@"didUpdateUserLocation just got called!");
    
    MKAnnotationView *v = [views objectAtIndex:0];
    if ([v.reuseIdentifier isEqualToString:@"user"]) {
        CLLocationDistance distance = 400;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([v.annotation coordinate], distance, distance);
        
        [self.mapPharmacy setRegion:region animated:YES];
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
        pinView.image = [UIImage imageNamed:@"icon_pin_pharmacy.png"];
        // Add a detail disclosure button to the callout.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        // Add an image to the left callout.
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pin_pharmacy.png"]];
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

- (void) loadPharmacy {
    
    NSString *url = [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/place/textsearch/json?query=pharmacy&location=%f,%f&radius=10000&key=AIzaSyDYl7spN_NpAjAWL7Hi183SK2cApiIS3Eg", [user.lat doubleValue], [user.lon doubleValue]];
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *results = responseObject[@"results"];
             NSLog(@"Results: %@", results);
             
             for (NSDictionary *item in results) {
                 
                 NSDictionary *geometry = item[@"geometry"];
                 NSLog(@"geometry: %@", geometry);
                 NSDictionary *location = geometry[@"location"];
                 NSLog(@"location: %@", location);
                 
                 
                 NSString *latitudePharmacy = location[@"lat"];
                 NSString *longitudePharmacy = location[@"lng"];
                 NSString *name = item[@"name"];
                 NSString *logradouro = item[@"formatted_address"];
                 
                 if (![latitudePharmacy isKindOfClass:[NSNull class]] && ![longitudePharmacy isKindOfClass:[NSNull class]]) {
                     CLLocationCoordinate2D annotationCoord;
                     annotationCoord.latitude = [latitudePharmacy doubleValue];
                     annotationCoord.longitude = [longitudePharmacy doubleValue];
                     
                     MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
                     pin.coordinate = annotationCoord;
                     pin.title = name;
                     //pin.subtitle = logradouro;
                     pin.subtitle = @"Ver no Google Maps";
                     
                     [self.mapPharmacy addAnnotation:pin];
                 }
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Infelizmente não conseguimos conlcuir esta operação. Tente novamente dentro de alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                 NSLog(@"You pressed button OK");
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
             NSLog(@"Error: %@", error);
         }];
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;

    user.lat = [NSString stringWithFormat:@"%f", latitude];
    user.lon = [NSString stringWithFormat:@"%f", longitude];
}

@end
