//
//  SelectTypeLoginViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 06/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectTypeLoginViewController.h"
#import "EnterViewController.h"
#import "User.h"
#import "HomeViewController.h"
#import "AFNetworking/AFNetworking.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "NoticeRequester.h"
#import "SingleNotice.h"
#import "TutorialViewController.h"
#import "UserRequester.h"
#import "MBProgressHUD.h"
#import "ViewUtil.h"
#import <Google/Analytics.h>
#import "MBProgressHUD.h"

@interface SelectTypeLoginViewController () {
    
    User *user;
    SingleNotice *singleNotice;
    UserRequester *userRequester;
    int counter;
}

@end

@implementation SelectTypeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [User getInstance];
    singleNotice = [SingleNotice getInstance];
    userRequester = [[UserRequester alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"";

    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    // Uncomment to automatically sign in the user.
    //GOOGLE
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.clientID = @"997325640691-65rupglfegtkeqs5rf5n0i99sjn17938.apps.googleusercontent.com";
    [signIn setScopes:[NSArray arrayWithObject: @"https://www.googleapis.com/auth/plus.login"]];
    [signIn setScopes:[NSArray arrayWithObject: @"https://www.googleapis.com/auth/plus.me"]];

    //FACEBOOK
    FBSDKLoginButton *btnFacebook = [[FBSDKLoginButton alloc] init];
    self.btnFacebook = btnFacebook;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    //TWITTER
    TWTRLogInButton* logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession* session, NSError* error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    
    self.btnTwitter = logInButton;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Select Type Login Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (IBAction)btnLoginEmail:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_login_email"
                                                           label:@"Login with email"
                                                           value:nil] build]];
    
    EnterViewController *enterViewController = [[EnterViewController alloc] init];
    [self.navigationController pushViewController:enterViewController animated:YES];
}

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button

- (void)signIn:(GIDSignIn *)signIn
    didSignInForUser:(GIDGoogleUser *)userGL
     withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (!error) {
        [self checkSocialLoginWithToken:userGL.userID andType:GdsGoogle];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (IBAction)btnGoogleAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_login_google"
                                                           label:@"Login with Google"
                                                           value:nil] build]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //GOOGLE
    [[GIDSignIn sharedInstance] signIn];
}


//FACEBOOK
// Once the button is clicked, show the login dialog
- (IBAction)btnFacebookAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_login_facebook"
                                                           label:@"Login with Facebook"
                                                           value:nil] build]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
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
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if ([FBSDKAccessToken currentAccessToken])
             {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,ids_for_business"}]
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

- (IBAction)btnTwitterAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_login_twitter"
                                                           label:@"Login with Twitter"
                                                           value:nil] build]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"signed in as %@", [session userName]);
            user.nick = [session userName];
            user.tw = [session userID];
            [self checkSocialLoginWithToken:user.tw andType: GdsTwitter];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Erro ao logar com o Twitter." preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"You pressed button OK");
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)iconBackAction:(id)sender {
    TutorialViewController *tutorialViewController = [[TutorialViewController alloc] init];
    [self.navigationController pushViewController:tutorialViewController animated:YES];
}

- (void) checkSocialLoginWithToken:(NSString *) token andType:(SocialNetwork)type {
    [userRequester checkSocialLoginWithToken:token
                                   andSocial:type
                                    andStart:^{
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    }
                                andOnSuccess:^(User *userResponse){
                                    userResponse.password = userResponse.email;
                                    
                                    [self doLoginWithUser:userResponse];
                                }
                                    andError:^(NSError *error){
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        NSString *errorMsg;
                                        if (error && error.code == -1009) {
                                            errorMsg = kMsgConnectionError;
                                        } else if(error) {
                                            errorMsg = kMsgApiError;
                                        }else{
                                            errorMsg = @"Cadastro não encontrado!";
                                        }
                                        
                                        [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                    }];
    
    
}

- (void) doLoginWithUser:(User *) userLogin{
    [userRequester login:userLogin onStart:^{}
                 onError:^(NSError *error){
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     NSString *errorMsg;
                     if (error && error.code == -1009) {
                         errorMsg = kMsgConnectionError;
                     } else if(error) {
                         errorMsg = kMsgApiError;
                     }else{
                         errorMsg = @"Cadastro não encontrado!";
                     }
                     
                     [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                 }
               onSuccess:^(User *userResponse){
                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                   user = userResponse;
                   
                   NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                   [preferences setValue:user.app_token forKey:kAppTokenKey];
                   [preferences setValue:user.user_token forKey:kUserTokenKey];
                   [preferences setValue:user.nick forKey:kNickKey];
                   [preferences setValue:user.avatarNumber forKey:kAvatarNumberKey];

                   [preferences synchronize];
                   
                   [self loadNotices];
                   
                   [self.navigationController pushViewController: [[HomeViewController alloc] init] animated: YES];
               }];
}

- (void) loadNotices {
    
    [[[NoticeRequester alloc] init] getNotices:user
                                       onStart:^{}
                                       onError:^(NSError *error){
                                           NSString *errorMsg;
                                           if (error && error.code == -1009) {
                                               errorMsg = kMsgConnectionError;
                                           } else {
                                               errorMsg = kMsgApiError;
                                           }
                                           
                                           [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                       }
                                     onSuccess:^(NSMutableArray *noticesRequest){
                                         singleNotice.notices = noticesRequest;
                                     }];
}

- (IBAction)btnUnlockAction:(id)sender {
    if (counter > 5) {
        counter = 0;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Digite sua chave" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:nil];
        
        [alert addAction: [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *txtKey = alert.textFields[0];
            if ([txtKey.text isEqualToString:@"22063"]) {
                [User getInstance].isTest = YES;
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                [preferences setValue:@"YES" forKey:kIsTest];
                
                [preferences synchronize];
            }
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"Cancel pressed");
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        counter++;
    }
}
@end
