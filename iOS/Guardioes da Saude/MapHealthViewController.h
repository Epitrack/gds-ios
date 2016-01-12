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
#import "PNChart.h"

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
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UIButton *btnDetails;
@property (weak, nonatomic) IBOutlet UILabel *txtPercentGood;
@property (weak, nonatomic) IBOutlet UILabel *txtPercentBad;
@property (weak, nonatomic) IBOutlet UILabel *txtCountGood;
@property (weak, nonatomic) IBOutlet UILabel *txtCountBad;
@property (weak, nonatomic) IBOutlet UIProgressView *progressViewDiarreica;
@property (weak, nonatomic) IBOutlet UIProgressView *progressViewExantematica;
@property (weak, nonatomic) IBOutlet UIProgressView *progessViewRespiratoria;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentDiareica;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentExantematica;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentRespiratoria;
- (IBAction)btnInfoAction:(id)sender;


@end
