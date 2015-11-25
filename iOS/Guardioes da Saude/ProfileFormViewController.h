//
//  ProfileFormViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 18/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileFormViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentGender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentRace;
@property (weak, nonatomic) IBOutlet UITextField *txtDob;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (IBAction)btnAction:(id)sender;
@property (strong, nonatomic) NSString *idUser;
@property (strong, nonatomic) NSString *idHousehold;
@property (nonatomic, assign) NSInteger *newMember; //0 = YES and 1 = NO
@property (weak, nonatomic) IBOutlet UIButton *btnPicture;
- (IBAction)btnSelectPicture:(id)sender;

@end
