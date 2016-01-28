//
//  HelpViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 13/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "HelpViewController.h"
#import "SWRevealViewController.h"
#import "TermsViewController.h"
#import "TutorialHelpViewController.h"
#import "ReportViewController.h"
#import "ViewUtil.h"
#import "Requester.h"
#import <Google/Analytics.h>

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Ajuda";
    
    self.navigationItem.hidesBackButton = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Help Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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

- (IBAction)btnTutorial:(id)sender {
    
    TutorialHelpViewController *tutorialHelpViewController = [[TutorialHelpViewController alloc] init];
    [self.navigationController pushViewController:tutorialHelpViewController animated:YES];
}

- (IBAction)btnFacebook:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/minsaude"]];
}

- (IBAction)btnTwitter:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/minsaude"]];
}

- (IBAction)btnTerms:(id)sender {
    
    TermsViewController *termsViewController = [[TermsViewController alloc] init];
    [self.navigationController pushViewController:termsViewController animated:YES];
}

- (IBAction)btnReport:(id)sender {
    if([Requester isConnected]){
    ReportViewController *reportViewController = [[ReportViewController alloc] init];
    [self.navigationController pushViewController:reportViewController animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}
@end
