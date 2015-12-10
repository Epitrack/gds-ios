//
//  ModalPrivViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 10/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ModalPrivViewController.h"
#import "SelectTypeCreateAccoutViewController.h"

@interface ModalPrivViewController ()

@end

@implementation ModalPrivViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)btnOK:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    SelectTypeCreateAccoutViewController *selectTypeCreateAccountViewController = [[SelectTypeCreateAccoutViewController alloc] init];
    [self.navigationController pushViewController:selectTypeCreateAccountViewController animated:YES];
    
}
@end
