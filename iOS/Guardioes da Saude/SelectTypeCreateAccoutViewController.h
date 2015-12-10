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

@interface SelectTypeCreateAccoutViewController : UIViewController <GIDSignInUIDelegate, GIDSignInDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *btnFacebook;
@property (weak, nonatomic) IBOutlet GIDSignInButton *btnGoogle;
@property (weak, nonatomic) IBOutlet TWTRLogInButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
- (IBAction)btnFacebookAction:(id)sender;
- (IBAction)btnGoogleAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;
- (IBAction)btnEmailAction:(id)sender;
- (IBAction)btnTermsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckTerms;
- (IBAction)btnCheckTermsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogleDesable;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitterDesable;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebookDesable;
- (IBAction)btnFacebookDesableAction:(id)sender;
- (IBAction)btnGoogleDesabelAction:(id)sender;
- (IBAction)btnTwitterDesabelAction:(id)sender;
- (IBAction)btnInfoAction:(id)sender;
- (IBAction)btnBackAction:(id)sender;

@end
