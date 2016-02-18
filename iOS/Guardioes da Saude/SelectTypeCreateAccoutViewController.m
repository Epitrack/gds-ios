//
//  SelectTypeCreateAccoutViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 20/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectTypeCreateAccoutViewController.h"
#import "CreateAccountViewController.h"
#import "CreateAccountSocialLoginViewController.h"
#import "User.h"
#import "UserRequester.h"
#import "AFNetworking/AFNetworking.h"
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
    BOOL isEnabled;
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

    isEnabled = NO;
    [self desableButtons];
    
    //GOOGLE
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.clientID = @"997325640691-65rupglfegtkeqs5rf5n0i99sjn17938.apps.googleusercontent.com";
    //[signIn signInSilently];
    [signIn setScopes:[NSArray arrayWithObject: @"https://www.googleapis.com/auth/plus.login"]];
    [signIn setScopes:[NSArray arrayWithObject: @"https://www.googleapis.com/auth/plus.me"]];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)userGl withError:(NSError *)error {
    if (!error) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        user.email = userGl.profile.email;
        user.gl = userGl.userID;
        user.nick = userGl.profile.name;
        
        [self checkSocialLoginWithToken:user.gl andType:GdsGoogle];
    }
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

//- (void)signIn:(GIDSignIn *)signIn
//didSignInForUser:(GIDGoogleUser *)user
//     withError:(NSError *)error {
//    if (error) {
//        signInAuthStatus = [NSString stringWithFormat:@"Status: Authentication error: %@", error];
//        return;
//    }
//    //[self reportAuthStatus];
//    //[self updateButtons];
//}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        signInAuthStatus = [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else {
        signInAuthStatus = [NSString stringWithFormat:@"Status: Disconnected"];
    }
    //[self reportAuthStatus];
    //[self updateButtons];
}


- (void) desableButtons {
    // Btn Facebook
    UIImage *bgFacebook = [UIImage imageNamed:@"buttonFacebookDesable.png"];
    [self.btnFacebook setBackgroundImage:bgFacebook forState:UIControlStateNormal];
    [self.btnFacebook setTitle:@"" forState:UIControlStateNormal];
    
    // Btn Twitter
    UIImage *bgTwitter = [UIImage imageNamed:@"buttonTwitterDesable.png"];
    [self.btnTwitter setBackgroundImage:bgTwitter forState:UIControlStateNormal];
    [self.btnTwitter setTitle:@"" forState:UIControlStateNormal];
    
    // Btn Google
    UIImage *bgGoogle = [UIImage imageNamed:@"buttonGoogleDesable.png"];
    UIButton *btnGoogle = (UIButton *) self.btnGoogle;
    [btnGoogle setBackgroundImage:bgGoogle forState:UIControlStateNormal];
    [btnGoogle setTitle:@"" forState:UIControlStateNormal];
    
    // Btn Email
    UIImage *bgEmail = [UIImage imageNamed:@"buttonEmailDisable.png"];
    [self.btnEmail setBackgroundImage:bgEmail forState:UIControlStateNormal];
    [self.btnEmail setTitle:@"" forState:UIControlStateNormal];
}

- (void) enableButtons {
    //Btn Facebook
    UIImage *bgFacebook = [UIImage imageNamed:@"button_facebook.png"];
    [self.btnFacebook setBackgroundImage:bgFacebook forState:UIControlStateNormal];
    [self.btnFacebook setTitle:@"Facebook" forState:UIControlStateNormal];
    
    //Btn Twitter
    UIImage *bgTwitter = [UIImage imageNamed:@"button_twitter.png"];
    [self.btnTwitter setBackgroundImage:bgTwitter forState:UIControlStateNormal];
    [self.btnTwitter setTitle:@"Twitter" forState:UIControlStateNormal];
    
    //Btn Google
    UIImage *bgGoogle = [UIImage imageNamed:@"button_google.png"];
    [self.btnGoogle setBackgroundImage:bgGoogle forState:UIControlStateNormal];
    [self.btnGoogle setTitle:@"Google" forState:UIControlStateNormal];
    
    //Btn Email
    UIImage *bgEmail = [UIImage imageNamed:@"button_email.png"];
    [self.btnEmail setBackgroundImage:bgEmail forState:UIControlStateNormal];
    [self.btnEmail setTitle:@"email" forState:UIControlStateNormal];
}

