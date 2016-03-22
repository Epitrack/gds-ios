//
//  SignUpViewController.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/17/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnSignupAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@end
