//
//  TermsViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 13/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import "UserRequester.h"

typedef enum CreateType{
    NO_CREATE,
    EMAIL,
    SOCIAL_NETWORK
}CreateType;

@interface TermsViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@property CreateType createType;
@property NSString *socialNetworkId;
@property SocialNetwork socialNetwork;


@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constScrollBottom;
- (IBAction)btnDeclineAction:(id)sender;
- (IBAction)btnAcceptAction:(id)sender;

@end
