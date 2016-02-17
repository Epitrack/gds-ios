//
//  CreateAccountViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 17/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateUtil.h"
#import "RMDateSelectionViewController.h"
#import <CoreLocation/CoreLocation.h>
@import DownPicker;

@interface CreateAccountViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UITextField *txtDob;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (IBAction)btnAddUser:(id)sender;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerGender;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerRace;
@property (weak, nonatomic) IBOutlet UIButton *btnBirthDate;
- (IBAction)btnBirthDateAction:(id)sender;

@end
