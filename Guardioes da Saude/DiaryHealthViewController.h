//
//  DiaryHealthViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 16/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASHorizontalScrollView.h"

@interface DiaryHealthViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UILabel *lbTotalParticipation;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentGood;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentBad;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalReportGood;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalReportBad;
@property (weak, nonatomic) IBOutlet UILabel *lbFrequencyYear;

- (IBAction)btnNextMonthAction:(id)sender;
- (IBAction)btnPreviousMonthAction:(id)sender;
- (IBAction)btnChangePerson:(id)sender;

@end
