//
//  SelectTypeLoginViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 06/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>

@interface SelectTypeLoginViewController : UIViewController <GIDSignInUIDelegate>
- (IBAction)btnLoginEmail:(id)sender;
@property (weak, nonatomic) IBOutlet GIDSignInButton *btnGoogle;
- (IBAction)btnGoogleAction:(id)sender;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *btnFacebook;
@property (weak, nonatomic) IBOutlet TWTRLogInButton *btnTwitter;
- (IBAction)btnFacebookAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;
- (IBAction)iconBackAction:(id)sender;


@end
