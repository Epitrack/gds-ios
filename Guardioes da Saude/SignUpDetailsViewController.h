//
//  SignUpDetailsViewController.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/17/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "RMDateSelectionViewController.h"
#import <CoreLocation/CoreLocation.h>
@import DownPicker;

@interface SignUpDetailsViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UIButton *btnDob;
@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtGender;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtRace;


- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnDobAction:(id)sender;
- (IBAction)btnSignupAction:(id)sender;
@end
