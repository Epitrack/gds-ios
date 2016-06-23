//
//  ThankYouForParticipatingViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 26/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ThankYouForParticipatingViewController.h"
#import "HomeViewController.h"
#import "ViewUtil.h"
#import "User.h"
#import "EmergencyViewController.h"
#import <Google/Analytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface ThankYouForParticipatingViewController (){
    SurveyType surveyType;
    User *user;
}

@end

@implementation ThankYouForParticipatingViewController

- (id)initWithType:(SurveyType)type{
    self = [super init];
    surveyType = type;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"thank_you.title", @"");
    self.navigationItem.hidesBackButton = YES;
    
    self.txHeader.backgroundColor = [UIColor clearColor];
    self.txSurvey.backgroundColor = [UIColor clearColor];
    self.txTellFriends.backgroundColor = [UIColor clearColor];
    
    user = [User getInstance];
    [self addGamePoint];
    user.lastJoinNotification = [NSDate date];
    switch (surveyType) {
        case GOOD_SYMPTOM:
            self.zicaView.hidden = YES;
            self.defaultView.hidden = NO;
            self.txtBadSurvey.hidden = YES;
            break;
        case BAD_SYMPTOM:
            self.zicaView.hidden = YES;
            self.defaultView.hidden = NO;
            break;
        case EXANTEMATICA:
            self.zicaView.hidden = NO;
            self.defaultView.hidden = YES;
            break;
        case DIARREICA:
            self.zicaView.hidden = NO;
            self.defaultView.hidden = YES;
            self.lbMessage.text = NSLocalizedString(@"thank_you.look_emergency", @"");
            break;
        case RESPIRATORIA:
            self.zicaView.hidden = NO;
            self.defaultView.hidden = YES;
            self.lbMessage.text = NSLocalizedString(@"thank_you.look_emergency", @"");
            break;
        default:
            break;
    }
        
}

- (void) addGamePoint{
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:user.lastJoinNotification];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if(!([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era])) {
        user.points = 10;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Thank You For Participating Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (IBAction)btnContinue:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_continue"
                                                           label:@"Continue"
                                                           value:nil] build]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:homeViewController animated:YES];
    
}
- (IBAction)btnFacebookAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_share_facebook"
                                                           label:@"Share facebook"
                                                           value:nil] build]];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *faceSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        [faceSheet setInitialText:NSLocalizedString(@"thank_you.shared_msg", @"")];
        [faceSheet addURL:[NSURL URLWithString:@"http://www.guardioesdasaude.org"]];
        [self presentViewController:faceSheet animated:YES completion:nil];
        
        [faceSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    [self ThankyouForSharing:NO];
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    [self ThankyouForSharing:YES];
                    break;
                default:
                    break;
            }
        }];
    }

}

- (IBAction)btnTwitterAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_share_twitter"
                                                           label:@"Share Twitter"
                                                           value:nil] build]];
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:NSLocalizedString(@"thank_you.shared_msg", @"")];
    //[composer setImage:[UIImage imageNamed:@"fabric"]];
    
   
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:NSLocalizedString(@"thank_you.shared_msg", @"")];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    [self ThankyouForSharing:NO];
                    break;
                case SLComposeViewControllerResultDone:
                    [self ThankyouForSharing:YES];
                    break;
                    
                default:
                    break;
            }
        }];
    }
    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
    
}

- (IBAction)btnWhatsappAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_share_Whatsapp"
                                                           label:@"Share Whatsapp"
                                                           value:nil] build]];
    
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",NSLocalizedString(@"thank_you.shared_msg", @"")];
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"thank_you.whatsapp_not_installed", @"")];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void) ThankyouForSharing:(BOOL)done {
    
    if (done) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"thank_you.thanks_shared", @"")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        [alert show];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        [self.navigationController pushViewController:homeViewController animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"thank_you.share_fail", @"")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        [alert show];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        [self.navigationController pushViewController:homeViewController animated:YES];
    }
    
    
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"returned back to app from facebook post");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"thank_you.thanks_shared", @"")
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert show];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    //HomeViewController *homeViewController = [[HomeViewController alloc] init];
    //[self.navigationController pushViewController:homeViewController animated:YES];
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)share {
    NSLog(@"canceled!");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"sharing error:%@", error);
   
}
- (IBAction)findUPAs:(id)sender {
    EmergencyViewController *emergencyViewController = [[EmergencyViewController alloc] init];
    [self.navigationController pushViewController:emergencyViewController animated:YES];
}
@end
