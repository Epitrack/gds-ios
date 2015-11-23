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

@interface SelectTypeLoginViewController () {
    
    User *user;
}

@end

@implementation SelectTypeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [User getInstance];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (IBAction)btnLoginEmail:(id)sender {
    EnterViewController *enterViewController = [[EnterViewController alloc] init];
    [self.navigationController pushViewController:enterViewController animated:YES];
}

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    // ...
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (IBAction)btnGoogleAction:(id)sender {
    
    //GOOGLE
    [GIDSignIn sharedInstance].uiDelegate = self;
}


//FACEBOOK
// Once the button is clicked, show the login dialog
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
                          
                          [self checkSocialLoginWithToken:user.fb andType:@"FACEBOOK"];
                      }
                  }];
             }
             
             
         }
     }];
}

- (IBAction)btnTwitterAction:(id)sender {
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            user.nick = [session userName];
            user.tw = [session userID];
            [self checkSocialLoginWithToken:user.tw andType:@"TWITTER"];
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

- (void) checkSocialLoginWithToken:(NSString *) token andType:(NSString *)type {
    
    NSString *url;
    
    if ([type isEqualToString:@"GOOGLE"]) {
        url = [NSString stringWithFormat: @"http://52.20.162.21/user/get?gl=%@", token];
    } else if ([type isEqualToString:@"FACEBOOK"]) {
        url = [NSString stringWithFormat: @"http://52.20.162.21/user/get?fb=%@", token];
    } else if ([type isEqualToString:@"TWITTER"]) {
        url = [NSString stringWithFormat: @"http://52.20.162.21/user/get?tw=%@", token];
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
                  NSString *passowrd = userObject[@"password"];
                  
                  [self loginSocialWithEmail:email andPassword:passowrd];
                  
              } else {
                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não existe cadastro com essa rede social." preferredStyle:UIAlertControllerStyleActionSheet];
                  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                      NSLog(@"You pressed button OK");
                  }];
                  [alert addAction:defaultAction];
                  [self presentViewController:alert animated:YES completion:nil];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não existe cadastro com essa rede social." preferredStyle:UIAlertControllerStyleActionSheet];
              UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                  NSLog(@"You pressed button OK");
              }];
              [alert addAction:defaultAction];
              [self presentViewController:alert animated:YES completion:nil];
              
          }];
    
    
}

- (void) loginSocialWithEmail:(NSString *)email andPassword:(NSString *)password {
    
    NSString *url = @"http://52.20.162.21/user/login";
    
    NSDictionary *params = @{@"email":email,
                             @"password":password};
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager POST:url
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              if ([responseObject[@"error"] boolValue] == 1) {
                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar a operação. Tente novamente em alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
                  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                      NSLog(@"You pressed button OK");
                  }];
                  [alert addAction:defaultAction];
                  [self presentViewController:alert animated:YES completion:nil];
              } else {
                  
                  NSDictionary *response = responseObject[@"user"];
                  
                  user.nick = response[@"nick"];
                  user.email = response[@"email"];
                  user.gender = response[@"gender"];
                  user.picture = response[@"picture"];
                  user.idUser =  response[@"id"];
                  user.race = response[@"race"];
                  user.dob = response[@"dob"];
                  user.user_token = response[@"token"];
                  user.hashtag = response[@"hashtags"];
                  user.household = response[@"household"];
                  user.survey = response[@"surveys"];
                  
                  [self.navigationController pushViewController: [[HomeViewController alloc] init] animated: YES];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar a operação. Tente novamente em alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
              UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                  NSLog(@"You pressed button OK");
              }];
              [alert addAction:defaultAction];
              [self presentViewController:alert animated:YES completion:nil];
          }];
    
}

@end
