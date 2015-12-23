//
//  SelectTypeCreateAccoutViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 20/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface SelectTypeCreateAccoutViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

- (IBAction)btnFacebookAction:(id)sender;
- (IBAction)btnGoogleAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;
- (IBAction)btnEmailAction:(id)sender;
- (IBAction)btnTermsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckTerms;
- (IBAction)btnCheckTermsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogle;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
- (IBAction)btnInfoAction:(id)sender;
- (IBAction)btnBackAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;

@end
