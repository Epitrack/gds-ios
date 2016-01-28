//
//  PharmacyGoogleMapsViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 04/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "PharmacyGoogleMapsViewController.h"
#import "User.h"
#import "SingleLocation.h"
#import <Google/Analytics.h>
@import GoogleMaps;

@interface PharmacyGoogleMapsViewController () {
    GMSMapView *mapView;
    User *user;
    SingleLocation *singleLocation;
}

@end

@implementation PharmacyGoogleMapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = [User getInstance];
    singleLocation = [SingleLocation getInstance];
    [self loadMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Phamacy Google Maps Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void) loadMap {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    NSLog(@"tapGestureHandler: touchMapCoordinate = %@,%@", singleLocation.lat, singleLocation.lon);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[singleLocation.lat longLongValue]
                                                            longitude:[singleLocation.lon longLongValue]
                                                                 zoom:15];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([singleLocation.lat longLongValue], [singleLocation.lon longLongValue]);
    //marker.title = user.nick;
    //marker.snippet = @"Australia";
    marker.map = mapView;
    //mapView.myLocationEnabled = YES;
    mapView.mapType = kGMSTypeNormal;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
        
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
