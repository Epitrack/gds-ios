//
//  MenuViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 06/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "ProfileListViewController.h"
#import "User.h"
#import "TutorialViewController.h"
#import "Requester.h"
#import "ViewUtil.h"
#import "ChangeLanguageViewController.h"
#import "UserRequester.h"
#import <Google/Analytics.h>

@interface MenuViewController () {
    UIViewController *newFrontController;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    newFrontController = nil;
    
    // We determine whether we have a grand parent SWRevealViewController, this means we are at least one level behind the hierarchy
    SWRevealViewController *parentRevealController = self.revealViewController;
    SWRevealViewController *grandParentRevealController = parentRevealController.revealViewController;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:grandParentRevealController action:@selector(revealToggle:)];
    
    // if we have a reveal controller as a grand parent, this means we are are being added as a
    // child of a detail (child) reveal controller, so we add a gesture recognizer provided by our grand parent to our
    // navigation bar as well as a "reveal" button, we also set
    if ( grandParentRevealController )
    {
        // to present a title, we count the number of ancestor reveal controllers we have, this is of course
        // only a hack for demonstration purposes, on a real project you would have a model telling this.
        NSInteger level=0;
        UIViewController *controller = grandParentRevealController;
        while( nil != (controller = [controller revealViewController]) )
            level++;
        
        NSString *title = [NSString stringWithFormat:@"Detail Level %d", (int) level];
        
        [self.navigationController.navigationBar addGestureRecognizer:grandParentRevealController.panGestureRecognizer];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        self.navigationItem.title = title;

    }
    
    [self.navigationController setNavigationBarHidden:YES];
    
    //[self setHomeSelected];
}

+ (MenuViewController *)getInstance {
    
    static MenuViewController *getInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        getInstance = [[self alloc] init];
    });
    
    return getInstance;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Menu Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = YES;
}

- (void) setHomeSelected{
    self.imgHome.image = [UIImage imageNamed:@"iconHomeSelected"];
    self.lbHome.textColor = [UIColor colorWithRed:32/255.f green:151/255.f blue:247/255.f alpha:1];
    
    self.imgProfile.image = [UIImage imageNamed:@"iconProfileDefault"];
    self.lbProfile.textColor = [UIColor blackColor];
    
    self.imgAbout.image = [UIImage imageNamed:@"iconAboutDefault"];
    self.lbAbout.textColor = [UIColor blackColor];
    
    self.imgHelp.image = [UIImage imageNamed:@"iconHelpDefault"];
    self.lbHelp.textColor = [UIColor blackColor];
    
    self.imgSignout.image = [UIImage imageNamed:@"iconLogoutDefault"];
    self.lbSignout.textColor = [UIColor blackColor];
}

- (IBAction)btnLanguageAction:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_language"
                                                           label:@"Home"
                                                           value:nil] build]];
    
    ChangeLanguageViewController *changeLanguageView = [[ChangeLanguageViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:changeLanguageView];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnHome:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_home"
                                                           label:@"Home"
                                                           value:nil] build]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];
    
    //[self setHomeSelected];
}

- (IBAction)btnAbout:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_about"
                                                           label:@"About"
                                                           value:nil] build]];
    
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];
    
//    self.imgHome.image = [UIImage imageNamed:@"iconHomeDefault"];
//    self.lbHome.textColor = [UIColor blackColor];
//    
//    self.imgProfile.image = [UIImage imageNamed:@"iconProfileDefault"];
//    self.lbProfile.textColor = [UIColor blackColor];
//    
//    self.imgAbout.image = [UIImage imageNamed:@"iconAboutSelected"];
//    self.lbAbout.textColor = [UIColor colorWithRed:32/255.f green:151/255.f blue:247/255.f alpha:1];
//    
//    self.imgHelp.image = [UIImage imageNamed:@"iconHelpDefault"];
//    self.lbHelp.textColor = [UIColor blackColor];
//    
//    self.imgSignout.image = [UIImage imageNamed:@"iconLogoutDefault"];
//    self.lbSignout.textColor = [UIColor blackColor];
}

- (IBAction)btnHelp:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_help"
                                                           label:@"Help"
                                                           value:nil] build]];
    
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:helpViewController];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];
    
//    self.imgHome.image = [UIImage imageNamed:@"iconHomeDefault"];
//    self.lbHome.textColor = [UIColor blackColor];
//    
//    self.imgProfile.image = [UIImage imageNamed:@"iconProfileDefault"];
//    self.lbProfile.textColor = [UIColor blackColor];
//    
//    self.imgAbout.image = [UIImage imageNamed:@"iconAboutDefault"];
//    self.lbAbout.textColor = [UIColor blackColor];
//    
//    self.imgHelp.image = [UIImage imageNamed:@"iconHelpSelected"];
//    self.lbHelp.textColor = [UIColor colorWithRed:32/255.f green:151/255.f blue:247/255.f alpha:1];
//    
//    self.imgSignout.image = [UIImage imageNamed:@"iconLogoutDefault"];
//    self.lbSignout.textColor = [UIColor blackColor];
}

- (IBAction)btnProfile:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_profile"
                                                           label:@"Profile"
                                                           value:nil] build]];
    
    if ([Requester isConnected]){
        ProfileListViewController *profileListController = [[ProfileListViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:profileListController];
        SWRevealViewController *revealController = self.revealViewController;
        [revealController pushFrontViewController:newFrontController animated:YES];
        //[self setProfileSelected];
        
        self.lbSignout.textColor = [UIColor blackColor];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (void)setProfileSelected{
    self.imgHome.image = [UIImage imageNamed:@"iconHomeDefault"];
    self.lbHome.textColor = [UIColor blackColor];
    
    self.imgProfile.image = [UIImage imageNamed:@"iconProfileSelected"];
    self.lbProfile.textColor = [UIColor colorWithRed:32/255.f green:151/255.f blue:247/255.f alpha:1];
    
    self.imgAbout.image = [UIImage imageNamed:@"iconAboutDefault"];
    self.lbAbout.textColor = [UIColor blackColor];
    
    self.imgHelp.image = [UIImage imageNamed:@"iconHelpDefault"];
    self.lbHelp.textColor = [UIColor blackColor];
    
    self.imgSignout.image = [UIImage imageNamed:@"iconLogoutDefault"];
}

- (IBAction)btnExit:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_exit"
                                                           label:@"Exit"
                                                           value:nil] build]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                   message:NSLocalizedString(@"menu.are_you_sure_sign_out", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *oktAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"constant.yes", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self doLogout];
                                                          }];
    
    UIAlertAction *canceltAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"constant.no", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                      }];

    [alert addAction:canceltAction];
    [alert addAction:oktAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)doLogout{
    [[User getInstance] clearUser];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    [preferences setValue:nil forKey:kUserTokenKey];
    [preferences setValue:nil forKey:kAppTokenKey];
    [preferences setValue:nil forKey:kAvatarNumberKey];
    [preferences setValue:nil forKey:kPhotoKey];
    [preferences setValue:nil forKey:kNickKey];
    [preferences setValue:nil forKey:kLastJoinNotification];
    [preferences setValue:nil forKey:kGameTutorialReady];
    [preferences setValue:nil forKey:kGCMToken];
    
    [preferences synchronize];
    
    
    [UserRequester closeSession];
    
    TutorialViewController *tutorialViewController = [[TutorialViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:tutorialViewController];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];
    
    //[self setHomeSelected];

}

- (IBAction)btnFacebookAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/appguardioesdasaude/?fref=ts"]];
}

- (IBAction)btnTwitterAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/minsaude"]];
}

@end
