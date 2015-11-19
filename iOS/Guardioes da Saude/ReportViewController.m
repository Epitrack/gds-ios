//
//  ReportViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ReportViewController.h"
#import "AFNetworking/AFNetworking.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Relatar Erros";
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
        
        AFHTTPRequestOperationManager *manager;
        NSDictionary *params;
        
        params = @{@"title":self.txtSubject.text.lowercaseString,
                   @"text": self.txtMessage.text};
        
        manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://52.20.162.21/email/log"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  if ([responseObject[@"error"] boolValue] == 1) {
                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível enviar sua mensagem. Tente novamente em alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
                      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                          NSLog(@"You pressed button OK");
                      }];
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                  } else {
                      
                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Mensagem enviada com sucesso. Obrigado!" preferredStyle:UIAlertControllerStyleActionSheet];
                      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                          NSLog(@"You pressed button OK");
                          }];
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                      
                      self.txtSubject.text = @"";
                      self.txtMessage.text = @"";
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível enviar sua mensagem. Tente novamente em alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
                  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                      NSLog(@"You pressed button OK");
                  }];
                  [alert addAction:defaultAction];
                  [self presentViewController:alert animated:YES completion:nil];
              }];
        
    }
    
}
@end
