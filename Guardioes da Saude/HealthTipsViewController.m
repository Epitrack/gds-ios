//
//  HealthTipsViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "HealthTipsViewController.h"
#import "VacineViewController.h"
#import "PharmacyViewController.h"
#import "BasicCareViewController.h"
#import "EmergencyViewController.h"
#import "PreventionViewController.h"
#import "PhonesViewController.h"
#import "ZikaViewController.h"
#import "Requester.h"
#import "ViewUtil.h"
#import "TravelerHealthViewController.h"
#import "Guardioes_da_Saude-Swift.h"
#import <Google/Analytics.h>

@interface HealthTipsViewController ()

@end

@implementation HealthTipsViewController

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
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Health Tips Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self applyTranslation];
}

- (void)applyTranslation{
    self.txZika.backgroundColor = [UIColor clearColor];
    self.txEmergency.backgroundColor = [UIColor clearColor];
    self.txVacine.backgroundColor = [UIColor clearColor];
    self.txPhones.backgroundColor = [UIColor clearColor];
    self.txPharmacy.backgroundColor = [UIColor clearColor];
    self.txBasicCare.backgroundColor = [UIColor clearColor];
    self.txPrevention.backgroundColor = [UIColor clearColor];
    self.txHealthTraveler.backgroundColor = [UIColor clearColor];
    self.txSafeSex.backgroundColor = [UIColor clearColor];
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

- (IBAction)emergency:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_emergency"
                                                           label:@"Emergency"
                                                           value:nil] build]];
    
    if ([Requester isConnected]) {
        EmergencyViewController *emergencyViewController = [[EmergencyViewController alloc] init];
        [self.navigationController pushViewController:emergencyViewController animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
    
}

- (IBAction)vacine:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_vacine"
                                                           label:@"Vacine"
                                                           value:nil] build]];
    
    VacineViewController *vacineViewController = [[VacineViewController alloc] init];
    [self.navigationController pushViewController:vacineViewController animated:YES];
}

- (IBAction)pharmacy:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_pharmacy"
                                                           label:@"Pharmacy"
                                                           value:nil] build]];
    
    if([Requester isConnected]){
        PharmacyViewController *pharmacyViewConroller = [[PharmacyViewController alloc] init];
        [self.navigationController pushViewController:pharmacyViewConroller animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (IBAction)basicCare:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_basic_care"
                                                           label:@"Basic care"
                                                           value:nil] build]];
    
    BasicCareViewController *basicCareViewController = [[BasicCareViewController alloc] init];
    [self.navigationController pushViewController:basicCareViewController animated:YES];
}

- (IBAction)prevention:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_prevention"
                                                           label:@"Prevention"
                                                           value:nil] build]];
    
    PreventionViewController *preventionViewController = [[PreventionViewController alloc] init];
    [self.navigationController pushViewController:preventionViewController animated:YES];
}

- (IBAction)phones:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_phones"
                                                           label:@"Phones"
                                                           value:nil] build]];
    
    PhonesViewController *phonesViewController = [[PhonesViewController alloc] init];
    [self.navigationController pushViewController:phonesViewController animated:YES];
}

- (IBAction)zika:(id)sender {
    ZikaViewController *zikaViewController = [[ZikaViewController alloc] init];
    [self.navigationController pushViewController:zikaViewController animated:YES];
}
- (IBAction)travelerHealth:(id)sender {
    TravelerHealthViewController *travelerHealthView = [[TravelerHealthViewController alloc] init];
    
    [self.navigationController pushViewController:travelerHealthView animated:YES];
}

- (IBAction)btnSafeSex:(id)sender {
    SafeSexViewController *safeSex = [[SafeSexViewController alloc] init];
    [self.navigationController pushViewController:safeSex animated:true];
}
@end
