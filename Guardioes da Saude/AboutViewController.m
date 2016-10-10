
//
//  AboutViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 13/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"
#import "ViewUtil.h"
#import "Requester.h"
#import "User.h"
#import <Google/Analytics.h>
#import "ViewUtil.h"

@interface AboutViewController (){
    int counter;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"about.title", @"");
    
    self.navigationItem.hidesBackButton = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    
    [self.txtAbout setContentOffset:CGPointZero];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.lbVersion.text = [NSString stringWithFormat:@"v %@", version];
    
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.lbBuild.text = [NSString stringWithFormat:@"b %@", build];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [ViewUtil applyFont:self.txtAbout.font
              withColor:[UIColor colorWithRed:15.0/255.0 green:76.0/255.0 blue:153.0/255.0 alpha:1]
                 ranges:@[NSLocalizedString(@"about.subtitle1", @""),
                         NSLocalizedString(@"about.subtitle2", @""),
                         NSLocalizedString(@"about.subtitle3", @""),
                         NSLocalizedString(@"about.subtitle4", @""),
                         NSLocalizedString(@"about.subtitle5", @""),
                         NSLocalizedString(@"about.subtitle6", @"")]
             atTextView:self.txtAbout];
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"About Screen Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (IBAction)btnAboutAction:(id)sender {
    if (counter >= 5) {
        counter = 0;
        Requester *requester = [[Requester alloc] init];
        
        UIAlertController *alert = [ViewUtil showAlertWithMessage:[requester getUrl]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        counter ++;
    }
}
@end