- (IBAction)btnFacebookAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_create_account_facebook"
                                                           label:@"Create account with Facebook"
                                                           value:nil] build]];
    
    if (isEnabled) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [login
         logInWithReadPermissions: @[@"public_profile", @"email"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Erro ao logar com o Facebook." preferredStyle:UIAlertControllerStyleActionSheet];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                     NSLog(@"You pressed button OK");
                 }];
                 [alert addAction:defaultAction];
                 [self presentViewController:alert animated:YES completion:nil];
             } else if (result.isCancelled) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Operação cancelada." preferredStyle:UIAlertControllerStyleActionSheet];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                     NSLog(@"You pressed button OK");
                 }];
                 [alert addAction:defaultAction];
                 [self presentViewController:alert animated:YES completion:nil];
             } else {
                 if ([FBSDKAccessToken currentAccessToken])
                 {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,token_for_business"}]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userFacebook, NSError *error)
                      {
                          NSLog(@"Logged in: %@", userFacebook);
                          if (!error)
                          {
                              NSDictionary *dictUser = (NSDictionary *)userFacebook;
                              
                              user.nick = dictUser[@"name"];
                              user.fb = dictUser[@"id"];
                              [self checkSocialLoginWithToken:user.fb andType:GdsFacebook];
                          }
                      }];
                 }
             }
         }];
    }else{
        [self showTermsRequiredMsg];
    }
    
}

- (IBAction)btnGoogleAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_create_account_google"
                                                           label:@"Create account With Google"
                                                           value:nil] build]];
    
    if(isEnabled){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[GIDSignIn sharedInstance] signIn];
    }else{
        [self showTermsRequiredMsg];
    }
}

- (IBAction)btnTwitterAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_create_account_twitter"
                                                           label:@"Create account With Twitter"
                                                           value:nil] build]];
    
    if (isEnabled) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                NSLog(@"signed in as %@", [session userName]);
                user.nick = [session userName];
                user.tw = [session userID];
                
                [self checkSocialLoginWithToken:user.tw andType:GdsTwitter];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Erro ao logar com o Twitter."];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }else{
        [self showTermsRequiredMsg];
    }
}

- (IBAction)btnEmailAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_create_account_email"
                                                           label:@"Create account With Email"
                                                           value:nil] build]];
    
    if (isEnabled) {
        CreateAccountViewController *createAccountViewController = [[CreateAccountViewController alloc] init];
        [self.navigationController pushViewController:createAccountViewController animated:YES];
    } else {
        [self showTermsRequiredMsg];
    }
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

- (void) checkSocialLoginWithToken:(NSString *) token andType:(SocialNetwork) type{
    [userRequester checkSocialLoginWithToken:token
                                   andSocial:type
                                    andStart:^(){
                                        
                                    }
                                andOnSuccess:^(User *user){
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Cadastro realizado anterioremente com essa rede social."];
                                    [self presentViewController:alert animated:YES completion:nil];
                                }
                                    andError:^(NSError *error){
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        if (error) {
                                            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Não foi possível realizar o cadastro. Tente novamente em alguns minutos!"];
                                            [self presentViewController:alert animated:YES completion:nil];
                                        } else {
                                            CreateAccountSocialLoginViewController *createAccountSocialLoginViewController = [[CreateAccountSocialLoginViewController alloc] init];
                                            createAccountSocialLoginViewController.socialNetwork = type;
                                            createAccountSocialLoginViewController.socialNetworkId = token;
                                            createAccountSocialLoginViewController.nick = user.nick;
                                            createAccountSocialLoginViewController.email = user.email;
                                            
                                            [self.navigationController pushViewController:createAccountSocialLoginViewController animated:YES];
                                        }
                                    }];
}

- (IBAction)btnCheckTermsAction:(id)sender {
    UIImage *checkBoxFalse = [UIImage imageNamed:@"icon_checkbox_false.png"];
    UIImage *checkBoxTrue = [UIImage imageNamed:@"icon_checkbok_true.png"];
    isEnabled = !isEnabled;
     
    if (isEnabled) {
        [self enableButtons];
        [self.btnCheckTerms setImage:checkBoxTrue forState:UIControlStateNormal];
    } else {
        [self desableButtons];
        [self.btnCheckTerms setImage:checkBoxFalse forState:UIControlStateNormal];
    }
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
