//
//  DiaryHealthViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 16/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "DiaryHealthViewController.h"
#import "Household.h"
#import "User.h"
#import "UserRequester.h"
#import "Sumary.h"
#import "JYGraphView.h"
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
@import Photos;

@import Charts;

@interface DiaryHealthViewController () <JTCalendarDelegate>

// Pizza graph
@property (nonatomic, weak) IBOutlet PieChartView * chartView;

// Line graph
@property (nonatomic, weak) IBOutlet JYGraphView * graphView;

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
    self.navigationItem.title = @"Diário da Saúde";
    
    // We will move this to the top?
    
    selectedUser = @"";
    user = [User getInstance];
    userRequester = [[UserRequester alloc] init];
    buttons = [NSMutableArray array];
    firstTime = YES;
    
    [self loadMainUser];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //create table view to contain ASHorizontalScrollView
    
    sampleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenHeight - 95, self.view.frame.size.width, self.view.frame.size.height)];
    sampleTableView.delegate = self;
    sampleTableView.dataSource = self;
    sampleTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sampleTableView.alwaysBounceVertical = NO;
    [self.view addSubview:sampleTableView];
    
    [self loadCalendar];
    
    [self loadChartLine];
    
    [self refreshSummaryWithUserId:@""];
    
    [self requestCalendar:@"" andDate:[NSDate date]];
    
    [self requestChartLine: @""];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Diary Health Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void) refreshSummaryWithUserId: (NSString *) userId{
    void(^onSuccess)(Sumary * sumary) = ^(Sumary * sumary){
        [self populateLabelsWithSummary:sumary];
        [self hiddenProgressBar];
    };
    
    [userRequester getSummary: [User getInstance]
                                 idHousehold:userId
                                     onStart: ^{[self showProgressBar];}
                                     onError: ^(NSError * error) {
                                         [self hiddenProgressBar];
                                         NSString *errorMsg;
                                         if (error && error.code == -1009) {
                                             errorMsg = kMsgConnectionError;
                                         } else {
                                             errorMsg = kMsgApiError;
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
        goodPercent = (summary.noSymptom * 100) / summary.total;
    }
    
    if (summary.total == 0) {
        badPercent = 0;
    } else {
        badPercent = (summary.symptom * 100) / summary.total;
    }
    
    self.lbPercentGood.text = [NSString stringWithFormat:@"%g%%", goodPercent];
    self.lbPercentBad.text = [NSString stringWithFormat:@"%g%%", badPercent];
    
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
    
    [user setAvatarImageAtButton:nil orImageView:imageView onBackground:NO isSmall:NO];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        if (indexPath.row == 0) {
            //sample code of how to use this scroll view
            ASHorizontalScrollView *horizontalScrollView = [[ASHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, _kCellHeight)];
            [cell.contentView addSubview:horizontalScrollView];
            horizontalScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            CGFloat widthScreen = [UIScreen mainScreen].bounds.size.width;
            
            int width = 150;
            if (widthScreen <= 320) {
                width = 120;
            }
            
            
            horizontalScrollView.uniformItemSize = CGSizeMake(width, 100);
            //this must be called after changing any size or margin property of this class to get acurrate margin
            [horizontalScrollView setItemsMarginOnce];
            NSDictionary *households = user.household;
            
            if (households.count > 0) {
                
                for (NSDictionary *h in households) {
                    
                    NSString *nick = h[@"nick"];
                    NSString *picture = h[@"picture"];
                    NSString *avatar;
                    NSString *idHousehold = h[@"id"];
                    
                    if ([picture isEqualToString:@"0"]) {
                        avatar = @"img_profile01.png";
                    } else {
                        
                        if (picture.length == 1) {
                            avatar = [NSString stringWithFormat: @"img_profile0%@.png", picture];
                        } else if (picture.length == 2) {
                            avatar = [NSString stringWithFormat: @"img_profile%@.png", picture];
                        }
                    }
                    
                    HouseholdThumbnail *thumb = [[HouseholdThumbnail alloc] initWithHousehold:idHousehold frame:CGRectMake(0, 0, 150, 150) avatar:avatar nick:nick];
                    [buttons addObject:thumb];
                    [thumb.button addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                if ([UIScreen mainScreen].bounds.size.width >= 375 ) {
                    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
                    [buttons addObject:blankView];
                }
                
                [horizontalScrollView addItems:buttons];
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _kCellHeight;
}

- (void) pushAction: (id)sender {

    UIButton *b = (UIButton *) sender;
    HouseholdThumbnail *thumb = (HouseholdThumbnail*) b.superview;
    if ([thumb isKindOfClass: [HouseholdThumbnail class]]) {
        NSString *idHousehold = thumb.user_household_id;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
}

- (void) loadChartLine {
    
    self.graphView.useCurvedLine = YES;

    
    self.graphView.tintColor = [UIColor whiteColor];
    self.graphView.labelBackgroundColor = [UIColor whiteColor];
    self.graphView.labelFontColor = [DiaryHealthViewController toUiColor: @"#186cb7"];
    
    self.graphView.strokeColor = [DiaryHealthViewController toUiColor: @"#186cb7"];
    self.graphView.pointFillColor = [DiaryHealthViewController toUiColor: @"#186cb7"];

    self.graphView.barColor = [UIColor clearColor];
    self.graphView.backgroundViewColor = [UIColor whiteColor];
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
                                        year: [DateUtil getCurrentYear]
                                     onStart: ^{[self showProgressBar];}
                                     onError: ^(NSError * error) {
                                         [self hiddenProgressBar];
                                         NSString *errorMsg;
                                         if (error && error.code == -1009) {
                                             errorMsg = kMsgConnectionError;
                                         } else {
                                             errorMsg = kMsgApiError;
                                         }
                                         
                                         [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                     }
                                   onSuccess: ^(NSMutableDictionary * sumaryGraphMap) {
                                       [self hiddenProgressBar];
                                       
                                       self.lbFrequencyYear.text = [NSString stringWithFormat:@"Frequência %d", [DateUtil getCurrentYear]];
                                       
                                       for (int i = 1; i <= 12; i++) {
                                           
                                           if (![sumaryGraphMap objectForKey: [NSNumber numberWithInt: i]]) {
                                               
                                               SumaryGraph * sumaryGraph = [[SumaryGraph alloc] init];
                                               
                                               sumaryGraph.month = i;
                                               sumaryGraph.percent = 0;
                                               
                                               [sumaryGraphMap setObject: sumaryGraph forKey: [NSNumber numberWithInt: i]];
                                           }
                                       }
                                       
                                       NSMutableArray * valueArray = [NSMutableArray array];
                                       
                                       for (int i = 1; i <= sumaryGraphMap.count; i++) {
                                           
                                           SumaryGraph * sumaryGraph = [sumaryGraphMap objectForKey: [NSNumber numberWithInt: i]];
                                           
                                           [valueArray addObject: [NSNumber numberWithFloat: sumaryGraph.percent]];
                                       }
                                       
                                       
                                       self.graphView.labelFont = [UIFont fontWithName:@"Foco-Regular" size:11.5];
                                       self.graphView.graphWidth = self.graphView.frame.size.width;
                                       
                                       self.graphView.graphDataLabels = @[@"Jan", @"Fev", @"Mar", @"Abr", @"Mai", @"Jun", @"Jul", @"Ago", @"Set", @"Out", @"Nov", @"Dez"];
                                   
                                       UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.graphView.frame.size.width, self.graphView.frame.size.height)];
                                       [blankView setBackgroundColor: [UIColor whiteColor]];
                                       [self.graphView addSubview:blankView];
                                       
                                       
                                       self.graphView.graphData = valueArray;
                                       [self.graphView plotGraphData];
                                       
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
                                             errorMsg = kMsgConnectionError;
                                         } else {
                                             errorMsg = kMsgApiError;
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
                          [self getDay: dayView.date], [self getMonth: dayView.date], [self getYear: dayView.date]];
        
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
    
    UIImageView * view = [[UIImageView alloc] initWithFrame: CGRectMake(9, 0, 23, 23)];
    
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

@end
