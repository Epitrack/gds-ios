//
//  DiaryHealthViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 16/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "DiaryHealthViewController.h"
#import "Household.h"
#import "UserRequester.h"
#import "Sumary.h"
#import "SumaryGraph.h"
#import "SumaryCalendar.h"
#import "HouseholdRequester.h"
#import <JTCalendar/JTCalendar.h>
#import "HouseholdThumbnail.h"
#import "Constants.h"
#import "DateUtil.h"
#import "MBProgressHUD.h"
#import "ViewUtil.h"
#import <Google/Analytics.h>
#import "Charts/Charts-Swift.h"
#import "ParticipantsListViewController.h"
@import Photos;

@import Charts;

@interface DiaryHealthViewController () <JTCalendarDelegate>

// Pizza graph
@property (nonatomic, weak) IBOutlet PieChartView * chartView;

// Line graph
@property (weak, nonatomic) IBOutlet LineChartView *graphView;


// Calendar
@property (nonatomic, weak) IBOutlet JTCalendarMenuView * calendarMenuView;
@property (nonatomic, weak) IBOutlet JTHorizontalCalendarView * calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (nonatomic, strong) NSMutableDictionary * calendarMap;

@end

@implementation DiaryHealthViewController {
    NSMutableArray *buttons;
    User *user;
    NSString *selectedUser;
    UserRequester *userRequester;
    BOOL firstTime;
    int requestsInProcess;

}

const float _kCellHeight = 100.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"diary_health.title", @"");
    
    // We will move this to the top?
    
    selectedUser = @"";
    user = [User getInstance];
    userRequester = [[UserRequester alloc] init];
    buttons = [NSMutableArray array];
    firstTime = YES;
    
    [self loadMainUser];
    
    [self loadHouseHolds];
    
    [self loadCalendar];
    
    [self loadChartLine];
    
    [self refreshSummaryWithUserId:@""];
    
    [self requestCalendar:@"" andDate:[NSDate date]];
    
    [self requestChartLine: @""];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [user setAvatarImageAtButton:nil orImageView:self.imgPicture];
    self.lbUserName.text = user.nick;
}

