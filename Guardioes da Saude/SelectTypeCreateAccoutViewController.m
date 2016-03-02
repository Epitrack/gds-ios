//
//  SelectTypeCreateAccoutViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 20/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectTypeCreateAccoutViewController.h"
#import "TermsViewController.h"
#import "User.h"
#import "UserRequester.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TermsViewController.h"
#import "ModalPrivViewController.h"
#import "TutorialViewController.h"
#import "MBProgressHUD.h"
#import <Google/SignIn.h>
#import "ViewUtil.h"
#import <Google/Analytics.h>

@interface SelectTypeCreateAccoutViewController () {
    User *user;
    UserRequester *userRequester;
    NSString *signInAuthStatus;
}

@end

@implementation SelectTypeCreateAccoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"infoCopy.png"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(infoShow)];
    
    NSArray *actionButtonItems = @[infoItem];
    
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    self.navigationItem.title = @"";
    
    user = [[User alloc] init];
    userRequester = [[UserRequester alloc] init];
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Select Type Create Account Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) infoShow {
    ModalPrivViewController *modalPrivController = [[ModalPrivViewController alloc] init];
    modalPrivController.modalPresentationStyle = UIModalPresentationFormSheet;
    modalPrivController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:modalPrivController animated:NO];

}

#pragma mark - GIDSignInDelegate

- (IBAction)btnFacebookAction:(id)sender {
    [self callTermsWithSocialNetworks:GdsFacebook];
}

- (IBAction)btnGoogleAction:(id)sender {
    [self callTermsWithSocialNetworks:GdsGoogle];
}

- (IBAction)btnTwitterAction:(id)sender {
    [self callTermsWithSocialNetworks:GdsTwitter];
}

- (void) callTermsWithSocialNetworks: (SocialNetwork) socialNetworks{
    TermsViewController *termsCtrlView = [[TermsViewController alloc] init];
    termsCtrlView.socialNetwork = socialNetworks;
    termsCtrlView.createType = SOCIAL_NETWORK;
    
    [self.navigationController pushViewController:termsCtrlView animated:YES];
}

- (IBAction)btnEmailAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_create_account_email"
                                                           label:@"Create account With Email"
                                                           value:nil] build]];
    

    TermsViewController *termsCtrlView = [[TermsViewController alloc] init];
    termsCtrlView.createType = EMAIL;
    
    [self.navigationController pushViewController:termsCtrlView animated:YES];
}

- (IBAction)btnTermsAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_terms"
                                                           label:@"See terms"
                                                           value:nil] build]];
    
    TermsViewController *termsViewController = [[TermsViewController alloc] init];
    [self.navigationController pushViewController:termsViewController animated:YES];
}

- (IBAction)btnInfoAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_information"
                                                           label:@"See informations"
                                                           value:nil] build]];
    
    ModalPrivViewController *modalPrivController = [[ModalPrivViewController alloc] init];
    modalPrivController.modalPresentationStyle = UIModalPresentationFormSheet;
    modalPrivController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:modalPrivController animated:NO];
}

- (IBAction)btnBackAction:(id)sender {
    TutorialViewController *tutorialViewController = [[TutorialViewController alloc] init];
    [self.navigationController pushViewController:tutorialViewController animated:YES];
}

- (void)showTermsRequiredMsg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Você precisa aceitar os termos de uso antes de continuar." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
