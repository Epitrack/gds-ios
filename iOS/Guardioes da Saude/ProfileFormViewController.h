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

@interface ProfileFormViewController : UIViewController

@property User *user;
@property Household *household;
@property Operation operation;
@property (strong, nonatomic) NSNumber *pictureSelected;

@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UIButton *btnDob;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) NSString *idUser;
@property (strong, nonatomic) NSString *idHousehold;
@property (nonatomic, assign) NSInteger *newMember;
@property (weak, nonatomic) IBOutlet UIButton *btnPicture;
@property (nonatomic, assign) NSInteger *editProfile;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerRace;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerGender;
@property (weak, nonatomic) IBOutlet UIDownPicker *pickerRelationship;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTxtEmailContraint;
@property (weak, nonatomic) IBOutlet UILabel *lbParentesco;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePasswd;

- (IBAction)btnDobAction:(id)sender;
- (IBAction)btnSelectPicture:(id)sender;
- (IBAction)btnAction:(id)sender;
- (void) setAvatarNumber: (NSNumber *) avatarNumber;
- (void) setPhoto: (NSString *) photoUrl;
- (IBAction)btnChangePasswdAction:(id)sender;

@end
