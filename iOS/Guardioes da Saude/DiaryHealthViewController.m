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
#import "ProgressBarUtil.h"

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
}

const float _kCellHeight = 100.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Diário da Saúde";
    
    // We will move this to the top?
    
    user = [User getInstance];
    userRequester = [[UserRequester alloc] init];
    buttons = [NSMutableArray array];
    firstTime = YES;
    
    [self loadMainUser];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    //create table view to contain ASHorizontalScrollView
    
    sampleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenHeight - 100, self.view.frame.size.width, self.view.frame.size.height)];
    sampleTableView.delegate = self;
    sampleTableView.dataSource = self;
    sampleTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:sampleTableView];
    
    [self loadCalendar];
    
    [self loadChartLine];
    
    [self requestCalendar:@"" andDate:[NSDate date]];
    
    [self requestChartLine: @""];
    
    [self refreshSummaryWithUserId:@""];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void) refreshSummaryWithUserId: (NSString *) userId{
    [ProgressBarUtil showProgressBarOnView:self.view];
    void(^onSuccess)(Sumary * sumary) = ^(Sumary * sumary){
        [self populateLabelsWithSummary:sumary];
        [ProgressBarUtil hiddenProgressBarOnView:self.view];
    };
    
    [userRequester getSummary: [User getInstance]
                                 idHousehold:userId
                                     onStart: ^{}
                                     onError: ^(NSString * message) {}
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
        goodPercent = (summary.noSymptom / summary.total) *100;
    }
    
    if (summary.total == 0) {
        badPercent = 0;
    } else {
        badPercent = (summary.symptom / summary.total)*100;
    }
    
    self.lbPercentGood.text = [NSString stringWithFormat:@"%g%%", goodPercent];
    self.lbPercentBad.text = [NSString stringWithFormat:@"%g%%", badPercent];
    
    [self populateChartWithGoodPercent:goodPercent andBadPercent:badPercent];
}

-(void) populateChartWithGoodPercent: (int) goodPercent andBadPercent: (int) badPecent{
    UIColor *goodColor = [UIColor colorWithRed:196.0f/255.0f green:209.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
    UIColor *badColor = [UIColor colorWithRed:200.0f/255.0f green:18.0f/255.0f blue:4.0f/255.0f alpha:1.0f];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:goodPercent color:goodColor],
                       [PNPieChartDataItem dataItemWithValue:badPecent color:badColor]];
    
    if (firstTime) {
        CGRect size = self.chartView.frame;
        
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, size.size.width, size.size.height) items:items];
        self.pieChart.showOnlyValues = YES;
        self.pieChart.showAbsoluteValues = NO;
        [self.pieChart strokeChart];
        
        [self.chartView addSubview:self.pieChart];
        
        firstTime = NO;
    }else{
        [self.pieChart updateChartData:items];
        [self.pieChart strokeChart];
    }
    
}



//-----------------


-(void) loadLabels:(BOOL)fristLoad andUser:(NSString *)idUSer {
    
    NSString * url;
    
    if (fristLoad) {
        url = [NSString stringWithFormat: @"%@/user/survey/summary", Url];
    } else {
        if ([selectedUser isEqualToString:user.idUser]) {
            url = [NSString stringWithFormat: @"%@/user/survey/summary", Url];
        } else {
            url = [NSString stringWithFormat: @"%@/household/survey/summary?household_id=%@", Url, selectedUser];
        }
    }
    
    AFHTTPRequestOperationManager *managerTotalSurvey;
    managerTotalSurvey = [AFHTTPRequestOperationManager manager];
    [managerTotalSurvey.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [managerTotalSurvey.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
    [managerTotalSurvey GET:url
                 parameters:nil
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *summary = responseObject[@"data"];
                       
                        long total = [summary[@"total"] integerValue];
                        long no_symptom = [summary[@"no_symptom"] integerValue];
                        long symptom = [summary[@"symptom"] integerValue];
                        
                        self.lbTotalParticipation.text = [NSString stringWithFormat:@"%ld",total];
                        self.lbTotalReportGood.text = [NSString stringWithFormat:@"%ld",no_symptom];
                        self.lbTotalReportBad.text = [NSString stringWithFormat:@"%ld",symptom];
                        
                        double goodPercent;
                        double badPercent;
                        
                        if (total == 0) {
                            goodPercent = 0;
                        } else {
                            goodPercent = (no_symptom / total) *100;
                        }
                        
                        if (total == 0) {
                            badPercent = 0;
                        } else {
                            badPercent = (symptom / total)*100;
                        }
                        
                        self.lbPercentGood.text = [NSString stringWithFormat:@"%g%%", goodPercent];
                        self.lbPercentBad.text = [NSString stringWithFormat:@"%g%%", badPercent];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                    }];
}

#pragma tableview datasource
- (void)loadMainUser {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(button.bounds.size.width/4,
                                         5,
                                         button.bounds.size.width/2,
                                         button.bounds.size.height/2)];
    
    NSString *avatar;
    
    if ([user.picture isEqualToString:@"0"]) {
        avatar = @"img_profile01.png";
    } else {
        if (user.picture.length == 1) {
            avatar = [NSString stringWithFormat: @"img_profile0%@.png", user.picture];
        } else if (user.picture.length == 2) {
            avatar = [NSString stringWithFormat: @"img_profile%@.png", user.picture];
        }
    }
    
    [imageView setImage:[UIImage imageNamed:avatar]];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(button.bounds.size.width/4, 50, button.bounds.size.width/2, button.bounds.size.height/2)];
    label.text= user.nick;
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
            horizontalScrollView.uniformItemSize = CGSizeMake(100, 100);
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
    }else{
        [self refreshSummaryWithUserId:@""];
        
        selectedUser = @"";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
}

- (void) loadChartLine {
    
    self.graphView.useCurvedLine = YES;
    self.graphView.graphWidth = 375;
    
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
    
    [self.calendarManager setMenuView: self.calendarMenuView];
    [self.calendarManager setContentView: self.calendarContentView];

    [self.calendarManager setDate: [NSDate date]];
}


- (void) requestChartLine: (NSString *)idHousehold {
    
    [userRequester getSummary: [User getInstance]
                                 idHousehold: idHousehold
                                        year: 2015
     
                                     onStart: ^{
                                         
                                     }
     
                                     onError: ^(NSString * message) {
                                         
                                     }
     
                                   onSuccess: ^(NSMutableDictionary * sumaryGraphMap) {
                                       
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
                                       
                                       self.graphView.graphData = valueArray;
                                       
                                       self.graphView.graphDataLabels = @[@"Jan", @"Fev", @"Mar", @"Abr", @"Mai", @"Jun", @"Jul", @"Ago", @"Set", @"Out", @"Nov", @"Dev"];
                                       
                                       [self.graphView plotGraphData];
                                   }
     ];
}

- (void) requestCalendar: (NSString *)idHousehold andDate:(NSDate *) date {
    
    void (^onSuccess)(NSMutableDictionary * sumaryCalendarMap) = ^void(NSMutableDictionary * sumaryCalendarMap){
        [self.calendarMap removeAllObjects];
        self.calendarMap = sumaryCalendarMap;

        [self.calendarManager reload];
    };
    
    [userRequester getSummary: [User getInstance]
                                 idHousehold: idHousehold
                                       month: [self getMonth: date]
                                        year: [self getYear: date]
                                     onStart: ^{}
                                     onError: ^(NSError * error){}
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
            NSLog(@"key = %@", key);
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

@end
