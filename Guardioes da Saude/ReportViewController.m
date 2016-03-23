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
    self.navigationItem.title = NSLocalizedString(@"report.title", @"");
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    self.txtMessage.layer.borderWidth = 1.0f;
    self.txtMessage.layer.cornerRadius = 5;
    self.txtMessage.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];

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
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_send_report"
                                                           label:@"Send Report"
                                                           value:nil] build]];
    
    
    [self.txtSubject resignFirstResponder];
    [self.txtMessage resignFirstResponder];
    
    if ([self.txtSubject.text isEqualToString:@""] || [self.txtMessage.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:NSLocalizedString(@"report.required_filds", @"") preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
                                                      UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"report.success", @"")];
                                                      [self presentViewController:alert animated:YES completion:nil];
                                                      
                                                      self.txtSubject.text = @"";
                                                      self.txtMessage.text = @"";
                                                  }
                                               andOnError:^(NSError *error){
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                   NSString *errorMsg;
                                                   if (error && error.code == -1009) {
                                                       errorMsg = NSLocalizedString(kMsgConnectionError, @"");
                                                   } else {
                                                       errorMsg = NSLocalizedString(@"report.error", @"");
                                                   }
                                                   
                                                   [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                               }];
    }
    
}
@end
