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

@interface SelectStateViewController ()

@end

@implementation SelectStateViewController {
    
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnGood:(id)sender {
    
    NSDictionary *params;
    AFHTTPRequestOperationManager *manager;
    User *user = [User getInstance];
    
    if ([user.idHousehold isEqualToString:@""] || user.idHousehold  == nil) {
        params = @{@"user_id":user.idUser,
                   @"lat":[NSString stringWithFormat:@"%.8f", latitude],
                   @"lon":[NSString stringWithFormat:@"%.8f", longitude],
                   @"app_token":user.app_token,
                   @"platform":user.platform,
                   @"client":user.client,
                   @"no_symptom": @"Y",
                   @"token":user.user_token};
    } else {
        params = @{@"user_id":user.idUser,
                   @"lat":[NSString stringWithFormat:@"%.8f", latitude],
                   @"lon":[NSString stringWithFormat:@"%.8f", longitude],
                   @"app_token":user.app_token,
                   @"platform":user.platform,
                   @"client":user.client,
                   @"no_symptom": @"Y",
                   @"token":user.user_token,
                   @"household_id": user.idHousehold};
    }
    
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager POST:@"http://api.guardioesdasaude.org/survey/create"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              user.idHousehold = @"";
              ThankYouForParticipatingViewController *thankYouForParticipatingViewController = [[ThankYouForParticipatingViewController alloc] initWithType:GOOD_SYMPTON];
              thankYouForParticipatingViewController.txtBadSurvey.hidden = YES;
              [self.navigationController pushViewController:thankYouForParticipatingViewController animated:YES];
          
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Infelizmente não conseguimos conlcuir está operação. Tente novamente dentro de alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
              UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                  NSLog(@"You pressed button OK");
              }];
              [alert addAction:defaultAction];
              [self presentViewController:alert animated:YES completion:nil];
              
          }];
}

- (IBAction)btnBad:(id)sender {
    
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
