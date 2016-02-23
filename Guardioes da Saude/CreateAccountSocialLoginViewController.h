//
//  CreateAccountSocialLoginViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 20/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"
#import "DateUtil.h"
#import "UserRequester.h"
#import <CoreLocation/CoreLocation.h>
@import DownPicker;

@interface CreateAccountSocialLoginViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate>

@property NSString *socialNetworkId;
@property SocialNetwork socialNetwork;
@property NSString *nick;
@property NSString *email;

@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)btnCadastrar:(id)sender;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
- (IBAction)changeBirthDate:(id)sender;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerGender;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerRace;



@end
