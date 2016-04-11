//
//  EmergencyViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EmergencyViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *mapEmergency;
@property (weak, nonatomic) IBOutlet UILabel *lbEmergencyName;
@property (weak, nonatomic) IBOutlet UILabel *lbEmergencyAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consEmergencyDetail;
- (IBAction)btnTraceRoteAction:(id)sender;

@end
