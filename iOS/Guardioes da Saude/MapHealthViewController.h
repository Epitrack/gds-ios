//
//  MapHealthViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 29/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapHealthViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate> {
    
    NSMutableArray *surveysMap;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapHealth;
- (void) addPin;
- (void) loadSummary;
- (void) loadSurvey;
- (IBAction)showDetailMapPlus:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *seach;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UILabel *lblPaticipation;

@end
