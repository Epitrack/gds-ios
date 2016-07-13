//
//  ProfileFormViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 18/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Household.h"
#import "User.h"
#import "RMDateSelectionViewController.h"
@import DownPicker;

typedef enum operation{
    EDIT_USER,
    EDIT_HOUSEHOLD,
    ADD_HOUSEHOLD
} Operation;

@interface ProfileFormViewController : UIViewController <UITextFieldDelegate>

@property User *user;
@property Household *household;
@property Operation operation;
@property (strong, nonatomic) NSNumber *pictureSelected;
@property (nonatomic, assign) NSInteger *newMember;
@property (nonatomic, assign) NSInteger *editProfile;
@property (strong, nonatomic) NSString *idUser;
@property (strong, nonatomic) NSString *idHousehold;

@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UIButton *btnDob;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPerfil;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtPerfil;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UIDownPicker *txtState;
@property (weak, nonatomic) IBOutlet UIButton *btnPicture;
@property (weak, nonatomic) IBOutlet UILabel *lbRace;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerRace;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerGender;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerRelationship;
@property (weak, nonatomic) IBOutlet UILabel *lbParentesco;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePasswd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTopEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblOr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbRelationshipConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnChangeTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnSaveBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbRaceTopConst;

- (IBAction)btnDobAction:(id)sender;
- (IBAction)btnSelectPicture:(id)sender;
- (IBAction)btnAction:(id)sender;
- (void) setAvatarNumber: (NSNumber *) avatarNumber;
- (void) setPhoto: (NSString *) photoUrl;
- (IBAction)btnChangePasswdAction:(id)sender;
- (IBAction)btnDeleteAction:(id)sender;

@end
