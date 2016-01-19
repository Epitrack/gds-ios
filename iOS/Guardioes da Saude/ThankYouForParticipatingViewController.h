//
//  ThankYouForParticipatingViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 26/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterKit/TwitterKit.h>

@interface ThankYouForParticipatingViewController : UIViewController<FBSDKSharingDelegate>
- (IBAction)btnContinue:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtBadSurvey;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckSurvey;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
- (IBAction)btnFacebookAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;
- (IBAction)btnWhatsappAction:(id)sender;

@end
