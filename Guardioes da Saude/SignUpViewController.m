//
//  SignUpViewController.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/17/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpDetailsViewController.h"
#import "ViewUtil.h"
#import <Google/Analytics.h>

@interface SignUpViewController (){
    User *user;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Signup Account Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) isValid{
    if ([self.txtEmail.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"E-mail é um campo obrigatório"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtPassword.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Senha é um campo obrigatório"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtPassword.text length] < 6) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Senha precisa ter pelo menos 6 caracteres"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (![self.txtConfirmPassword.text isEqualToString:self.txtPassword.text]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A senha e a confirmação devem ser iguais"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    user = [[User alloc] init];
    user.email = self.txtEmail.text;
    
    if (![user isValidEmail]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"E-mail inválido"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

- (IBAction)btnSignupAction:(id)sender {
    if ([self isValid]) {
        user.password = self.txtPassword.text;
        
        SignUpDetailsViewController *signupDetailsView = [[SignUpDetailsViewController alloc] init];
        signupDetailsView.user = user;
        
        [self.navigationController pushViewController:signupDetailsView animated:YES];
    }
}
@end
