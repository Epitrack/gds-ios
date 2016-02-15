//
//  OverlayViewController.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 2/12/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "ViewController.h"
#import "ProfileFormViewController.h"

@interface OverlayViewController : ViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property UIImagePickerController *pickerReference;
@property ProfileFormViewController *profileFormReference;
- (IBAction)takePhoto:(id)sender;
- (IBAction)cancel:(id)sender;

@end
