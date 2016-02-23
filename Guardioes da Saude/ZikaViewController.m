//
//  ZikaViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 16/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ZikaViewController.h"
#import <Google/Analytics.h>

@interface ZikaViewController ()

@end

@implementation ZikaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Dicas de Saúde";
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    NSString *text = self.txtContent.text;
    
    NSRange rangeBold = [text rangeOfString:@"aegypti"];
    NSRange rangeBold2 = [text rangeOfString:@"aegypti,"];
    
    UIFont *fontText = [UIFont italicSystemFontOfSize:12];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:fontText, NSFontAttributeName, nil];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.txtContent.text];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"tel://136"
                             range:[[attributedString string] rangeOfString:@"136"]];
    [attributedString setAttributes:dictBoldText range:rangeBold];
    [attributedString setAttributes:dictBoldText range:rangeBold2];
    
    self.txtContent.attributedText = attributedString;
    self.txtContent.textColor = [UIColor colorWithRed:15.0/255.0 green:76.0/255.0 blue:153.0/255.0 alpha:1];

    self.txtContent.delegate = self;
    
    [self.txtContent setContentOffset:CGPointZero];
}

- (IBAction)basicCare:(id)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Zika Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
