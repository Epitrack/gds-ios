//
//  DiaryHealthViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 16/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASHorizontalScrollView.h"
#import "User.h"
#import "Household.h"

@interface DiaryHealthViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UILabel *lbTotalParticipation;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentGood;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentBad;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalReportGood;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalReportBad;
@property (weak, nonatomic) IBOutlet UILabel *lbFrequencyYear;
@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UIView *viewNoRecord;

- (IBAction)btnNextMonthAction:(id)sender;
- (IBAction)btnPreviousMonthAction:(id)sender;
- (IBAction)btnChangePerson:(id)sender;
- (void)refreshInformationToUser:(Household *)houlsehold;

@end
