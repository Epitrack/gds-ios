//
//  SelectAvatarViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 24/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectAvatarViewController.h"
#import "User.h"

@interface SelectAvatarViewController ()

@end

@implementation SelectAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Editar Foto";
    
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

- (IBAction)btnPhotoAction:(id)sender {
}

- (IBAction)btn1Action:(id)sender {
}

- (IBAction)btn2Action:(id)sender {
}

- (IBAction)btn5Action:(id)sender {
}

- (IBAction)btn6Action:(id)sender {
}

- (IBAction)btn4Action:(id)sender {
}

- (IBAction)btn8Action:(id)sender {
}

- (IBAction)btn9Action:(id)sender {
}

- (IBAction)btn10Action:(id)sender {
}

- (IBAction)btn7Action:(id)sender {
}

- (IBAction)btn11Action:(id)sender {
}

- (IBAction)btn12Action:(id)sender {
}

- (IBAction)btn3Action:(id)sender {
}

- (void) setAvatar:(NSString *)idAvatar {
    
    User *user = [User getInstance];
    user.avatar = idAvatar;
    
    
    
    
}












@end
