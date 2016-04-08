//
//  ChangePasswordViewController.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 2/18/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "User.h"
#import "ViewUtil.h"
#import "UserRequester.h"
#import "MBProgressHUD.h"

@interface ChangePasswordViewController (){
    UserRequester *userRequester;
}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userRequester = [[UserRequester alloc] init];
    
    self.navigationItem.title = NSLocalizedString(@"chang_password.title", @"");
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.txPasswdConfirmation resignFirstResponder];
    [self.txPassword resignFirstResponder];
}

- (IBAction)btnSaveAction:(id)sender {
    User *user = [User getInstance];
    user.password = self.txPassword.text;
    
    if ([self isPasswdValid:user]) {
        [userRequester changePasswordWithUser:user
                                  OldPassword:self.txCurrentPassword.text
                                  NewPassword:self.txPassword.text onStart:^{
                                      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                  } onSuccess:^{
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      
                                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                                                     message:NSLocalizedString(@"chang_password.success", @"")
                                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
                                      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.ok", @"")
                                                                                              style:UIAlertActionStyleDefault
                                                                                            handler:^(UIAlertAction * action) {
                                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                                            }];
                                      [alert addAction:defaultAction];
                                      [self presentViewController:alert animated:YES completion:nil];
                                  } onError:^(NSError *error){
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      NSString *msgError;
                                      if (error) {
                                          msgError = NSLocalizedString(@"chang_password.fail", @"");
                                      } else {
                                          msgError = NSLocalizedString(@"chang_password.current_password_different", @"");
                                      }
                                      UIAlertController *alert = [ViewUtil showAlertWithMessage:msgError];
                                      [self presentViewController:alert animated:YES completion:nil];
                                  }];
    }
}

- (BOOL) isPasswdValid: (User *) user{
    if ([self.txCurrentPassword.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"chang_password.current_password_required", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    if (![user.password isEqualToString:self.txPasswdConfirmation.text]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"chang_password.password_isnt_equals", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    if (user.password.length < 6) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"chang_password.min_char_password", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}
@end
