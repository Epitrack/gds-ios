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

@interface ChangePasswordViewController (){
    UserRequester *userRequester;
}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userRequester = [[UserRequester alloc] init];
    
    self.navigationItem.title = @"Redefinir senha";
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
        [userRequester updateUser:user
                        onSuccess:^(User *user){
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                                           message:@"Senha atualizada com sucesso."
                                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                    style:UIAlertActionStyleDefault
                                                                                  handler:^(UIAlertAction * action) {
                                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                                  }];
                            [alert addAction:defaultAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        } onFail:^(NSError *error){
                            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Ocorreu um erro ao atualizar o usuário."];
                            [self presentViewController:alert animated:YES completion:nil];
                        }];
    }
}

- (BOOL) isPasswdValid: (User *) user{
    if (![user.password isEqualToString:self.txPasswdConfirmation.text]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"As senhas não estão iguais."];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    if (user.password.length < 6) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A senha deve ter mais de 6 caracteres."];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}
@end
