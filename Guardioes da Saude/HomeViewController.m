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
#import "SelectStateViewController.h"
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
#import "MenuViewController.h"
#import "DateUtil.h"
#import "Guardioes_da_Saude-Swift.h"
#import "LocationUtil.h"


@import Photos;

@interface HomeViewController (){
    UIImageView *titleImgView;
}

@end

@implementation HomeViewController {
    
    CLLocationManager *locationManager;
    User *user;
    SingleNotice *singleNotice;
    UIImage *_defaultImage;
    UserRequester *userRequester;
    NSUserDefaults *preferences;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    user = [User getInstance];
    
    singleNotice = [SingleNotice getInstance];
    userRequester = [[UserRequester alloc] init];
    
    preferences = [NSUserDefaults standardUserDefaults];
    NSString *strLastJoinNotification = [preferences objectForKey:kLastJoinNotification];
    if (strLastJoinNotification) {
        user.lastJoinNotification = [DateUtil dateFromStringUS:strLastJoinNotification];
    }
    
    if ([preferences objectForKey:kUserTokenKey] != nil && !user.user_token) {
        NSString *userToken;
        
        if (user.user_token) {
            userToken = user.user_token;
        }else{
            userToken = [preferences valueForKey:kUserTokenKey];
        }
        
        if ([preferences objectForKey:kIsTest]) {
            user.isTest = YES;
        }
        
        user.user_token = [preferences valueForKey:kUserTokenKey];
        user.app_token = [preferences valueForKey:kAppTokenKey];
        user.photo = [preferences valueForKey:kPhotoKey];
        user.avatarNumber = [preferences valueForKey:kAvatarNumberKey];
        user.nick = [preferences valueForKey:kNickKey];
        user.isGameTutorailReady = ([preferences valueForKey: kGameTutorialReady] != nil);
        
        [self showInformations];
        
        [self authorizedAutomaticLogin:userToken];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self showInformations];
        [self checkLastSurvey];
    }
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem;
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"ar"]) {
        revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                             style:UIBarButtonItemStylePlain target:revealController action:@selector(rightRevealToggle:)];
    }else{
        revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                             style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    }
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    // Do any additional setup after loading the view from its nib.
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    UINavigationController *navCtr = self.navigationController;
    [navCtr setNavigationBarHidden:NO animated:NO];
    
    titleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gdSToolbar"]];
    CGSize imageSize = CGSizeMake(400, 70);
    CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
    
    titleImgView.frame = CGRectMake(marginX, -25, imageSize.width, imageSize.height);
    [self.navigationController.navigationBar addSubview:titleImgView];
    
    [LocationUtil getCountriesWithBrazil:true];
}

- (void) checkUpdateToken {
    NSString *gcmTokenVerion = [preferences valueForKey: kGCMTokenUpdated];
    
    if (!gcmTokenVerion || ![gcmTokenVerion isEqualToString:@"1"]) {
        [userRequester updateUser:user onSuccess:^(User *user){
            [preferences setObject:@"1" forKey:kGCMTokenUpdated];
            [preferences synchronize];
        } onFail:^(NSError *error){}];
    }
}

- (void) showInformations {
    if (self.localBundle) {
        self.txtNameUser.text = [NSLocalizedStringFromTableInBundle(@"home.hello", nil, self.localBundle, @"") stringByAppendingString:user.nick];
    } else {
        self.txtNameUser.text = [NSLocalizedString(@"home.hello", @"") stringByAppendingString:user.nick];
    }
    
    self.btnProfile.hidden = NO;
    [user setAvatarImageAtButton:self.btnProfile orImageView:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.revealViewController.panGestureRecognizer.enabled=NO;
    
    
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Home Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if (!titleImgView) {
        titleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gdSToolbar"]];
        CGSize imageSize = CGSizeMake(400, 70);
        CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
        
        titleImgView.frame = CGRectMake(marginX, -25, imageSize.width, imageSize.height);
    }
    
    [self.navigationController.navigationBar addSubview:titleImgView];
    
    [self showInformations];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [titleImgView removeFromSuperview];
}

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
        profileListView.showBack = YES;
        [self.navigationController pushViewController:profileListView animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (IBAction)btnEnjoyAction:(id)sender {
    if (![UserRequester isConnected]) {
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
        return;
    }
    
    if (user.isGameTutorailReady) {
        StartViewController *startViewCtrl = [[StartViewController alloc] init];
        [self.navigationController pushViewController:startViewCtrl animated:YES];
    } else {
        GameTutorialViewController *gameTutorialView = [[GameTutorialViewController alloc] init];
        [self.navigationController pushViewController:gameTutorialView animated:YES];
    }
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    user.lat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    user.lon = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    
    [locationManager stopUpdatingLocation];
}

- (void) authorizedAutomaticLogin:(NSString *)userToken {
    [userRequester lookupWithUsertoken:userToken
                               OnStart:^{
                                   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                               }andOnSuccess:^{
                                   [self showInformations];
                                   [self checkUpdateToken];
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   
                                   [self checkLastSurvey];
                               }andOnError:^(NSError *error, int errorCode){
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   
                                   if (errorCode == 403) {
                                       [[User getInstance] clearUser];
                                       
                                       [preferences setValue:nil forKey:kUserTokenKey];
                                       [preferences setValue:nil forKey:kAppTokenKey];
                                       [preferences setValue:nil forKey:kAvatarNumberKey];
                                       [preferences setValue:nil forKey:kPhotoKey];
                                       [preferences setValue:nil forKey:kNickKey];
                                       
                                       [preferences synchronize];
                                       
                                       TutorialViewController *tutorialViewController = [[TutorialViewController alloc] init];
                                       UIViewController *newFrontController = [[UINavigationController alloc] initWithRootViewController:tutorialViewController];
                                       SWRevealViewController *revealController = self.revealViewController;
                                       [revealController pushFrontViewController:newFrontController animated:YES];
                                   }else{
                                       NSString *errorMsg;
                                       if (error && error.code == -1009) {
                                           errorMsg = NSLocalizedString(kMsgConnectionError, @"");
                                       } else {
                                           errorMsg = NSLocalizedString(kMsgApiError, @"");
                                       }
                                       
                                       [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                   }
                               }];
}

- (void) checkLastSurvey{
    [userRequester getSummary:user date:[NSDate date] onStart:^{
        
    } onSuccess:^(NSDictionary *surveys){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        if ([surveys count] == 0 && (!user.lastJoinNotification || ![calendar isDateInToday:user.lastJoinNotification])) {
            user.lastJoinNotification = [NSDate date];
            [preferences setValue:[DateUtil stringUSFromDate:user.lastJoinNotification] forKey:kLastJoinNotification];
            [preferences synchronize];
            
            user.doesReport = false;
            
            SelectStateViewController *selectStateView = [[SelectStateViewController alloc] init];
            [self.navigationController pushViewController:selectStateView animated:YES];
        }else{
            user.doesReport = true;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } onError:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *errorMsg;
        if (error && error.code == -1009) {
            errorMsg = NSLocalizedString(kMsgConnectionError, @"");
        } else {
            errorMsg = NSLocalizedString(kMsgApiError, @"");
        }
        
        [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
    }];
}
@end