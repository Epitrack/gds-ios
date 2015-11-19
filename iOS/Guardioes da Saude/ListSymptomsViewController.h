//
//  ListSymptomsViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 27/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ListSymptomsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate> {
    
    NSMutableArray *symptoms;
    NSDictionary *symptomsTemp;
    NSMutableDictionary *symptomsSelected;
    NSMutableArray *symptomsArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableSymptoms;
- (IBAction)btnConfirmSurvey:(id)sender;
- (void) loadSymptoms;


@end
