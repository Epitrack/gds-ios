//
//  ListSymptomsViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 27/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@import DownPicker;

@interface ListSymptomsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *symptoms;
    NSDictionary *symptomsTemp;
    NSMutableDictionary *symptomsSelected;
    NSMutableArray *symptomsArray;
}

@property double latitude;
@property double longitude;


@property (strong, nonatomic) IBOutlet UITableView *tableSymptoms;
- (IBAction)btnConfirmSurvey:(id)sender;
- (void) loadSymptoms;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtPais;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConfirmationConstraint;
@property (weak, nonatomic) IBOutlet UITextView *txHeader;

@end
