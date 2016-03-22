//
//  PharmacyViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PharmacyViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *mapPharmacy;
@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view
@property (weak, nonatomic) IBOutlet UILabel *lbPharmacyName;
@property (weak, nonatomic) IBOutlet UILabel *lbPharmacyAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constPharmacyDetails;
@end
