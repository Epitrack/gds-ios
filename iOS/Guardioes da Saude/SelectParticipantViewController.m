//
//  SelectParticipantViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 26/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectParticipantViewController.h"
#import "User.h"
#import "SelectStateViewController.h"

@interface SelectParticipantViewController ()

@end

@implementation SelectParticipantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    User *user = [User getInstance];
    
    self.txtNameMainMember.text = user.nick;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    
    NSString *dobUser = [user.dob componentsSeparatedByString:@"-"][0];
    NSString *currentDate = [format stringFromDate:[NSDate date]];
    NSInteger ageUser= [currentDate intValue] - [dobUser intValue];
    
    self.txtDobMainMember.text = [NSString stringWithFormat:@"%d Anos", ageUser];
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

- (IBAction)btnSelectMainMember:(id)sender {
    
    SelectStateViewController *selectStateViewController = [[SelectStateViewController alloc] init];
    [self.navigationController pushViewController:selectStateViewController animated:YES];
}
@end
