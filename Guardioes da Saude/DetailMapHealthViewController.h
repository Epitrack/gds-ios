//
//  DetailMapHealthViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 30/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface DetailMapHealthViewController : UIViewController<PNChartDelegate>
@property (weak, nonatomic) IBOutlet UILabel *txtCity;
@property (weak, nonatomic) IBOutlet UILabel *txtState;
@property (weak, nonatomic) IBOutlet UILabel *txtCountParticipation;
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
