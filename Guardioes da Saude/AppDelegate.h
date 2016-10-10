//
//  AppDelegate.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 27/09/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <Google/CloudMessaging.h>

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;
@end

