//
//  CreateAccountViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 17/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentGender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentRace;
@property (weak, nonatomic) IBOutlet UITextField *txtDob;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (IBAction)btnAddUser:(id)sender;

@end
