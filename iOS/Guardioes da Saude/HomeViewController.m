//
//  HomeViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 14/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "HomeViewController.h"
#import "User.h"
#import "SelectParticipantViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "MapHealthViewController.h"
#import "NoticeViewController.h"
#import "HealthTipsViewController.h"
#import "SWRevealViewController.h"
#import "TutorialViewController.h"
#import "DiaryHealthViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    
    CLLocationManager *locationManager;
    User *user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Guardiões da Saúde";

    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"gdSToolbar.png"] forBarMetrics:UIBarMetricsDefault];

    user = [User getInstance];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *userTokenKey = @"userTokenKey";
    
    if ([preferences objectForKey:userTokenKey] != nil) {
        NSString *userToken = [preferences valueForKey:userTokenKey];
        [self authorizedAutomaticLogin:userToken];
    } else {
        [self.imgUser setImage:[UIImage imageNamed:@"img_profile01.png"]];
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    // Do any additional setup after loading the view from its nib.
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    AFHTTPRequestOperationManager *manager;

    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
    [manager GET:@"http://52.20.162.21/symptoms"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             user.symptoms = responseObject[@"data"];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
    NSLog(@"Nick: %@", user.nick);
    self.txtNameUser.text = user.nick;
    
}

- (void) loadAvatar {
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
    [self.imgUser setImage:[UIImage imageNamed:avatar]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.revealViewController.panGestureRecognizer.enabled=NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}/
*/

-(void)showMenu:(id)sender  {
    NSLog(@"menu action");
}

- (IBAction)btnJoinNow:(id)sender {
    SelectParticipantViewController *selectParticipantViewController = [[SelectParticipantViewController alloc] init];
    [self.navigationController pushViewController:selectParticipantViewController animated:YES];
}

- (IBAction)btnMapHealth:(id)sender {
    MapHealthViewController *mapHealthViewController = [[MapHealthViewController alloc] init];
    [self.navigationController pushViewController:mapHealthViewController animated:YES];
}

- (IBAction)notice:(id)sender {
    NoticeViewController *noticeViewController = [[NoticeViewController alloc] init];
    [self.navigationController pushViewController:noticeViewController animated:YES];
}

- (IBAction)healthTips:(id)sender {
    HealthTipsViewController *healthTipsViewController = [[HealthTipsViewController alloc] init];
    [self.navigationController pushViewController:healthTipsViewController animated:YES];
}

- (IBAction)diaryHealth:(id)sender {
    DiaryHealthViewController *diaryHealthViewController = [[DiaryHealthViewController alloc] init];
    [self.navigationController pushViewController:diaryHealthViewController animated:YES];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    user.lat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    user.lon = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
}

- (BOOL) authorizedAutomaticLogin:(NSString *)userToken {
    
    AFHTTPRequestOperationManager *manager;
    
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"user_token"];
    [manager GET:@"http://52.20.162.21/user/lookup/"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([responseObject[@"error"] boolValue] == 1) {
                 user.user_token = nil;
             } else {
                 NSDictionary *response = responseObject[@"data"];
                 
                 user.nick = response[@"nick"];
                 user.email = response[@"email"];
                 user.gender = response[@"gender"];
                 user.picture = response[@"picture"];
                 user.idUser =  response[@"id"];
                 user.race = response[@"race"];
                 user.dob = response[@"dob"];
                 user.user_token = response[@"token"];
                 user.hashtag = response[@"hashtags"];
                 user.household = response[@"household"];
                 user.survey = response[@"surveys"];
                 
                 NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                 NSString *userKey = user.user_token;
                 
                 [preferences setValue:userKey forKey:@"userTokenKey"];
                 BOOL didSave = [preferences synchronize];
                 
                 if (!didSave) {
                     user.user_token = nil;
                 }
                 
                 self.txtNameUser.text = user.nick;
                [self loadAvatar];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             user.user_token = nil;
         }];
    
    if (user.user_token == nil) {
        return NO;
    } else {
        return YES;
    }
}
@end
