//
//  ChangePasswordViewController.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 2/18/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "ViewController.h"

@interface ChangePasswordViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *txPassword;
@property (weak, nonatomic) IBOutlet UITextField *txPasswdConfirmation;

- (IBAction)btnSaveAction:(id)sender;
@end
