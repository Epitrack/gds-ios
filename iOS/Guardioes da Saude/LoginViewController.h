//
//  LoginViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 07/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLogin:(id)sender;
@end
