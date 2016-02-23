//
//  SelectAvatarViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 24/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ProfileFormViewController.h"

@interface SelectAvatarViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (instancetype)initWithBtnCamera: (bool) showBtnCamera;

@property ProfileFormViewController *profileFormCtr;

@property UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIButton *btn10;
@property (weak, nonatomic) IBOutlet UIButton *btn11;
@property (weak, nonatomic) IBOutlet UIButton *btn12;
- (IBAction)btnPhotoAction:(id)sender;
- (IBAction)btn1Action:(id)sender;
- (IBAction)btn2Action:(id)sender;
- (IBAction)btn5Action:(id)sender;
- (IBAction)btn6Action:(id)sender;
- (IBAction)btn3Action:(id)sender;
- (IBAction)btn4Action:(id)sender;
- (IBAction)btn8Action:(id)sender;
- (IBAction)btn9Action:(id)sender;
- (IBAction)btn10Action:(id)sender;
- (IBAction)btn7Action:(id)sender;
- (IBAction)btn11Action:(id)sender;
- (IBAction)btn12Action:(id)sender;
- (IBAction)btn13Action:(id)sender;
- (IBAction)btn14Action:(id)sender;
- (IBAction)btn15Action:(id)sender;
- (IBAction)btn16Action:(id)sender;
- (IBAction)btn17Action:(id)sender;

-(void) setUrlPhoto: (NSString *) urlPhoto;

@end
