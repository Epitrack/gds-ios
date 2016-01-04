//
//  DiaryHealthViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 16/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASHorizontalScrollView.h"
#import "PNChart.h"

@interface DiaryHealthViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PNChartDelegate> {
    
    UITableView *sampleTableView;
    
}

@property (weak, nonatomic) IBOutlet UILabel *lbTotalParticipation;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentGood;
@property (weak, nonatomic) IBOutlet UILabel *lbPercentBad;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalReportGood;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalReportBad;

@property (nonatomic) PNPieChart *pieChart;


@end
