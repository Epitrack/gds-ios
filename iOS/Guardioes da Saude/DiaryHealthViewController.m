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
}

const float _kCellHeight = 100.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Diário da Saúde";
    
    // We will move this to the top?
    
    user = [User getInstance];
    buttons = [NSMutableArray array];
//    
    [self loadMainUser];
//    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
//    
//    //create table view to contain ASHorizontalScrollView
//    
    sampleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenHeight - 100, self.view.frame.size.width, self.view.frame.size.height)];
    sampleTableView.delegate = self;
    sampleTableView.dataSource = self;
    sampleTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:sampleTableView];
    
    //[self loadLabels:YES andUser:@""];
    
    [self loadChartPie];
    
    [self loadCalendar];
    
    [self loadChartLine];
    
    [self requestChartPie:@""];
    
    [self requestCalendar:@"" andDate:[NSDate date]];
    
    [self requestChartLine: @""];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

-(void) loadRequest {
    
    [self requestChartPie:@""];
    
    [self requestCalendar:@"" andDate:[NSDate date]];
    
    [self requestChartLine: @""];
}

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
                            goodPercent = no_symptom / total;
                        }
                        
                        if (total == 0) {
                            badPercent = 0;
                        } else {
                            badPercent = symptom / total;
                        }
                        
                        self.lbPercentGood.text = [[NSString stringWithFormat:@"%.02f", goodPercent] stringByAppendingString:@"%"];;
                        self.lbPercentBad.text = [[NSString stringWithFormat:@"%.02f", badPercent] stringByAppendingString:@"%"];
                        
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
    NSString *idHousehold = thumb.user_household_id;
    
    if ([idHousehold isEqualToString:user.idUser] || [idHousehold isEqualToString:@""]) {
        [self loadLabels:YES andUser:selectedUser];
        [self requestChartPie:@""];
        [self requestCalendar:@"" andDate:[NSDate date]];
        [self requestChartLine: @""];

        selectedUser = user.idUser;
    } else {
        [self loadLabels:NO andUser:selectedUser];
        [self requestChartPie:idHousehold];
        [self requestCalendar:idHousehold andDate:[NSDate date]];
        [self requestChartLine:idHousehold];

        selectedUser = idHousehold;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
}

- (void) loadChartPie {
    
    [self.chartView setUsePercentValuesEnabled: NO];
    [self.chartView setDescriptionText: @""];
    [self.chartView setDrawCenterTextEnabled: NO];
    [self.chartView setDrawSliceTextEnabled: NO];
    [self.chartView setDrawHoleEnabled: NO];
    [self.chartView setHoleTransparent: NO];
    [self.chartView setHoleRadiusPercent: 7];
    [self.chartView setTransparentCircleRadiusPercent: 10];
    [self.chartView setRotationAngle: 0];
    [self.chartView setRotationEnabled: NO];
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

- (void) requestChartPie: (NSString *)idHousehold {
    
    [[[UserRequester alloc] init] getSummary: [User getInstance]
     
                                    idHousehold:idHousehold
     
                                     onStart: ^{
                                         
                                     }
     
                                     onError: ^(NSString * message) {
                                         
                                     }
     
                                   onSuccess: ^(Sumary * sumary) {
                                       
                                       NSArray * xData = @[@"Mal", @"Bem"];
                                       
                                       NSArray * yData = @[[NSNumber numberWithInt: sumary.symptom * 100],
                                                           [NSNumber numberWithInt: sumary.noSymptom * 100]];
                                       
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
     ];
}

- (void) requestChartLine: (NSString *)idHousehold {
    
    [[[UserRequester alloc] init] getSummary: [User getInstance]
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
    
    [[[UserRequester alloc] init] getSummary: [User getInstance]
                                 idHousehold: idHousehold
                                       month: [self getMonth: date]
                                        year: [self getYear: date]
     
                                     onStart: ^{
                                         
                                     }
     
                                     onError: ^(NSString * message) {
                                         
                                     }
     
                                   onSuccess: ^(NSMutableDictionary * sumaryCalendarMap) {
                                       
                                       self.calendarMap = sumaryCalendarMap;
                                       
                                       [self.calendarManager reload];
                                   }
     ];
}

- (void) calendar: (JTCalendarManager *) calendar prepareDayView: (JTCalendarDayView *) dayView {
    
    if (self.calendarMap) {
        
        dayView.hidden = NO;
        
        if ([dayView isFromAnotherMonth]) {
            dayView.hidden = YES;
        }
        
        NSString * key = [NSString stringWithFormat: @"%li-%li-%li",
                          [self getDay: dayView.date], [self getMonth: dayView.date], [self getYear: dayView.date]];
        
        SumaryCalendar * sumaryCalendar = [self.calendarMap objectForKey: key];
        
        if (sumaryCalendar) {
            
            [dayView addSubview: [self getState: sumaryCalendar]];
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
