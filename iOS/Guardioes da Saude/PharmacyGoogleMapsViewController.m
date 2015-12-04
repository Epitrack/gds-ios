//
//  PharmacyGoogleMapsViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 04/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "PharmacyGoogleMapsViewController.h"
#import "User.h"
@import GoogleMaps;

@interface PharmacyGoogleMapsViewController ()

@end

@implementation PharmacyGoogleMapsViewController {
    GMSMapView *mapView;
    User *user;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = [User getInstance];
    [self loadMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMap {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[user.lat longLongValue]
                                                            longitude:[user.lon longLongValue]
                                                                 zoom:6];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([user.lat longLongValue], [user.lon longLongValue]);
    marker.title = user.nick;
    //marker.snippet = @"Australia";
    marker.map = mapView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
