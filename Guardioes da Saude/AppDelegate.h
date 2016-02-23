//
//  AppDelegate.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 27/09/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;

@end

