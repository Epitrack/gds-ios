#import "ChartViewController.h"
#import "UserRequester.h"
#import "User.h"
#import "Sumary.h"
#import "JYGraphView.h"
#import "SumaryGraph.h"
#import "SumaryCalendar.h"
#import "HouseholdRequester.h"
#import <JTCalendar/JTCalendar.h>

@import Charts;

@interface ChartViewController () <JTCalendarDelegate>

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

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadChartPie];
    
    [self loadChartLine];
    
    [self loadCalendar];
    
    [self login];
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
    self.graphView.labelFontColor = [ChartViewController toUiColor: @"#186cb7"];
    
    self.graphView.strokeColor = [ChartViewController toUiColor: @"#186cb7"];
    self.graphView.pointFillColor = [ChartViewController toUiColor: @"#186cb7"];
    
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

- (void) login {
    
    User * user = [[User alloc] init];
    
    user.email = @"recoba@gmail.com";
    user.password = @"qwerty";
    
    [[[UserRequester alloc] init] login: user
     
            onStart: ^{
                
            }

            onError: ^(NSString * message) {
                
            }

            onSuccess: ^(User * user) {
                
                [self requestChartPie];
                
                [self requestChartLine];
                
                [self requestCalendar];
            }
    ];
}

- (void) requestChartPie {
    
    [[[UserRequester alloc] init] getSummary: [User getInstance]

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
                 
                 [colorArray addObject: [ChartViewController toUiColor: @"#FF0000"]];
                 [colorArray addObject: [ChartViewController toUiColor: @"#CCCC00"]];
                 
                 [dataSet setColors: colorArray];
                 
                 PieChartData * data = [[PieChartData alloc] initWithXVals: xArray dataSet: dataSet];
                 
                 [data setDrawValues: NO];
                 [data setHighlightEnabled: NO];
                 
                 [self.chartView setData: data];
                 
                 [self.chartView setNeedsDisplay];
             }
     ];
}

- (void) requestChartLine {
    
    [[[UserRequester alloc] init] getSummary: [User getInstance]
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

- (void) requestCalendar {
    
    [[[UserRequester alloc] init] getSummary: [User getInstance]
                                       month: 11
                                        year: 2015

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
        
        if ([dayView isFromAnotherMonth]) {
            dayView.hidden = YES;
            
        } else {
            
            NSNumber * day = [NSNumber numberWithInteger: [self getDay: dayView.date]];
            
            SumaryCalendar * sumaryCalendar = [self.calendarMap objectForKey: day];
            
            if (sumaryCalendar) {
                
                [dayView addSubview: [self getState: sumaryCalendar]];
            }
        }
    }
}

- (NSInteger) getDay: (NSDate *) date {
    
    NSDateComponents * dateComponent = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: date];
    
    return [dateComponent day];
}

- (UIImageView *) getState: (SumaryCalendar *) sumaryCalendar {
    
    UIImageView * view = [[UIImageView alloc] initWithFrame: CGRectMake(9, 0, 23, 23)];
    view.alpha = 0.5;
    
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
