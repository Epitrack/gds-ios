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
#import "NoticeRequester.h"
#import "SingleNotice.h"
#import "ProgressBarUtil.h"
#import "ProfileListViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {
    
    CLLocationManager *locationManager;
    User *user;
    SingleNotice *singleNotice;
    UIImage *_defaultImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    user = [User getInstance];
    
    singleNotice = [SingleNotice getInstance];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *userTokenKey = @"userTokenKey";
    
    if ([preferences objectForKey:userTokenKey] != nil) {
        NSString *userToken = [preferences valueForKey:userTokenKey];
        [self authorizedAutomaticLogin:userToken];
    } else {
        [self.btnProfile setImage:[UIImage imageNamed:@"img_profile01.png"] forState:UIControlStateNormal];
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
    [manager GET:@"http://api.guardioesdasaude.org/symptoms"
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
    
    if ([user.picture isEqualToString:@"0"] || user.picture == nil) {
        user.picture = @"1";
        avatar = @"img_profile01.png";
    } else {
        
        if (user.picture.length == 1) {
            avatar = [NSString stringWithFormat: @"img_profile0%@.png", user.picture];
        } else if (user.picture.length == 2) {
            avatar = [NSString stringWithFormat: @"img_profile%@.png", user.picture];
        }
    }
    [self.btnProfile setImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
    UINavigationController *navCtr = self.navigationController;
    [navCtr setNavigationBarHidden:NO animated:animated];
    
    UIImage *imgTitleBar = [UIImage imageNamed:@"gdSToolbar"];
    [navCtr.navigationBar setBackgroundImage:imgTitleBar forBarMetrics:UIBarMetricsDefault];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];
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

- (IBAction)btnProfileAction:(id)sender {
    ProfileListViewController *profileListView = [[ProfileListViewController alloc] init];
    [self.navigationController pushViewController:profileListView animated:YES];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    user.lat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    user.lon = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
}

- (BOOL) authorizedAutomaticLogin:(NSString *)userToken {
    
    [ProgressBarUtil showProgressBarOnView:self.view];
    AFHTTPRequestOperationManager *manager;
    
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"user_token"];
    [manager GET:@"http://api.guardioesdasaude.org/user/lookup/"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [ProgressBarUtil hiddenProgressBarOnView:self.view];
             
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
                 [self loadNotices];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [ProgressBarUtil hiddenProgressBarOnView:self.view];
             NSLog(@"Error: %@", error);
             user.user_token = nil;
         }];
    
    if (user.user_token == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (void) loadNotices {
    
    [[[NoticeRequester alloc] init] getNotices:user
                                       onStart:^{}
                                       onError:^(NSString * message){}
                                     onSuccess:^(NSMutableArray *noticesRequest){
                                         singleNotice.notices = noticesRequest;
                                     }];
}
@end
