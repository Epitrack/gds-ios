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
#import "MapHealthViewController.h"
#import "NoticeViewController.h"
#import "HealthTipsViewController.h"
#import "SWRevealViewController.h"
#import "TutorialViewController.h"
#import "DiaryHealthViewController.h"
#import "NoticeRequester.h"
#import "SingleNotice.h"
#import "ProfileListViewController.h"
#import "UserRequester.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ViewUtil.h"
#import <Google/Analytics.h>
@import Photos;

@interface HomeViewController ()

@end

@implementation HomeViewController {
    
    CLLocationManager *locationManager;
    User *user;
    SingleNotice *singleNotice;
    UIImage *_defaultImage;
    UserRequester *userRequester;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    
    user = [User getInstance];
    
    singleNotice = [SingleNotice getInstance];
    userRequester = [[UserRequester alloc] init];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if ([preferences objectForKey:kUserTokenKey] != nil && !user.nick) {
        NSString *userToken = [preferences valueForKey:kUserTokenKey];
        
        user.user_token = [preferences valueForKey:kUserTokenKey];
        user.app_token = [preferences valueForKey:kAppTokenKey];
        user.photo = [preferences valueForKey:kPhotoKey];
        user.avatarNumber = [preferences valueForKey:kAvatarNumberKey];
        user.nick = [preferences valueForKey:kNickKey];
        
        [self showInformations];
        
        [self authorizedAutomaticLogin:userToken];
    } else {
        [self showInformations];
    }
    

    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    // Do any additional setup after loading the view from its nib.
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
}

- (void) showInformations {
    
    self.txtNameUser.text = user.nick;
    self.lblOla.hidden = NO;
    self.btnProfile.hidden = NO;
    [user setAvatarImageAtButton:self.btnProfile orImageView:nil onBackground:NO isSmall:YES];
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
    
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Home Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
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
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_join_now"
                                                           label:@"Join Now"
                                                           value:nil] build]];
    
    if([UserRequester isConnected]){
        SelectParticipantViewController *selectParticipantViewController = [[SelectParticipantViewController alloc] init];
        [self.navigationController pushViewController:selectParticipantViewController animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (IBAction)btnMapHealth:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_map_health"
                                                           label:@"Map Health"
                                                           value:nil] build]];
    
    if ([UserRequester isConnected]) {
        MapHealthViewController *mapHealthViewController = [[MapHealthViewController alloc] init];
        [self.navigationController pushViewController:mapHealthViewController animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (IBAction)notice:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_notice"
                                                           label:@"Notice"
                                                           value:nil] build]];
    
    NoticeViewController *noticeViewController = [[NoticeViewController alloc] init];
    [self.navigationController pushViewController:noticeViewController animated:YES];
}

- (IBAction)healthTips:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_health_tips"
                                                           label:@"Health Tips"
                                                           value:nil] build]];
    
    HealthTipsViewController *healthTipsViewController = [[HealthTipsViewController alloc] init];
    [self.navigationController pushViewController:healthTipsViewController animated:YES];
}

- (IBAction)diaryHealth:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_diary_health"
                                                           label:@"Diary Health"
                                                           value:nil] build]];
    
    if ([UserRequester isConnected]) {
        DiaryHealthViewController *diaryHealthViewController = [[DiaryHealthViewController alloc] init];
        [self.navigationController pushViewController:diaryHealthViewController animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (IBAction)btnProfileAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_profile"
                                                           label:@"Profile"
                                                           value:nil] build]];
    
    if ([UserRequester isConnected]) {
        ProfileListViewController *profileListView = [[ProfileListViewController alloc] init];
        [self.navigationController pushViewController:profileListView animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    user.lat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    user.lon = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
}

- (void) authorizedAutomaticLogin:(NSString *)userToken {
    [userRequester lookupWithUsertoken:userToken
                               OnStart:^{
                                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                }andOnSuccess:^{
                                    [self loadSymptons];
                                    [self showInformations];
                                    [self loadNotices];
                                }andOnError:^(NSError *error){
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

-(void) loadSymptons{
    [userRequester getSymptonsOnStart:^{}
                           andSuccess:^{
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }
                           andOnError:^(NSError *error){
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               NSLog(@"Error: %@", error);
                           }];
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
