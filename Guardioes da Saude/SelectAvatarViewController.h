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

@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;

- (IBAction)selectAvatarAction:(id)sender;

-(void) setUrlPhoto: (NSString *) urlPhoto;

@end
