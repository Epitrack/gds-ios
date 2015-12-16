//
//  ThankYouForParticipatingViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 26/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ThankYouForParticipatingViewController.h"
#import "HomeViewController.h"


@interface ThankYouForParticipatingViewController ()

@end

@implementation ThankYouForParticipatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";
    self.navigationItem.hidesBackButton = YES;
    
    /*CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if (result.height < 568) {
        self.imgCheckSurvey.hidden = YES;
    }*/
        
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (IBAction)btnContinue:(id)sender {
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:homeViewController animated:YES];
    
}
- (IBAction)btnFacebookAction:(id)sender {
    /*FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://www.guardioesdasaude.org"];
    content.contentTitle= @"Guardiões da Saúde";
    content.contentDescription= @"Acabei de participar do Guardiões da Saúde, participe você também: www.guardioesdasaude.org";
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:self];*/
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *faceSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        [faceSheet setInitialText:@"Acabei de participar do Guardiões da Saúde, participe você também: www.guardioesdasaude.org"];
        [faceSheet addImage:[UIImage imageNamed:@"icon_logo_splash.png"]];
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
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:@"Acabei de participar do Guardiões da Saúde, participe você também: www.guardioesdasaude.org"];
    //[composer setImage:[UIImage imageNamed:@"fabric"]];
    
   
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Acabei de participar do Guardiões da Saúde, participe você também: www.guardioesdasaude.org"];
        [tweetSheet addImage:[UIImage imageNamed:@"icon_logo_splash.png"]];
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

- (void) ThankyouForSharing:(BOOL)done {
    
    if (done) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Obrigado por compartilhar!"
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
                                                        message:@"Não foi possível compartilhar sua participação."
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
                                                    message:@"Obrigado por compartilhar!"
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
@end
