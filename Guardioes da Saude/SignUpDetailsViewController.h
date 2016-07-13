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

@interface SignUpDetailsViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UILabel *lbEmail;
@property (weak, nonatomic) IBOutlet UILabel *lbState;
@property (weak, nonatomic) IBOutlet UILabel *lbRace;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnDob;
@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtGender;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtRace;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtCountry;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtState;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtPerfil;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopNick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTopButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTopLbRace;

- (IBAction)btnBackAction:(id)sender;
- (IBAction)btnDobAction:(id)sender;
- (IBAction)btnSignupAction:(id)sender;
@end
