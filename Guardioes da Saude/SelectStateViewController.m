//
//  SelectStateViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 26/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectStateViewController.h"
#import "ThankYouForParticipatingViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "ListSymptomsViewController.h"
#import "SurveyRequester.h"
#import "SurveyMap.h"
#import "ViewUtil.h"
#import "MBProgressHUD.h"
#import <Google/Analytics.h>

@interface SelectStateViewController ()

@end

@implementation SelectStateViewController {
    
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
    SurveyRequester *surveyRequester;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Participe Agora";
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    surveyRequester = [[SurveyRequester alloc] init];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Select State Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnGood:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_good"
                                                           label:@"Good"
                                                           value:nil] build]];
    
    User *user = [User getInstance];
    
    SurveyMap *survey = [[SurveyMap alloc] init];
    survey.latitude = [NSString stringWithFormat:@"%.8f", latitude];
    survey.longitude = [NSString stringWithFormat:@"%.8f", longitude];
    survey.isSymptom = @"N";
    
    if (![user.idHousehold isEqualToString:@""]) {
        survey.idHousehold = user.idHousehold;
    }
    
    [surveyRequester createSurvey:survey
                       andOnStart:^{
                           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       }
                     andOnSuccess:^(bool isZika){
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         user.idHousehold = @"";
                         ThankYouForParticipatingViewController *thankYouForParticipatingViewController = [[ThankYouForParticipatingViewController alloc] initWithType:GOOD_SYMPTON];
                         thankYouForParticipatingViewController.txtBadSurvey.hidden = YES;
                         [self.navigationController pushViewController:thankYouForParticipatingViewController animated:YES];
                     }
                       andOnError:^(NSError *error){
                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                           NSString *errorMsg;
                           if (error && error.code == -1009) {
                               errorMsg = kMsgConnectionError;
                           } else {
                               errorMsg = kMsgApiError;
                           }
                           
                           [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                       }];
}

- (IBAction)btnBad:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_bad"
                                                           label:@"Bad"
                                                           value:nil] build]];
    
    ListSymptomsViewController *listSymptomsViewController = [[ListSymptomsViewController alloc] init];
    [self.navigationController pushViewController:listSymptomsViewController animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não estamos conseguindo obter sua localização. Verifique se os serviços estão habilitados no aparelho." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
    
}
@end
