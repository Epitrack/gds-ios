//
//  CreateAccountSocialLoginViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 20/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountSocialLoginViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)btnCadastrar:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *dtPikerDob;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerGender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerRace;



@end
