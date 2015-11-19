//
//  EnterViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 06/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "EnterViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "Facade.h"
#import "UserRequester.h"

@interface EnterViewController ()

@end

@implementation EnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";
    self.navigationItem.hidesBackButton = NO;

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtEmail endEditing:YES];
    [self.txtPassword endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    return TRUE;
}

- (IBAction)btnEnter:(id)sender {
    
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    if (([self.txtEmail.text isEqualToString: @""]) || ([self.txtPassword.text isEqualToString: @""])) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"E-mail e/ou senha não informados." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        User * user = [[User alloc] init];
        
        user.email = self.txtEmail.text;
        user.password = self.txtPassword.text;
        
        [self requestLogin: user];
    }
}

- (void) requestLogin: (User *) user {
    
    [[[UserRequester alloc] init] login: user
     
        onStart: ^{
    
        }
    
        onError: ^(NSString * message) {
    
        }
    
        onSuccess: ^(User * user) {
            
            if (user.user_token) {
                
                [self.navigationController pushViewController: [[HomeViewController alloc] init] animated: YES];
            
            } else {
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle: @"Guardiões da Saúde"
                                                                                message: @"Não foi possível fazer o login. E-mail e/ou senha inválidos."
                                                                         preferredStyle: UIAlertControllerStyleActionSheet];
                
                UIAlertAction * defaultAction = [UIAlertAction actionWithTitle: @"OK"
                                                                         style: UIAlertActionStyleDefault
                                                                       handler: ^(UIAlertAction * action) {
                                                                           
                                                                           NSLog(@"You pressed button OK");
                                                                       }
                ];
                
                [alert addAction: defaultAction];
                
                [self presentViewController: alert animated: YES completion: nil];
            }
        }
    ];
}

- (void) requestLoginOld {
    
    AFHTTPRequestOperationManager *manager;
    NSDictionary *params;
    
    NSLog(@"Email: %@", self.txtEmail.text);
    NSLog(@"Password: %@", self.txtPassword.text);
    
    params = @{@"email":self.txtEmail.text.lowercaseString,
               @"password": self.txtPassword.text};
    
    manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://52.20.162.21/user/login"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              if ([responseObject[@"error"] boolValue] == 1) {
                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível fazer o login. E-mail e/ou senha inválidos." preferredStyle:UIAlertControllerStyleActionSheet];
                  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                      NSLog(@"You pressed button OK");
                  }];
                  [alert addAction:defaultAction];
                  [self presentViewController:alert animated:YES completion:nil];
              } else {
                  
                  Facade *facade = [[Facade alloc] init];
                  facade.action = @"LOGIN";
                  facade.dictionary = responseObject;
                  [facade run];
                  
                  User *user = [User getInstance];
                  
                  if (user.user_token == NULL) {
                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível fazer o login. E-mail e/ou senha inválidos." preferredStyle:UIAlertControllerStyleActionSheet];
                      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                          NSLog(@"You pressed button OK");
                      }];
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                  } else {
                      HomeViewController *homeViewController = [[HomeViewController alloc] init];
                      [self.navigationController pushViewController:homeViewController animated:YES];
                  }
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível fazer o login. E-mail e/ou senha inválidos." preferredStyle:UIAlertControllerStyleActionSheet];
              UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                  NSLog(@"You pressed button OK");
              }];
              [alert addAction:defaultAction];
              [self presentViewController:alert animated:YES completion:nil];
          }];

}

@end
