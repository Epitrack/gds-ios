//
//  ForgotPasswordViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 11/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ViewController.h"

@interface ForgotPasswordViewController : ViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)btnSendAction:(id)sender;
- (IBAction)iconBackAction:(id)sender;

@end
