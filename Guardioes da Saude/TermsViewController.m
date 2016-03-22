//
//  TermsViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 13/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "TermsViewController.h"
#import "SignUpDetailsViewController.h"
#import "SignUpViewController.h"
#import <Google/Analytics.h>
#import "UserRequester.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
#import "MBProgressHUD.h"
#import "ViewUtil.h"

@interface TermsViewController (){
    UserRequester *userRequester;
    User *user;
}

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    user = [[User alloc] init];
    userRequester = [[UserRequester alloc] init];
    
    self.navigationItem.title = @"Termos e Políticas";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    if (self.createType == NO_CREATE) {
        self.constScrollBottom.constant = 0.0f;
    }
    
    //GOOGLE
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.clientID = @"997325640691-65rupglfegtkeqs5rf5n0i99sjn17938.apps.googleusercontent.com";
    //[signIn signInSilently];
    [signIn setScopes:[NSArray arrayWithObject: @"https://www.googleapis.com/auth/plus.login"]];
    [signIn setScopes:[NSArray arrayWithObject: @"https://www.googleapis.com/auth/plus.me"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Terms Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

- (IBAction)btnDeclineAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAcceptAction:(id)sender {
    if (self.createType == EMAIL) {
        SignUpViewController *signUpView = [[SignUpViewController alloc] init];
        [self.navigationController pushViewController:signUpView animated:YES];
    }else if (self.createType == SOCIAL_NETWORK){
        switch (self.socialNetwork) {
            case GdsTwitter:
                [self loginWithTwitter];
                break;
            case GdsFacebook:
                [self loginWithFacebook];
                break;
            case GdsGoogle:
                [self loginWithGoogle];
                break;
            default:
                break;
        }
    }
    
}

- (void) loginWithGoogle{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_create_account_google"
                                                           label:@"Create account With Google"
                                                           value:nil] build]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)userGl withError:(NSError *)error {
    if (!error) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        user.email = userGl.profile.email;
        user.gl = userGl.userID;
        user.nick = userGl.profile.name;
        
        [self checkSocialLoginWithToken:user.gl andType:GdsGoogle];
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

- (void) loginWithFacebook{
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
}

- (void) loginWithTwitter{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_create_account_twitter"
                                                           label:@"Create account With Twitter"
                                                           value:nil] build]];
    
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
                                            SignUpDetailsViewController *signupDetailView = [[SignUpDetailsViewController alloc] init];
                                            signupDetailView.user = user;
                                            
                                            [self.navigationController pushViewController:signupDetailView animated:YES];
                                        }
                                    }];
}
@end
