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

@interface HealthTipsViewController ()

@end

@implementation HealthTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Dicas de Saúde";
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
    EmergencyViewController *emergencyViewController = [[EmergencyViewController alloc] init];
    [self.navigationController pushViewController:emergencyViewController animated:YES];
}

- (IBAction)vacine:(id)sender {
    VacineViewController *vacineViewController = [[VacineViewController alloc] init];
    [self.navigationController pushViewController:vacineViewController animated:YES];
}

- (IBAction)pharmacy:(id)sender {
    PharmacyViewController *pharmacyViewConroller = [[PharmacyViewController alloc] init];
    [self.navigationController pushViewController:pharmacyViewConroller animated:YES];
}

- (IBAction)basicCare:(id)sender {
    BasicCareViewController *basicCareViewController = [[BasicCareViewController alloc] init];
    [self.navigationController pushViewController:basicCareViewController animated:YES];
}

- (IBAction)prevention:(id)sender {
    PreventionViewController *preventionViewController = [[PreventionViewController alloc] init];
    [self.navigationController pushViewController:preventionViewController animated:YES];
}

- (IBAction)phones:(id)sender {
    PhonesViewController *phonesViewController = [[PhonesViewController alloc] init];
    [self.navigationController pushViewController:phonesViewController animated:YES];
}
@end
