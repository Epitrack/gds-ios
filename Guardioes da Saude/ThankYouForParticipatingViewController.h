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
#import "SurveyMap.h"

@interface ThankYouForParticipatingViewController : UIViewController<FBSDKSharingDelegate>

- (id) initWithType:(SurveyType) type;

- (IBAction)btnContinue:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtBadSurvey;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckSurvey;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;
- (IBAction)btnFacebookAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;
- (IBAction)btnWhatsappAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *defaultView;
@property (weak, nonatomic) IBOutlet UIView *zicaView;
- (IBAction)findUPAs:(id)sender;

@end
