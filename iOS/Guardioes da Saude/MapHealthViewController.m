//
//  MapHealthViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 29/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "MapHealthViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "SurveyMap.h"
#import "DetailMapHealthViewController.h"
#import "DetailMap.h"
#import "MapPinAnnotation.h"
#import "LocationUtil.h"
#import "LocationUtil.h"
#import <MRProgress/MRProgress.h>
@import Charts;

@interface MapHealthViewController ()
@property (nonatomic, weak) IBOutlet PieChartView * pieChartView;
@end

@implementation MapHealthViewController {
    
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
    NSString *city;
    NSString *state;
    NSInteger totalSurvey;
    NSInteger totalNoSymptom;
    double goodPercent;
    NSInteger totalWithSymptom;
    double badPercent;
    double diarreica;
    double exantemaica;
    double respiratoria;
    User *user;
    DetailMap *detailMap;
    BOOL showDetails;
    
    //Animation slide values
    CGRect startBtnRect;
    NSNumber *slidePositionView;
    NSNumber *slidePositionButton;
    UIImage *imgFabCancel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Mapa da Saúde";
    //latitude = -22.9035393;
    //longitude = -22.9035393;
    self.mapHealth.showsUserLocation = YES;
    self.mapHealth.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    user = [User getInstance];
    detailMap = [DetailMap getInstance];
    showDetails = NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    startBtnRect = self.btnDetails.frame;
    
    imgFabCancel = [UIImage imageNamed:@"fab_cancel"];

    [self loadSurvey];
    self.seach.delegate = self;
}

- (void) loadSurvey {
    if (latitude == 0) {
        latitude = [user.lat doubleValue];
    }
    
    if (longitude == 0) {
        longitude = [user.lon doubleValue];
    }
    
    surveysMap = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat: @"http://api.guardioesdasaude.org/surveys/l?lon=%f&lat=%f", longitude, latitude];
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *surveys = responseObject[@"data"];
             
             for (NSDictionary *item in surveys) {
                 NSString *surveyLatitude = item[@"lat"];
                 NSString *surveyLongitude = item[@"lon"];
                 NSString *isSymptom = item[@"no_symptom"];
                 NSString *survey_id = item[@"id"];

                 NSLog(@"surveyLatitude: %@", surveyLatitude);
                 NSLog(@"surveyLongitude: %@", surveyLongitude);
                 
                 if (surveyLatitude != 0 || surveyLongitude != 0) {
                     SurveyMap *s = [[SurveyMap alloc] initWithLatitude:surveyLatitude andLongitude:surveyLongitude andSymptom:isSymptom];
                     s.survey_id = survey_id;
                     [surveysMap addObject:s];
                 }
             }
             [self addPin];
             
             [self loadSummary];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Infelizmente não conseguimos conlcuir esta operação. Tente novamente dentro de alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                 NSLog(@"You pressed button OK");
             }];
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
             NSLog(@"Error: %@", error);
         }];

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

- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
    MKAnnotationView *v = [views objectAtIndex:0];
    CLLocationDistance distance = 2000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([v.annotation coordinate], distance, distance);
    [self.mapHealth setRegion:region animated:YES];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
}

- (MKAnnotationView *) mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation> ) annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != mv.userLocation){
        MapPinAnnotation *pinA = (MapPinAnnotation *) annotation;
        pinView = (MKAnnotationView *)[mv dequeueReusableAnnotationViewWithIdentifier:pinA.survey_id];
        if ( pinView == nil ) {
            pinView = [[MKAnnotationView alloc]
                    initWithAnnotation:annotation reuseIdentifier:pinA.survey_id];
        }
        pinView.canShowCallout = YES;
        if ([pinA.isSymptom isEqualToString:@"Y"]) {
            pinView.image = [UIImage imageNamed:@"icon_pin_well.png"];
        } else {
            pinView.image = [UIImage imageNamed:@"icon_pin_bad.png"];
        }
    } else {
        [mv.userLocation setTitle:user.nick];
        static NSString *defaultPinID = @"user";
        
        pinView = (MKAnnotationView *)[mv dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) {
            pinView = [[MKAnnotationView alloc]
                    initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"icon_pin_userlocation.png"];
    }
    return pinView;
}

