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
        
        NSString *title = [NSString stringWithFormat:@"Detail Level %d", level];
        
        [self.navigationController.navigationBar addGestureRecognizer:grandParentRevealController.panGestureRecognizer];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        self.navigationItem.title = title;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnHome:(id)sender {
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];
}

- (IBAction)btnAbout:(id)sender {
    
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];
}

- (IBAction)btnHelp:(id)sender {
    
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:helpViewController];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];
}

- (IBAction)btnProfile:(id)sender {
    if ([Requester isConnected]){
        ProfileListViewController *profileListController = [[ProfileListViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:profileListController];
        SWRevealViewController *revealController = self.revealViewController;
        [revealController pushFrontViewController:newFrontController animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (IBAction)btnExit:(id)sender {
    
    User *user;
    
    user = [User getInstance];
    user = nil;
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    [preferences setValue:nil forKey:kUserTokenKey];
    [preferences setValue:nil forKey:kAppTokenKey];
    [preferences setValue:nil forKey:kPictureKey];
    [preferences setValue:nil forKey:kNickKey];
    
    [preferences synchronize];
    
    TutorialViewController *tutorialViewController = [[TutorialViewController alloc] init];
    newFrontController = [[UINavigationController alloc] initWithRootViewController:tutorialViewController];
    SWRevealViewController *revealController = self.revealViewController;
    [revealController pushFrontViewController:newFrontController animated:YES];    
}
@end
