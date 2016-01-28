//
//  DetailPhoneViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "DetailPhoneViewController.h"
#import "Phones.h"
#import <Google/Analytics.h>

@interface DetailPhoneViewController ()

@end

@implementation DetailPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Dicas de Saúde";
    
    Phones *phones = [Phones getInstance];
    
    self.lbBody.text = phones.lbBody;
    self.lbDetailBody.text = phones.lbDetailBody;
    self.lbHeader.text = phones.lbHeader;
    self.imgDetail.image = [UIImage imageNamed:phones.imgDetail];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Detail Phone Screen"];
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

- (IBAction)btnCallAction:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_show_phone"
                                                           label:@"Show phone"
                                                           value:nil] build]];
    
    NSString *text;
    
    if ([self.lbBody.text isEqualToString:@"SAMU"]) {
        text = @"Ligar para o SAMU";
    } else if ([self.lbBody.text isEqualToString:@"Polícia Militar"]) {
        text = @"Ligar para o Polícia Militar";
    } else if ([self.lbBody.text isEqualToString:@"Bombeiros"]) {
        text = @"Ligar para o Polícia Bombeiros";
    } else if ([self.lbBody.text isEqualToString:@"Defesa Civil"]) {
        text = @"Ligar para o Polícia Defesa Civil";
    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:text preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Sim" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button YES");
        if ([self.lbBody.text isEqualToString:@"SAMU"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:192"]];
        } else if ([self.lbBody.text isEqualToString:@"Polícia Militar"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:190"]];
        } else if ([self.lbBody.text isEqualToString:@"Bombeiros"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:193"]];
        } else if ([self.lbBody.text isEqualToString:@"Defesa Civil"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:08006440199"]];
        }
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Não" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button NO");
    }];
    [alert addAction:yesAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
