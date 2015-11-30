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

@interface SelectTypeCreateAccoutViewController () {
    
    User *user;
    BOOL userExists;
}

@end

@implementation SelectTypeCreateAccoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";
    user = [User getInstance];
    userExists = NO;
    
    //GOOGLE
    [GIDSignIn sharedInstance].uiDelegate = self;
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    
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


- (void)viewWillAppear:(BOOL)animated {
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

- (IBAction)btnFacebookAction:(id)sender {
    
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
}

- (IBAction)btnGoogleAction:(id)sender {
}

- (IBAction)btnTwitterAction:(id)sender {
    
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
}

- (IBAction)btnEmailAction:(id)sender {
    
    CreateAccountViewController *createAccountViewController = [[CreateAccountViewController alloc] init];
    [self.navigationController pushViewController:createAccountViewController animated:YES];
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

@end