- (void) loadHouseHolds{
    [self showProgressBar];
    
    [[[HouseholdRequester alloc] init] getHouseholdsByUser:user onSuccess:^(NSMutableArray *households){
        [self hiddenProgressBar];
        user.household = households;
    } onFail:^(NSError *error){
        [self hiddenProgressBar];
        UIAlertController *alert = [ViewUtil showNoConnectionAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Diary Health Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void) refreshSummaryWithUserId: (NSString *) userId{
    void(^onSuccess)(Sumary * sumary) = ^(Sumary * sumary){
        if (sumary.total == 0) {
            self.viewNoRecord.hidden = NO;
        } else {
            self.viewNoRecord.hidden = YES;
            [self populateLabelsWithSummary:sumary];
        }
        
        [self hiddenProgressBar];
    };
    
    [userRequester getSummary: [User getInstance]
                                 idHousehold:userId
                                     onStart: ^{[self showProgressBar];}
                                     onError: ^(NSError * error) {
                                         [self hiddenProgressBar];
                                         NSString *errorMsg;
                                         if (error && error.code == -1009) {
                                             errorMsg = NSLocalizedString(kMsgConnectionError, @"");
                                         } else {
                                             errorMsg = NSLocalizedString(kMsgApiError, @"");
                                         }
                                         
                                         [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                     }
                                   onSuccess: onSuccess];
}

-(void) populateLabelsWithSummary:(Sumary *) summary{
    self.lbTotalParticipation.text = [NSString stringWithFormat:@"%d",summary.total];
    self.lbTotalReportGood.text = [NSString stringWithFormat:@"%d",summary.noSymptom];
    self.lbTotalReportBad.text = [NSString stringWithFormat:@"%d",summary.symptom];
    
    double goodPercent;
    double badPercent;
    
    if (summary.total == 0) {
        goodPercent = 0;
    } else {
        goodPercent = (summary.noSymptom * 100.0f) / summary.total;
    }
    
    if (summary.total == 0) {
        badPercent = 0;
    } else {
        badPercent = (summary.symptom * 100.0f) / summary.total;
    }
    
    self.lbPercentGood.text = [NSString stringWithFormat:@"%g%%", round(goodPercent)];
    self.lbPercentBad.text = [NSString stringWithFormat:@"%g%%", round(badPercent)];
    
    [self populateChartWithGoodPercent:goodPercent andBadPercent:badPercent];
}

-(void) populateChartWithGoodPercent: (double) goodPercent andBadPercent: (double) badPecent{
    
    if(goodPercent == 0 && badPecent == 0){
        self.chartView.hidden = YES;
        return;
    }
    
    self.chartView.hidden = NO;
    
    [self.chartView setUsePercentValuesEnabled: NO];
    [self.chartView setDescriptionText: @""];
    [self.chartView setDrawCenterTextEnabled: NO];
    [self.chartView setDrawSliceTextEnabled: NO];
    [self.chartView setDrawHoleEnabled: NO];
    [self.chartView setHoleTransparent: NO];
    self.chartView.legend.enabled = NO;
    
    NSArray * xData = @[@"Mal", @"Bem"];
    
    NSArray * yData = @[[NSNumber numberWithInt: badPecent],
                        [NSNumber numberWithInt: goodPercent]];
    
    NSMutableArray * xArray = [NSMutableArray array];
    
    for (NSString * value in xData) {
        [xArray addObject: value];
    }
    
    NSMutableArray * yArray = [NSMutableArray array];
    
    for (int i = 0; i < yData.count; i++) {
        
        NSNumber * value = [yData objectAtIndex: i];
        
        BarChartDataEntry * entry = [[BarChartDataEntry alloc] initWithValue: [value doubleValue]
                                                                      xIndex: i];
        [yArray addObject: entry];
    }
    
    PieChartDataSet * dataSet = [[PieChartDataSet alloc] initWithYVals: yArray];
    
    [dataSet setSliceSpace: 2];
    [dataSet setSelectionShift: 2];
    
    NSMutableArray * colorArray = [NSMutableArray array];
    
    [colorArray addObject: [DiaryHealthViewController toUiColor: @"#FF0000"]];
    [colorArray addObject: [DiaryHealthViewController toUiColor: @"#CCCC00"]];
    
    [dataSet setColors: colorArray];
    
    PieChartData * data = [[PieChartData alloc] initWithXVals: xArray dataSet: dataSet];
    
    [data setDrawValues: NO];
    [data setHighlightEnabled: NO];
    
    [self.chartView setData: data];
    
    [self.chartView setNeedsDisplay];
    
}

#pragma tableview datasource
- (void)loadMainUser {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(button.bounds.size.width/4,
                                         5,
                                         button.bounds.size.width/2,
                                         button.bounds.size.height/2)];
    
    [user setAvatarImageAtButton:nil orImageView:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(button.bounds.size.width/4, 50, button.bounds.size.width/2, button.bounds.size.height/2)];
    label.text= [user.nick componentsSeparatedByString:@" "][0];
    label.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Arial" size:10.0]];
    [button addSubview:label];
    [button addSubview:imageView];
    [button addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
}

- (void) pushAction: (id)sender {

    UIButton *b = (UIButton *) sender;
    HouseholdThumbnail *thumb = (HouseholdThumbnail*) b.superview;
    if ([thumb isKindOfClass: [HouseholdThumbnail class]]) {
        NSString *idHousehold = thumb.household.idHousehold;
        selectedUser = idHousehold;
        
        [self refreshSummaryWithUserId:idHousehold];
        
        [self requestCalendar:idHousehold andDate:[NSDate date]];
        
        [self requestChartLine: idHousehold];
    }else{
        [self refreshSummaryWithUserId:@""];
        
        [self requestCalendar:@"" andDate:[NSDate date]];
        
        [self requestChartLine: @""];
        
        selectedUser = @"";
    }
}

- (void) loadChartLine {
    
    self.graphView.descriptionText = @"";
    self.graphView.noDataTextDescription = @"You need to provide data for the chart.";
    
    self.graphView.dragEnabled = NO;
    [self.graphView setScaleEnabled:NO];
    self.graphView.pinchZoomEnabled = NO;
    self.graphView.drawGridBackgroundEnabled = NO;
    
    ChartYAxis *leftAxis = self.graphView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 5;
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.negativeSuffix = @" %";
    leftAxis.valueFormatter.positiveSuffix = @" %";
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;

    leftAxis.customAxisMax = 100.0;
    leftAxis.customAxisMin = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *rightAxis = self.graphView.rightAxis;
    rightAxis.enabled = NO;
    
    ChartXAxis *xAxis = self.graphView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;

    xAxis.spaceBetweenLabels = 2.0;
    
    self.graphView.legend.enabled = NO;
}

- (void) loadCalendar {
    
    self.calendarManager = [JTCalendarManager new];
    
    self.calendarManager.delegate = self;
    
    self.calendarMenuView.contentRatio = .75;
    self.calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatShort;
    self.calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"pt_Br"];
    
    [self.calendarManager setMenuView: self.calendarMenuView];

    [self.calendarManager setContentView: self.calendarContentView];

    [self.calendarManager setDate: [NSDate date]];
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [[dateFormatter stringFromDate:date] capitalizedString];
}


- (void) requestChartLine: (NSString *)idHousehold {

    [userRequester getSummary: [User getInstance]
                                 idHousehold: idHousehold
                                        year: (int) [DateUtil getCurrentYear]
                                     onStart: ^{[self showProgressBar];}
                                     onError: ^(NSError * error) {
                                         [self hiddenProgressBar];
                                         NSString *errorMsg;
                                         if (error && error.code == -1009) {
                                             errorMsg = NSLocalizedString(kMsgConnectionError, @"");
                                         } else {
                                             errorMsg = NSLocalizedString(kMsgApiError, @"");
                                         }
                                         
                                         [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                     }
                                   onSuccess: ^(NSMutableDictionary * sumaryGraphMap) {
                                       [self hiddenProgressBar];
                                       
                                       self.lbFrequencyYear.text = [NSString stringWithFormat:@"Frequência %d", (int) [DateUtil getCurrentYear]];
                                       
                                       NSArray *xVals = @[@"Jan", @"Fev", @"Mar", @"Abr", @"Mai", @"Jun", @"Jul", @"Ago", @"Set", @"Out", @"Nov", @"Dez"];
                                       
                                       NSMutableArray *yVals = [[NSMutableArray alloc] init];
                                       
                                       for (int i = 1; i <= 12; i++) {
                                           if (![sumaryGraphMap objectForKey: [NSNumber numberWithInt: i]]) {
                                               [yVals addObject:[[ChartDataEntry alloc] initWithValue:0 xIndex:i-1]];
                                           }else{
                                               SumaryGraph * sumaryGraph = [sumaryGraphMap objectForKey: [NSNumber numberWithInt: i]];
                                               
                                               [yVals addObject: [[ChartDataEntry alloc] initWithValue:sumaryGraph.percent xIndex:i-1]];
                                           }
                                       }
                                       
                                       LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals];
                                       
                                       set1.highlightEnabled = NO;
                                       [set1 setColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:1]];
                                       [set1 setCircleColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:1]];
                                       set1.lineWidth = 1.0;
                                       set1.circleRadius = 3.0;
                                       set1.drawCircleHoleEnabled = NO;
                                       set1.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
                                       set1.drawFilledEnabled = YES;
                                       set1.drawValuesEnabled = NO;
                                       
                                       NSMutableArray *dataSets = [[NSMutableArray alloc] init];
                                       [dataSets addObject:set1];
                                       
                                       LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
                                       
                                       self.graphView.data = data;
                                       [self.graphView animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
                                   }
     ];
}

- (void) requestCalendar: (NSString *)idHousehold andDate:(NSDate *) date {
    void (^onSuccess)(NSMutableDictionary * sumaryCalendarMap) = ^void(NSMutableDictionary * sumaryCalendarMap){
        self.calendarMap = sumaryCalendarMap;

        [self.calendarManager reload];
        [self hiddenProgressBar];
    };
    
    [userRequester getSummary: [User getInstance]
                                 idHousehold: idHousehold
                                       month: [self getMonth: date]
                                        year: [self getYear: date]
                                     onStart: ^{[self showProgressBar];}
                                     onError: ^(NSError * error){
                                         [self hiddenProgressBar];
                                         NSString *errorMsg;
                                         if (error && error.code == -1009) {
                                             errorMsg = NSLocalizedString(kMsgConnectionError, @"");
                                         } else {
                                             errorMsg = NSLocalizedString(kMsgApiError, @"");
                                         }
                                         
                                         [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                     }
                                   onSuccess: onSuccess
     ];
}

- (void) calendar: (JTCalendarManager *) calendar prepareDayView: (JTCalendarDayView *) dayView {
    
    if (self.calendarMap) {
        
        dayView.hidden = NO;
        
        if ([dayView isFromAnotherMonth]) {
            dayView.hidden = YES;
        }
        
        NSString * key = [NSString stringWithFormat: @"%d-%d-%d",
                          (int) [self getDay: dayView.date], (int) [self getMonth: dayView.date], (int) [self getYear: dayView.date]];
        
        SumaryCalendar * sumaryCalendar = [self.calendarMap objectForKey: key];
        
        if (sumaryCalendar) {
            [dayView addSubview: [self getState: sumaryCalendar]];
        }else{
            UIImageView * view = [[UIImageView alloc] initWithFrame: CGRectMake(9, 0, 23, 23)];
            [dayView addSubview: view];
        }
    }
}

- (void) calendarDidLoadPreviousPage: (JTCalendarManager *) calendar {
    [self requestCalendar:selectedUser andDate:calendar.date];
}

- (void) calendarDidLoadNextPage: (JTCalendarManager *) calendar {
    [self requestCalendar:selectedUser andDate: calendar.date];
}

- (NSInteger) getDay: (NSDate *) date {
    
    NSDateComponents * dateComponent = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: date];
    
    return [dateComponent day];
}

- (NSInteger) getMonth: (NSDate *) date {
    
    NSDateComponents * dateComponent = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth fromDate: date];
    
    return [dateComponent month];
}

- (NSInteger) getYear: (NSDate *) date {
    
    NSDateComponents * dateComponent = [[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate: date];
    
    return [dateComponent year];
}

- (BOOL) equals: (SumaryCalendar *) sumaryCalendar date: (NSDate *) date {
    
    NSInteger day = [self getDay: date];
    NSInteger month = [self getMonth: date];
    NSInteger year = [self getYear: date];

    if (sumaryCalendar.day == day && sumaryCalendar.month == month && sumaryCalendar.year == year) {
        return YES;
    }
    
    return NO;
}

- (UIImageView *) getState: (SumaryCalendar *) sumaryCalendar {
    
    UIImageView * view = [[UIImageView alloc] initWithFrame: CGRectMake(((self.calendarContentView.bounds.size.width/7)/2)-13, -2, 26, 26)];
    
    if (sumaryCalendar.noSymptomAmount == 0) {
        
        view.image = [UIImage imageNamed: @"CircleRed.png"];
        
    } else if (sumaryCalendar.symptomAmount == 0) {
        
        view.image = [UIImage imageNamed: @"CircleGreen.png"];
        
    } else if (sumaryCalendar.noSymptomAmount == sumaryCalendar.symptomAmount) {
        
        view.image = [UIImage imageNamed: @"CircleHalf.png"];
        
    } else if (sumaryCalendar.noSymptomAmount < sumaryCalendar.symptomAmount) {
        
        view.image = [UIImage imageNamed: @"CircleRedHalf.png"];
        
    } else {
        
        view.image = [UIImage imageNamed: @"CircleGreenHalf.png"];
    }
    
    return view;
}

+ (UIColor *) toUiColor: (NSString *) hex {
    
    unsigned rgbValue = 0;
    
    NSScanner * scanner = [NSScanner scannerWithString: hex];
    
    [scanner setScanLocation: 1];
    [scanner scanHexInt: &rgbValue];
    
    return [UIColor colorWithRed: ((rgbValue & 0xFF0000) >> 16) / 255.0
                           green: ((rgbValue & 0xFF00) >> 8) / 255.0
                            blue: (rgbValue & 0xFF) / 255.0
                           alpha: 1.0];
}

-(void) showProgressBar{
    if (requestsInProcess == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    requestsInProcess ++;
}

-(void) hiddenProgressBar{
    requestsInProcess --;
    
    if (requestsInProcess == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (IBAction)btnNextMonthAction:(id)sender {
    [self.calendarContentView loadNextPageWithAnimation];
}

- (IBAction)btnPreviousMonthAction:(id)sender {
    [self.calendarContentView loadPreviousPageWithAnimation];
}

- (IBAction)btnChangePerson:(id)sender {
    ParticipantsListViewController *participantsListView = [[ParticipantsListViewController alloc] init];
    participantsListView.referenceDiaryHealthView = self;
    participantsListView.selectedUserId = selectedUser;
    
    [self.navigationController pushViewController:participantsListView animated:YES];
}

- (void)refreshInformationToUser:(Household *)houlsehold{
    if (houlsehold) {
        selectedUser = houlsehold.idHousehold;
        self.lbUserName.text = houlsehold.nick;
        self.imgPicture.image = [UIImage imageNamed:houlsehold.picture];
        
        [self refreshSummaryWithUserId:houlsehold.idHousehold];
        [self requestCalendar:houlsehold.idHousehold andDate:[NSDate date]];
        [self requestChartLine: houlsehold.idHousehold];
    }else{
        selectedUser = @"";
        self.lbUserName.text = user.nick;
        [user setAvatarImageAtButton:nil orImageView:self.imgPicture];
        
        [self refreshSummaryWithUserId:@""];
        [self requestCalendar:@"" andDate:[NSDate date]];
        [self requestChartLine: @""];
    }
}
@end
