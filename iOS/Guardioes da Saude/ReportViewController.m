//
//  ReportViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ReportViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "User.h"
#import "ViewUtil.h"
#import "UserRequester.h"
#import "MBProgressHUD.h"
#import <Google/Analytics.h>

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Relatar Erros";
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    self.txtMessage.layer.borderWidth = 1.0f;
    self.txtMessage.layer.borderColor = [[UIColor grayColor] CGColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Report Error Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtSubject endEditing:YES];
    [self.txtMessage endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self.txtSubject resignFirstResponder];
    [self.txtMessage resignFirstResponder];
    return TRUE;
}

- (IBAction)btSendReport:(id)sender {
    
    [self.txtSubject resignFirstResponder];
    [self.txtMessage resignFirstResponder];
    
    if ([self.txtSubject.text isEqualToString:@""] || [self.txtMessage.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Assunto e/ou mensagem não informados." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
         [[[UserRequester alloc] init] reportBugWithTitle:self.txtSubject.text
                                                  andText:self.txtMessage.text andOnStart:^{
                                                      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                  } andOnSuccess:^{
                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                      UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Mensagem enviada com sucesso. Obrigado!"];
                                                      [self presentViewController:alert animated:YES completion:nil];
                                                      
                                                      self.txtSubject.text = @"";
                                                      self.txtMessage.text = @"";
                                                  }
                                               andOnError:^(NSError *error){
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                   NSString *errorMsg;
                                                   if (error && error.code == -1009) {
                                                       errorMsg = kMsgConnectionError;
                                                   } else {
                                                       errorMsg = @"Não foi possível enviar o e-mail. Tente novamente em alguns minutos.";
                                                   }
                                                   
                                                   [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                               }];
    }
    
}
@end