- (void) addPin {
    
    @try {
        if (surveysMap.count > 0) {
            for (SurveyMap *s in surveysMap) {
                
                double surveyLatitude =[s.latitude doubleValue];
                double surveyLongitude = [s.longitude doubleValue];
                NSString *isSymptom = s.isSymptom;
                
                CLLocationCoordinate2D annotationCoord;
                annotationCoord.latitude = surveyLatitude;
                annotationCoord.longitude = surveyLongitude;
                
//                MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
                MapPinAnnotation *pin = [[MapPinAnnotation alloc] init];
                pin.coordinate = annotationCoord;
                pin.isSymptom = isSymptom;
                pin.survey_id = s.survey_id;
                
                if ([isSymptom isEqualToString:@"Y"]) {
                    pin.title = @"Estou Bem :)";
                    //pin.pin
                } else {
                    pin.title = @"Estou Mal :(";
                }
                
                [self.mapHealth addAnnotation:pin];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception.description);
    }
}

- (void) loadSummary {
    
    NSString *url = [NSString stringWithFormat: @"http://api.guardioesdasaude.org/surveys/summary/?lon=%f&lat=%f", longitude, latitude];
    AFHTTPRequestOperationManager *managerTotalSurvey;
    managerTotalSurvey = [AFHTTPRequestOperationManager manager];
    [managerTotalSurvey.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [managerTotalSurvey.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
    [managerTotalSurvey GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *summary = responseObject[@"data"];
             NSDictionary *location = summary[@"location"];
             NSDictionary *diseases = summary[@"diseases"];
             
             if (summary.count > 0) {
             
                 city = location[@"city"];
                 state = [LocationUtil getStateByUf:location[@"state"]];
                 totalSurvey = [summary[@"total_surveys"] integerValue];
                 
                 totalNoSymptom = [summary[@"total_no_symptoms"] integerValue];
                 
                 if (totalNoSymptom > 0) {
                     goodPercent = (((double)totalNoSymptom / (double)totalSurvey) * 100);
                 } else {
                     goodPercent = 0;
                 }
                 
                 totalWithSymptom = [summary[@"total_symptoms"] integerValue];
                 
                 if (totalWithSymptom > 0) {
                     badPercent = (((double)totalWithSymptom / (double)totalSurvey) * 100);
                 } else {
                     badPercent = 0;
                 }
                 
                 diarreica = [diseases[@"diarreica"] doubleValue];
                 exantemaica = [diseases[@"exantematica"] doubleValue];
                 respiratoria = [diseases[@"respiratoria"] doubleValue];
                 
                 if (totalWithSymptom > 0) {
                     diarreica = ((diarreica * 100) / (totalWithSymptom + totalNoSymptom));
                     exantemaica = ((exantemaica * 100) / (totalWithSymptom + totalNoSymptom));
                     respiratoria = ((respiratoria * 100) / (totalWithSymptom + totalNoSymptom));
                 }
                 
                 self.lblCity.text = city;
                 self.lblState.text = state;
                 self.lblPaticipation.text = [NSString stringWithFormat:@"%d Participações essa semana", (int)totalSurvey];
                 
                 detailMap.city = city;
                 detailMap.state = state;
                 detailMap.totalSurvey = [NSString stringWithFormat:@"%d", (int)totalSurvey];
                 detailMap.goodPercent = [NSString stringWithFormat:@"%d%%", (int)goodPercent];
                 detailMap.badPercent = [NSString stringWithFormat:@"%d%%", (int)badPercent];
                 detailMap.totalNoSymptom = [NSString stringWithFormat:@"%d", totalNoSymptom];
                 detailMap.totalWithSymptom = [NSString stringWithFormat:@"%d", totalWithSymptom];
                 
                 detailMap.diarreica = [NSString stringWithFormat:@"%f", diarreica];
                 detailMap.exantemaica = [NSString stringWithFormat:@"%f", exantemaica];
                 detailMap.respiratoria = [NSString stringWithFormat:@"%f", respiratoria];
                 
                 [self loadDetails];
                 [self loadPieChart];
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void) loadDetails{
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
}

-(void) loadPieChart{
    float goodPercentLocal = [detailMap.goodPercent floatValue];
    float badPercentLocal = [detailMap.badPercent floatValue];
    
    [self.pieChartView setUsePercentValuesEnabled: NO];
    [self.pieChartView setDescriptionText: @""];
    [self.pieChartView setDrawCenterTextEnabled: NO];
    [self.pieChartView setDrawSliceTextEnabled: NO];
    [self.pieChartView setHoleTransparent: NO];
    [self.pieChartView setDrawHoleEnabled: NO];
    [self.pieChartView setRotationEnabled: NO];
    self.pieChartView.legend.enabled = NO;
    
    
    NSArray * xData = @[@"Mal", @"Bem"];
    
    NSArray * yData = @[[NSNumber numberWithInt: goodPercentLocal],
                        [NSNumber numberWithInt: badPercentLocal]];
    
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

- (IBAction)showDetailMapHealth:(id)sender {
    DetailMapHealthViewController *detailMapHealthViewController = [[DetailMapHealthViewController alloc] init];
    [self.navigationController pushViewController:detailMapHealthViewController animated:YES];
    
}

- (IBAction)showDetailMapPlus:(id)sender {
    CABasicAnimation *animationView = [CABasicAnimation animationWithKeyPath:@"position.y"];
    showDetails = !showDetails;
    
    if (showDetails) {
        animationView.toValue = @(([UIScreen mainScreen].bounds.size.height*.3)+(self.detailsView.frame.size.height/2));
        [self.seach setUserInteractionEnabled:NO];
        [UIView animateWithDuration:.25 animations:^{
            CGRect rect = self.btnDetails.frame;
            self.btnDetails.frame = CGRectMake(rect.origin.x, ([UIScreen mainScreen].bounds.size.height * .3)-(self.btnDetails.frame.size.height/2), rect.size.width, rect.size.height);
        }];
    }else{
        animationView.fromValue = @(([UIScreen mainScreen].bounds.size.height*.3)+(self.detailsView.frame.size.height/2));
        animationView.toValue = 0;
        [self.seach setUserInteractionEnabled:YES];
        [UIView animateWithDuration:.25 animations:^{
            CGRect rect = self.btnDetails.frame;
            self.btnDetails.frame = CGRectMake(rect.origin.x, self.detailsView.frame.origin.y - (self.btnDetails.frame.size.height/2), rect.size.width, rect.size.height);
        }];
    }
    
    animationView.removedOnCompletion = NO;
    animationView.fillMode = kCAFillModeForwards;

    [self.detailsView.layer addAnimation:animationView forKey:@"position.y"];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.seach resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [LocationUtil getLocationByAddress:self.seach.text onSuccess:^(NSString *lng, NSString *lat, NSString *fullNameCity){
        longitude = [lng doubleValue];
        latitude = [lat doubleValue];
        [self loadSurvey];
        
        CLLocationCoordinate2D coordenada = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
        CLLocationDistance distance = 2000;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordenada, distance, distance);
        [self.mapHealth setRegion:region animated:YES];
    }onFail:^(NSError *error){
        
    }];
    
}

- (IBAction)btnInfoAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"As síndromes são conjuntos de manifestações clínicas comuns a um número de doenças, entre elas: \nDiarreica (febre e náusea ou vômito, além de algum destes sintomas: dores no corpo ou dor de cabeça)\nRespiratória (febre, além de algum destes sintomas: tosse ou dor de garganta ou falta de ar ou manchas vermelhas no corpo)\nExantemática (manchas vermelhas no corpo, além de algum destes sintomas: febre ou dores no corpo ou dores nas juntas ou dor de cabeça ou coceira ou olhos vermelhos ou sangramento)" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
