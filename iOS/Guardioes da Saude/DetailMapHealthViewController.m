//
//  DetailMapHealthViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 30/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "DetailMapHealthViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "DetailMap.h"
#import "MapHealthViewController.h"
@import Charts;

@interface DetailMapHealthViewController () {
    
    DetailMap *detailMap;
}
@property (nonatomic, weak) IBOutlet PieChartView * pieChartView;

@end

@implementation DetailMapHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Mapa da Saúde";
    
    detailMap = [DetailMap getInstance];
    
    self.txtCity.text = detailMap.city;
    self.txtState.text = detailMap.state;
    self.txtCountParticipation.text = detailMap.totalSurvey;
    self.txtPercentGood.text = detailMap.goodPercent;
    self.txtPercentBad.text = detailMap.badPercent;
    self.txtCountGood.text = detailMap.totalNoSymptom;
    self.txtCountBad.text = detailMap.totalWithSymptom;
    self.progressViewDiarreica.progress = ([detailMap.diarreica doubleValue]/100);
    self.progressViewExantematica.progress = ([detailMap.exantemaica doubleValue]/100);
    self.progessViewRespiratoria.progress = ([detailMap.respiratoria doubleValue]/100);
    
    self.lbPercentDiareica.text = [NSString stringWithFormat:@"%g%%", [detailMap.diarreica doubleValue]];
    self.lbPercentExantematica.text = [NSString stringWithFormat:@"%g%%", [detailMap.exantemaica doubleValue]];
    self.lbPercentRespiratoria.text =[NSString stringWithFormat:@"%g%%", [detailMap.respiratoria doubleValue]];
    
    [self loadPieChart];
}

-(void) loadPieChart{
    float goodPercent = [detailMap.goodPercent floatValue];
    float badPercent = [detailMap.badPercent floatValue];
    
    [self.pieChartView setUsePercentValuesEnabled: NO];
    [self.pieChartView setDescriptionText: @""];
    [self.pieChartView setDrawCenterTextEnabled: NO];
    [self.pieChartView setDrawSliceTextEnabled: NO];
    [self.pieChartView setHoleTransparent: NO];
    [self.pieChartView setDrawHoleEnabled: NO];
    [self.pieChartView setRotationEnabled: NO];
    self.pieChartView.legend.enabled = NO;

    
    NSArray * xData = @[@"Mal", @"Bem"];
    
    NSArray * yData = @[[NSNumber numberWithInt: goodPercent],
                        [NSNumber numberWithInt: badPercent]];
    
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
    
    [colorArray addObject: [UIColor colorWithRed:196.0f/255.0f green:209.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
    [colorArray addObject: [UIColor colorWithRed:200.0f/255.0f green:18.0f/255.0f blue:4.0f/255.0f alpha:1.0f]];
    
    [dataSet setColors: colorArray];
    
    PieChartData * data = [[PieChartData alloc] initWithXVals: xArray dataSet: dataSet];
    
    [data setDrawValues: NO];
    [data setHighlightEnabled: NO];
    
    [self.pieChartView setData: data];
    [self.pieChartView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnInfoAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"As síndromes são conjuntos de manifestações clínicas comuns a um número de doenças, entre elas: diarreica (febre, diarreia, náusea ou vômito), respiratória (febre, tosse e dor de garganta) e exantemática (febre, exantema, tosse, dor nas articulações e dor de cabeça)." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end