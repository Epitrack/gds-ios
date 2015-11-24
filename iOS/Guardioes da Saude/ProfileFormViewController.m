//
//  ProfileFormViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 18/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ProfileFormViewController.h"
#import "User.h"
#import "Household.h"
#import "AFNetworking/AFNetworking.h"
#import "ProfileListViewController.h"
#import "SelectAvatarViewController.h"

@interface ProfileFormViewController () {
    
    User *user;
    NSDictionary *params;
    
}

@end

@implementation ProfileFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    user = [User getInstance];
    if (self.newMember == 0) {
        self.navigationItem.title = @"Adicionar Membro";
    } else {
        if (self.idUser != nil || self.idHousehold != nil) {
            self.navigationItem.title = @"Editar Perfil";
            [self loadData];
        }
    }
    

}

- (void) loadData {
    
    if (self.idHousehold == nil) {
        
        NSString *avatar;
        
        @try {
            if (user.picture.length > 2) {
                avatar = @"img_profile01";
            }
        }
        @catch (NSException *exception) {
            
            NSString *p = [NSString stringWithFormat:@"%@", user.picture];
            
            if (p.length == 1) {
                avatar = [NSString stringWithFormat: @"img_profile0%@", p];
            } else if (p.length == 2) {
                avatar = [NSString stringWithFormat: @"img_profile%@", p];
            }
        }
        
        self.imgProfile.image = [UIImage imageNamed:avatar];
        
        self.txtNick.text = user.nick;
        self.txtEmail.text = user.email;
        self.txtPassword.text = @"";
        
        NSLog(@"dob %@", user.dob);
        
        NSLog(@"Dia %@", [user.dob substringWithRange:NSMakeRange(8, 2)]);
        NSLog(@"Mês %@", [user.dob substringWithRange:NSMakeRange(5, 2)]);
        NSLog(@"Ano %@", [user.dob substringWithRange:NSMakeRange(0, 4)]);
        
        NSString *day = [user.dob substringWithRange:NSMakeRange(8, 2)];
        NSString *month = [user.dob substringWithRange:NSMakeRange(5, 2)];
        NSString *year = [user.dob substringWithRange:NSMakeRange(0, 4)];
        
        NSString *dob = [NSString stringWithFormat: @"%@/%@/%@", day, month, year];
        
        self.txtDob.text = dob;
        
        if ([user.gender isEqualToString:@"M"]) {
            self.segmentGender.selectedSegmentIndex = 0;
        } else {
            self.segmentGender.selectedSegmentIndex = 1;
        }
        
        if ([user.race isEqualToString:@"branco"]) {
            self.segmentRace.selectedSegmentIndex = 0;
        } else if ([user.race isEqualToString:@"preto"]) {
            self.segmentRace.selectedSegmentIndex = 1;
        } else if ([user.race isEqualToString:@"pardo"]) {
            self.segmentRace.selectedSegmentIndex = 2;
        } else if ([user.race isEqualToString:@"amarelo"]) {
            self.segmentRace.selectedSegmentIndex = 3;
        } else if ([user.race isEqualToString:@"indigena"]) {
            self.segmentRace.selectedSegmentIndex = 4;
        }
    } else {
        self.txtEmail.hidden = YES;
        self.txtPassword.hidden = YES;
        self.txtConfirmPassword.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.navigationItem.title = @"Guardiões da Saúde";
    user = [User getInstance];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtNick endEditing:YES];
    [self.txtEmail endEditing:YES];
    [self.txtDob endEditing:YES];
    [self.txtPassword endEditing:YES];
    [self.txtConfirmPassword endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.txtNick resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtDob resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    return TRUE;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAction:(id)sender {
    
    BOOL fieldNull = NO;
    
    if ([self.txtNick.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtDob.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtEmail.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtPassword.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtConfirmPassword.text isEqualToString:@""]) {
        fieldNull = YES;
    }

    if (fieldNull) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Preencha todos os campos do formulário." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        if (![self.txtPassword.text isEqualToString:@""]) {
            if (self.txtPassword.text.length < 6) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"A senha precisa ter pelo menos 6 carcteres." preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSLog(@"You pressed button OK");
                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Senha inválida" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSLog(@"You pressed button OK");
                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                [params setValue:self.txtPassword.text forKey:@"password"];
            }
        } else {
    
            NSString *gender;
            NSString *race;
    
            NSLog(@"Dia %@", [self.txtDob.text substringWithRange:NSMakeRange(0, 2)]);
            NSLog(@"Mês %@", [self.txtDob.text substringWithRange:NSMakeRange(3, 2)]);
            NSLog(@"Ano %@", [self.txtDob.text substringWithRange:NSMakeRange(6, 4)]);
    
            NSString *day = [self.txtDob.text substringWithRange:NSMakeRange(0, 2)];
            NSString *month = [self.txtDob.text substringWithRange:NSMakeRange(3, 2)];
            NSString *year = [self.txtDob.text substringWithRange:NSMakeRange(6, 4)];
    
            NSString *dob = [NSString stringWithFormat: @"%@-%@-%@", year, month, day];
    
            if (self.segmentGender.selectedSegmentIndex == 0) {
                gender = @"M";
            } else if (self.segmentGender.selectedSegmentIndex == 1) {
                gender = @"F";
            }
    
            if (self.segmentRace.selectedSegmentIndex == 0) {
                race = @"branco";
            } else if (self.segmentRace.selectedSegmentIndex == 1) {
                race = @"preto";
            } else if (self.segmentRace.selectedSegmentIndex == 2) {
                race = @"pardo";
            } else if (self.segmentRace.selectedSegmentIndex == 3) {
                race = @"amarelo";
            } else if (self.segmentRace.selectedSegmentIndex == 4) {
                race = @"indigena";
            }

            NSString *url;
    
            if (self.newMember == 0) {
        
                params = @{@"nick":self.txtNick.text,
                   @"email": self.txtEmail.text.lowercaseString,
                   @"password": self.txtPassword.text,
                   @"client": user.client,
                   @"dob": dob,
                   @"gender": gender,
                   @"app_token": user.app_token,
                   @"race": race,
                   @"platform": user.platform,
                   @"picture": @"0",
                   @"user": user.idUser};
        
                url = @"http://52.20.162.21/household/create";
        
            } else {
                if (self.idHousehold != nil) {
            
                    params = @{@"nick":self.txtNick.text,
                       @"email": self.txtEmail.text.lowercaseString,
                       @"password": self.txtPassword.text,
                       @"client": user.client,
                       @"dob": dob,
                       @"gender": gender,
                       @"app_token": user.app_token,
                       @"race": race,
                       @"platform": user.platform,
                       @"picture": @"0",
                       @"id": self.idHousehold};
            
                    url = @"http://52.20.162.21/household/update";
        
                } else if (self.idHousehold == nil && self.idUser != nil) {
            
                    params = @{@"nick":self.txtNick.text,
                       @"email": self.txtEmail.text.lowercaseString,
                       @"client": user.client,
                       @"dob": dob,
                       @"gender": gender,
                       @"app_token": user.app_token,
                       @"race": race,
                       @"platform": user.platform,
                       @"picture": @"0",
                       @"user": user.idUser};

                    url = @"http://52.20.162.21/user/update";
                }
            }
        
            AFHTTPRequestOperationManager *manager;
            manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
            [manager POST:url
                parameters:params
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                        if ([responseObject[@"error"] boolValue] == 1) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar a operação. Verifique se todos os campos estão preenchidos corretamente." preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                  NSLog(@"You pressed button OK");
                            }];
                            [alert addAction:defaultAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        } else {
                      
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Operação realizada com sucesso." preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                NSLog(@"You pressed button OK");
                                
                            }];
                            [alert addAction:defaultAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar o cadastro. Verifique se todos os campos estão preenchidos corretamente ou se o e-mail utilizado já está em uso." preferredStyle:UIAlertControllerStyleActionSheet];
                        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            NSLog(@"You pressed button OK");
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert addAction:defaultAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }];
            }
        }
}
- (IBAction)btnSelectPicture:(id)sender {
    
    SelectAvatarViewController *selectAvatarViewController = [[SelectAvatarViewController alloc] init];
    [self.navigationController pushViewController:selectAvatarViewController animated:YES];
}
@end
