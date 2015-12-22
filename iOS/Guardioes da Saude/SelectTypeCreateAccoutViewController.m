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
#import "AFNetworking/AFNetworking.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TermsViewController.h"
#import "ModalPrivViewController.h"
#import "TutorialViewController.h"

@interface SelectTypeCreateAccoutViewController () {
    
    User *user;
    BOOL userExists;
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
    
    user = [User getInstance];
    userExists = NO;
    isEnabled = NO;
    [self desableButtons];
    
    //GOOGLE
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.clientID = @"146401381326-skhtq5jehhp213aa7rpsf8pql62d08ho.apps.googleusercontent.com";
    //[signIn signInSilently];
    [signIn setScopes:[NSArray arrayWithObject: @"https://www.googleapis.com/auth/plus.login"]];
    [signIn setScopes:[NSArray arrayWithObject: @"https://www.googleapis.com/auth/plus.me"]];
    
    //self.btnGoogle = signIn;
    
    //FACEBOOK
    FBSDKLoginButton *btnFacebook = [[FBSDKLoginButton alloc] init];
    //self.btnFacebook = btnFacebook;
    //self.btnFacebook.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    //TWITTER
    TWTRLogInButton* logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession* session, NSError* error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    
    //self.btnTwitter = logInButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
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
    [self.navigationController presentModalViewController:modalPrivController animated:YES];

}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        signInAuthStatus = [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        return;
    }
    //[self reportAuthStatus];
    //[self updateButtons];
}

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
    [self.btnGoogle setBackgroundImage:bgGoogle forState:UIControlStateNormal];
    [self.btnGoogle setTitle:@"" forState:UIControlStateNormal];
    
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
    if (isEnabled) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile", @"email"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Erro ao logar com o Facebook." preferredStyle:UIAlertControllerStyleActionSheet];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                     NSLog(@"You pressed button OK");
                 }];
                 [alert addAction:defaultAction];
                 [self presentViewController:alert animated:YES completion:nil];
             } else if (result.isCancelled) {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Operação cancelada." preferredStyle:UIAlertControllerStyleActionSheet];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                     NSLog(@"You pressed button OK");
                 }];
                 [alert addAction:defaultAction];
                 [self presentViewController:alert animated:YES completion:nil];
             } else {
                 if ([FBSDKAccessToken currentAccessToken])
                 {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userFacebook, NSError *error)
                      {
                          NSLog(@"Logged in: %@", userFacebook);
                          if (!error)
                          {
                              NSDictionary *dictUser = (NSDictionary *)userFacebook;
                              
                              user.nick = dictUser[@"name"];
                              user.fb = dictUser[@"id"];
                              
                              BOOL userFbExists = [self checkSocialLoginWithToken:user.fb andType:@"FACEBOOK"];
                              
                              if (userFbExists) {
                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Cadastro realizado anterioremente com essa rede social ou e-mail." preferredStyle:UIAlertControllerStyleActionSheet];
                                  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                      NSLog(@"You pressed button OK");
                                  }];
                                  [alert addAction:defaultAction];
                                  [self presentViewController:alert animated:YES completion:nil];
                              } else {
                                  CreateAccountSocialLoginViewController *createAccountSocialLoginViewController = [[CreateAccountSocialLoginViewController alloc] init];
                                  [self.navigationController pushViewController:createAccountSocialLoginViewController animated:YES];
                              }
                              
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
    
}

- (IBAction)btnTwitterAction:(id)sender {
    if (isEnabled) {
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                NSLog(@"signed in as %@", [session userName]);
                user.nick = [session userName];
                user.tw = [session userID];
                
                BOOL userTwitterExists = [self checkSocialLoginWithToken:user.tw andType:@"TWITTER"];
                
                if (userTwitterExists) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Cadastro realizado anterioremente com essa rede social ou e-mail." preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        NSLog(@"You pressed button OK");
                    }];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    CreateAccountSocialLoginViewController *createAccountSocialLoginViewController = [[CreateAccountSocialLoginViewController alloc] init];
                    [self.navigationController pushViewController:createAccountSocialLoginViewController animated:YES];
                }
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Erro ao logar com o Twitter." preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSLog(@"You pressed button OK");
                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }else{
        [self showTermsRequiredMsg];
    }
}

- (IBAction)btnEmailAction:(id)sender {
    if (isEnabled) {
        CreateAccountViewController *createAccountViewController = [[CreateAccountViewController alloc] init];
        [self.navigationController pushViewController:createAccountViewController animated:YES];
    } else {
        [self showTermsRequiredMsg];
    }
}

- (IBAction)btnTermsAction:(id)sender {
    TermsViewController *termsViewController = [[TermsViewController alloc] init];
    [self.navigationController pushViewController:termsViewController animated:YES];
}

- (BOOL) checkSocialLoginWithToken:(NSString *) token andType:(NSString *)type {
    NSString *url;

    if ([type isEqualToString:@"GOOGLE"]) {
        url = [NSString stringWithFormat: @"http://api.guardioesdasaude.org/user/get?gl=%@", token];
    } else if ([type isEqualToString:@"FACEBOOK"]) {
        url = [NSString stringWithFormat: @"http://api.guardioesdasaude.org/user/get?fb=%@", token];
    } else if ([type isEqualToString:@"TWITTER"]) {
        url = [NSString stringWithFormat: @"http://api.guardioesdasaude.org/user/get?tw=%@", token];
    }
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSArray *response = responseObject[@"data"];
             
             if (response.count > 0) {
                 NSDictionary *userObject = [response objectAtIndex:0];
                 NSString *email = userObject[@"email"];
                 
                 if (![email isEqualToString:@""]) {
                     userExists = YES;
                 }
             } else {
                 userExists = NO;
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             userExists = NO;
             
         }];
    return userExists;
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

- (IBAction)btnGoogleDesabelAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Você precisa aceitar os termos de uso antes de continuar." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnTwitterDesabelAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Você precisa aceitar os termos de uso antes de continuar." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnInfoAction:(id)sender {
    ModalPrivViewController *modalPrivController = [[ModalPrivViewController alloc] init];
    modalPrivController.modalPresentationStyle = UIModalPresentationFormSheet;
    modalPrivController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentModalViewController:modalPrivController animated:YES];
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
