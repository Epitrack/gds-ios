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
    NSString *userTokenKey = @"userTokenKey";
    
    if ([preferences objectForKey:userTokenKey] != nil) {
        NSString *userToken = [preferences valueForKey:userTokenKey];
        [self authorizedAutomaticLogin:userToken];
    } else {
        [self showInformations];
        [self.btnProfile setImage:[user getAvatarImage] forState:UIControlStateNormal];
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
    
    [self.btnProfile setImage:[user getAvatarImage] forState:UIControlStateNormal];
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
                                    NSLog(@"Error: %@", error);
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
