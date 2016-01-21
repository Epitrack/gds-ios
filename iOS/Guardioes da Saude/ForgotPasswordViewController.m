//
//  ForgotPasswordViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 11/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "EnterViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "ViewUtil.h"
#import "UserRequester.h"
#import "MBProgressHUD.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.txtEmail setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtEmail endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSendAction:(id)sender {
    
    if ([self.txtEmail.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"E-mail não informado." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
    
        [[[UserRequester alloc] init] forgotPasswordWithEmail:self.txtEmail.text.lowercaseString
                                                   andOnStart:^{
                                                       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   }
                                                 andOnSuccess:^{
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                     UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Email enviado com sucesso."];
                                                     [self presentViewController:alert animated:YES completion:nil];
                                                 }
                                                   andOnError:^(NSError *error){
                                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                       NSString *errorMsg;
                                                       if (error && error.code == -1009) {
                                                           errorMsg = kMsgConnectionError;
                                                       } else if(errorMsg){
                                                           errorMsg = kMsgApiError;
                                                       }else{
                                                           errorMsg = @"E-mail não encontrado!";
                                                       }
                                                       
                                                       [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                                   }];
    }
}

- (IBAction)iconBackAction:(id)sender {
    
    EnterViewController *enterViewController = [[EnterViewController alloc] init];
    [self.navigationController pushViewController:enterViewController animated:YES];
    
}
@end
