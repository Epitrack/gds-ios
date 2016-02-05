//
//  AppDelegate.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 27/09/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "RearViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "TutorialViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "User.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <Google/Analytics.h>
@import GoogleMaps;

NSString *const kPreferencesVersionKey = @"preferenceVersionKey";
NSString *const kCurrentVersionPreferences = @"002";

@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate

NSUserDefaults *preferences;

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [GMSServices provideAPIKey:@"AIzaSyBKd0Hwx2SLZYgvE6vh2pRXjAs5JkipvqI"];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;

    MenuViewController *rearViewController = [[MenuViewController alloc] init];
    
    SWRevealViewController *revealController;
    
    preferences = [NSUserDefaults standardUserDefaults];
    
    [self checkPreferencesVersion:preferences];
    
    if ([preferences objectForKey:kUserTokenKey] != nil) {
        HomeViewController *frontViewController = [[HomeViewController alloc] init];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        revealController.delegate = self;
        self.viewController = revealController;
    } else {
        TutorialViewController *frontViewController = [[TutorialViewController alloc] init];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        revealController.delegate = self;
        self.viewController = revealController;
    }
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(10/255.0) green:(88/255.0) blue:(163/255.0) alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"Foco" size:20.0], NSFontAttributeName, nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //GOOGLE
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    //FACEBOOK
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //TWITTER
    [Fabric with:@[[Twitter class]]];
    [[Twitter sharedInstance] startWithConsumerKey:@"2lnE0tRTpj0VPihSOpvrT13rv" consumerSecret:@"lbcEUcgSSZrzpRDkwPoBlj0BbcWADPymMLvvFewbwTO2j426hx"];
    [Fabric with:@[[Twitter sharedInstance]]];
    
    return YES;
}

- (void)checkPreferencesVersion: (NSUserDefaults *) preferences{
    NSString *version = [preferences objectForKey:kPreferencesVersionKey];
    if (version == nil || ![version isEqualToString:kCurrentVersionPreferences]) {
        //Clean preferences
        [preferences setValue:nil forKey:kUserTokenKey];
        [preferences setValue:nil forKey:kAppTokenKey];
        [preferences setValue:nil forKey:kAvatarNumberKey];
        [preferences setValue:nil forKey:kPhotoKey];
        [preferences setValue:nil forKey:kNickKey];
        
        //Set current version
        [preferences setValue:kCurrentVersionPreferences forKey:kPreferencesVersionKey];
        
        [preferences synchronize];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // ...
}


//FACEBOOK
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ] || [[GIDSignIn sharedInstance] handleURL:url
                                     sourceApplication:sourceApplication
                                            annotation:annotation];
}

////GOOGLE
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:sourceApplication
//                                      annotation:annotation];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - SWRevealViewDelegate

- (id <UIViewControllerAnimatedTransitioning>)revealController:(SWRevealViewController *)revealController animationControllerForOperation:(SWRevealControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ( operation != SWRevealControllerOperationReplaceRightController )
        return nil;
    
    return nil;
}


#define LogDelegates 0

#if LogDelegates
- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position {
    NSString *str = nil;
    if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    if ( position == FrontViewPositionLeftSideMost) str = @"FrontViewPositionLeftSideMost";
    if ( position == FrontViewPositionLeftSide) str = @"FrontViewPositionLeftSide";
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position {
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController; {
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController; {
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress {
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress {
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureEndedToLocation:(CGFloat)location progress:(CGFloat)progress{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController willAddViewController:(UIViewController *)viewController forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated {
    NSLog( @"%@: %@, %d", NSStringFromSelector(_cmd), viewController, operation);
}

- (void)revealController:(SWRevealViewController *)revealController didAddViewController:(UIViewController *)viewController forOperation:(SWRevealControllerOperation)operation animated:(BOOL)animated {
    NSLog( @"%@: %@, %d", NSStringFromSelector(_cmd), viewController, operation);
}

#endif


@end
