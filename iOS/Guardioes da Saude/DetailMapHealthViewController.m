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

@interface DetailMapHealthViewController () {
    
    DetailMap *detailMap;
}
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
    
    
    float goodPercent = [detailMap.goodPercent floatValue];
    float badPercent = [detailMap.badPercent floatValue];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:goodPercent color:PNGreen],
                       [PNPieChartDataItem dataItemWithValue:badPercent color:PNRed]];
    
    CGRect size = self.pieChartView.frame;
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, size.size.width, size.size.height) items:items];
    self.pieChart.showOnlyValues = YES;
    self.pieChart.showAbsoluteValues = NO;
    [self.pieChart strokeChart];
    
    [self.pieChartView addSubview:self.pieChart];
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