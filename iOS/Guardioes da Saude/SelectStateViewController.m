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
    self.navigationItem.title = @"Guardiões da Saúde";
    
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
    
    params = @{@"user_id":user.idUser,
               @"lat":[NSString stringWithFormat:@"%.8f", latitude],
                @"lon":[NSString stringWithFormat:@"%.8f", longitude],
                @"app_token":user.app_token,
                @"platform":user.platform,
                @"client":user.client,
                @"no_symptom": @"Y",
                @"token":user.user_token};
    
    if (user.idHousehold) {
        [params setValue:user.idHousehold forKey:@"household_id"];
    }
    
    manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://52.20.162.21/survey/create"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              user.idHousehold = @"";
              ThankYouForParticipatingViewController *thankYouForParticipatingViewController = [[ThankYouForParticipatingViewController alloc] init];
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
