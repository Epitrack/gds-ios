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
#import "DTO.h"
#import "SingleHousehold.h"

@interface ProfileFormViewController () {
    
    User *user;
    NSDictionary *params;
    DTO *dto;
    SingleHousehold *singleHousehold;
}

@end

@implementation ProfileFormViewController

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Here - viewDidAppear:(BOOL)animated");
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    user = [User getInstance];
    dto = [DTO getInstance];
    singleHousehold = [SingleHousehold getInstance];

    if (singleHousehold.id != nil) {
        self.navigationItem.title = @"Editar Perfil";
        [self loadData];
    } else {
        if (self.newMember == 0) {
            self.navigationItem.title = @"Adicionar Membro";
            self.txtPassword.hidden = YES;
            self.txtConfirmPassword.hidden = YES;
        } else {
            if (self.idUser != nil || self.idHousehold != nil) {
                self.navigationItem.title = @"Editar Perfil";
                self.txtEmail.enabled = NO;
                [self loadData];
            }
        }
    }
    
    /*if (dto.data != nil) {
        if (self.idUser != nil || singleHousehold.id != nil) {
            self.navigationItem.title = @"Editar Perfil";
            [self loadData];
        }
    } else {
        if (self.newMember == 0) {
            self.navigationItem.title = @"Adicionar Membro";
            self.txtPassword.hidden = YES;
            self.txtConfirmPassword.hidden = YES;
        } else {
            if (self.idUser != nil || self.idHousehold != nil) {
                self.navigationItem.title = @"Editar Perfil";
                self.txtEmail.enabled = NO;
                [self loadData];
            }
        }
    }*/
}

- (void) loadData {
    NSString *avatar;
    avatar = @"img_profile01.png";

    if (singleHousehold.id != nil) {

        self.txtPassword.hidden = YES;
        self.txtConfirmPassword.hidden = YES;

        self.txtNick.text = singleHousehold.nick;
        self.txtEmail.text = singleHousehold.email;

        NSLog(@"dob %@", singleHousehold.dob);

        NSLog(@"Dia %@", [singleHousehold.dob substringWithRange:NSMakeRange(8, 2)]);
        NSLog(@"Mês %@", [singleHousehold.dob substringWithRange:NSMakeRange(5, 2)]);
        NSLog(@"Ano %@", [singleHousehold.dob substringWithRange:NSMakeRange(0, 4)]);

        NSString *day = [singleHousehold.dob substringWithRange:NSMakeRange(8, 2)];
        NSString *month = [singleHousehold.dob substringWithRange:NSMakeRange(5, 2)];
        NSString *year = [singleHousehold.dob substringWithRange:NSMakeRange(0, 4)];

        NSString *dob = [NSString stringWithFormat:@"%@/%@/%@", day, month, year];

        self.txtDob.text = dob;

        if ([singleHousehold.gender isEqualToString:@"0"]) {
            self.segmentGender.selectedSegmentIndex = 0;
        } else {
            self.segmentGender.selectedSegmentIndex = 1;
        }

        if ([singleHousehold.race isEqualToString:@"0"]) {
            self.segmentRace.selectedSegmentIndex = 0;
        } else if ([singleHousehold.race isEqualToString:@"1"]) {
            self.segmentRace.selectedSegmentIndex = 1;
        } else if ([singleHousehold.race isEqualToString:@"2"]) {
            self.segmentRace.selectedSegmentIndex = 2;
        } else if ([singleHousehold.race isEqualToString:@"3"]) {
            self.segmentRace.selectedSegmentIndex = 3;
        } else if ([singleHousehold.race isEqualToString:@"4"]) {
            self.segmentRace.selectedSegmentIndex = 4;
        }
        
        if ([singleHousehold.picture isEqualToString:@"0"]) {
            avatar = @"img_profile01.png";
        } else if (singleHousehold.picture.length == 1) {
            avatar = [NSString stringWithFormat:@"img_profile0%@.png", singleHousehold.picture];
        } else if (singleHousehold.picture.length == 2) {
            avatar = [NSString stringWithFormat:@"img_profile%@.png", singleHousehold.picture];
        }
        
        [self.btnPicture setBackgroundImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];

    } else {


        if (self.idHousehold == nil) {
            if (dto.data != nil) {
                if ([dto.data isKindOfClass:[UIImage class]]) {
                    [self.btnPicture setBackgroundImage:dto.data forState:UIControlStateNormal];
                } else if ([dto.data isKindOfClass:[NSString class]]) {
                    NSString *p = [NSString stringWithFormat:@"%@", dto.data];

                    if (p.length == 1) {
                        avatar = [NSString stringWithFormat:@"img_profile0%@.png", p];
                    } else if (p.length == 2) {
                        avatar = [NSString stringWithFormat:@"img_profile%@.png", p];
                    }
                    [self.btnPicture setBackgroundImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
                }
            } else {
                /* if ((![user.picture isEqualToString:@""] && user.avatar != nil)) {
                     NSString *p = [NSString stringWithFormat:@"%@", user.avatar];

                     if (p.length == 1) {
                         avatar = [NSString stringWithFormat: @"img_profile0%@.png", p];
                     } else if (p.length == 2) {
                         avatar = [NSString stringWithFormat: @"img_profile%@.png", p];
                     }
                 } else {*/
                if (self.editProfile == 1) {
                    if ([user.picture isEqualToString:@"0"]) {
                        avatar = @"img_profile01.png";
                    } else if (user.picture.length == 1) {
                        avatar = [NSString stringWithFormat:@"img_profile0%@.png", user.picture];
                    } else if (user.picture.length == 2) {
                        avatar = [NSString stringWithFormat:@"img_profile%@.png", user.picture];
                    }
                } else {
                    avatar = @"img_profile01.png";
                }
            }
            if (![avatar isEqualToString:@""]) {
                [self.btnPicture setBackgroundImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
            }

            if (self.newMember != 0) {
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

                NSString *dob = [NSString stringWithFormat:@"%@/%@/%@", day, month, year];

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
            }
        } else {
            //self.txtEmail.hidden = YES;
            self.txtPassword.hidden = YES;
            self.txtConfirmPassword.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    BOOL dateFail = NO;
    
    if ([self.txtNick.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtDob.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtEmail.text isEqualToString:@""]) {
        fieldNull = YES;
    }

    if (singleHousehold.id == nil) {
        if (self.newMember != 0 && (user.idHousehold == nil || [user.idHousehold isEqualToString:@""])) {
            if (self.editProfile == 0) {
                if ([self.txtPassword.text isEqualToString:@""]) {
                    fieldNull = YES;
                } else if ([self.txtConfirmPassword.text isEqualToString:@""]) {
                    fieldNull = YES;
                }
            }
        }
    }
    
    if (![self.txtDob.text isEqualToString:@""]) {
        if (self.txtDob.text.length == 10) {
            NSString *bar1 = [self.txtDob.text substringWithRange:NSMakeRange(2, 1)];
            NSString *bar2 = [self.txtDob.text substringWithRange:NSMakeRange(5, 1)];
            NSString *day = [self.txtDob.text substringWithRange:NSMakeRange(0, 2)];
            NSString *month = [self.txtDob.text substringWithRange:NSMakeRange(3, 2)];
            NSString *year = [self.txtDob.text substringWithRange:NSMakeRange(6, 4)];
        
            if (![bar1 isEqualToString:@"/"] || ![bar2 isEqualToString:@"/"]) {
                dateFail = YES;
            }
        
            @try {
                int validateDay = [day intValue];
                
                if (validateDay <= 0) {
                    dateFail = YES;
                }
                
                if (validateDay > 31) {
                    dateFail = YES;
                }
                
                int validateMonth = [month intValue];
                
                if (validateMonth <= 0) {
                    dateFail = YES;
                }
                
                if (validateMonth > 12) {
                    dateFail = YES;
                }
                
                int validateYear = [year intValue];
                
                if (validateYear <= 0) {
                    dateFail = YES;
                }
            }
            @catch (NSException *exception) {
                dateFail = YES;
            }
        } else {
            dateFail = YES;
        }
    }
    
    if (dateFail) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Data de nascimento inválida." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (fieldNull) {
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
            NSString *picture;
            
            if (singleHousehold.id != nil) {
                if (![dto.string isEqualToString:@""] && dto.string != nil) {
                    picture = dto.string;
                } else {
                    picture = singleHousehold.picture;
                }
                
                params = @{@"nick":self.txtNick.text,
                           @"email": self.txtEmail.text.lowercaseString,
                           @"password": self.txtPassword.text,
                           @"client": user.client,
                           @"dob": dob,
                           @"gender": gender,
                           @"app_token": user.app_token,
                           @"race": race,
                           @"platform": user.platform,
                           @"picture": picture,
                           @"id": singleHousehold.id};
                
                url = @"http://api.guardioesdasaude.org/household/update";
            } else {
                if (self.newMember == 0) {
                    
                    if (![dto.string isEqualToString:@""] && dto.string != nil) {
                        picture = dto.string;
                    } else {
                        picture = @"1";
                    }
                    
                    params = @{@"nick":self.txtNick.text,
                               @"email": self.txtEmail.text.lowercaseString,
                               @"password": self.txtPassword.text,
                               @"client": user.client,
                               @"dob": dob,
                               @"gender": gender,
                               @"app_token": user.app_token,
                               @"race": race,
                               @"platform": user.platform,
                               @"picture": picture,
                               @"user": user.idUser};
                    
                    url = @"http://api.guardioesdasaude.org/household/create";
                    
                } else {
                    if (singleHousehold.id == nil && self.idUser != nil) {
                        
                        if (![dto.string isEqualToString:@""] && dto.string != nil) {
                            picture = dto.string;
                        } else if (![user.picture isEqualToString:@""] && user.picture != nil) {
                            picture = user.picture;
                        } else {
                            picture = @"1";
                        }
                        
                        params = @{@"nick":self.txtNick.text,
                                   @"email": self.txtEmail.text.lowercaseString,
                                   @"client": user.client,
                                   @"dob": dob,
                                   @"gender": gender,
                                   @"app_token": user.app_token,
                                   @"race": race,
                                   @"platform": user.platform,
                                   @"picture": picture,
                                   @"id": user.idUser};
                        
                        url = @"http://api.guardioesdasaude.org/user/update";
                    }

                }
            }

            /*if (self.newMember == 0) {

                if (![dto.string isEqualToString:@""]) {
                    picture = dto.string;
                } else {
                    picture = @"1";
                }

                params = @{@"nick":self.txtNick.text,
                   @"email": self.txtEmail.text.lowercaseString,
                   @"password": self.txtPassword.text,
                   @"client": user.client,
                   @"dob": dob,
                   @"gender": gender,
                   @"app_token": user.app_token,
                   @"race": race,
                   @"platform": user.platform,
                   @"picture": picture,
                   @"user": user.idUser};

                url = @"http://api.guardioesdasaude.org/household/create";
        
            } else {
                if (singleHousehold.id != nil) {

                    if (![dto.string isEqualToString:@""]) {
                        picture = dto.string;
                    } else {
                        picture = singleHousehold.picture;
                    }

                    params = @{@"nick":self.txtNick.text,
                       @"email": self.txtEmail.text.lowercaseString,
                       @"password": self.txtPassword.text,
                       @"client": user.client,
                       @"dob": dob,
                       @"gender": gender,
                       @"app_token": user.app_token,
                       @"race": race,
                       @"platform": user.platform,
                       @"picture": picture,
                       @"id": singleHousehold.id};
            
                    url = @"http://api.guardioesdasaude.org/household/update";
        
                } else if (singleHousehold.id == nil && self.idUser != nil) {

                    if (![dto.string isEqualToString:@""]) {
                        picture = dto.string;
                    } else {
                        picture = @"1";
                    }

                    params = @{@"nick":self.txtNick.text,
                       @"email": self.txtEmail.text.lowercaseString,
                       @"client": user.client,
                       @"dob": dob,
                       @"gender": gender,
                       @"app_token": user.app_token,
                       @"race": race,
                       @"platform": user.platform,
                       @"picture": picture,
                       @"id": user.idUser};

                    url = @"http://api.guardioesdasaude.org/user/update";
                }
            }*/
            
            dto.string = @"";
            dto.data = nil;
            
            AFHTTPRequestOperationManager *manager;
            manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
            [manager.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
            [manager POST:url
                parameters:params
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"Responde Object %@", responseObject);
                        if ([responseObject[@"error"] boolValue] == 1) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar a operação. Verifique se todos os campos estão preenchidos corretamente." preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                NSLog(@"You pressed button OK");
                                singleHousehold.id = nil;
                                singleHousehold = nil;
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                            [alert addAction:defaultAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        } else {
                      
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Operação realizada com sucesso." preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                NSLog(@"You pressed button OK");
                                singleHousehold.id = nil;
                                singleHousehold = nil;
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                            
                            [alert addAction:defaultAction];
                            //ProfileListViewController *profileListViewController = [[ProfileListViewController alloc] init];
                            //[self.navigationController pushViewController:profileListViewController animated:YES];
                            [self presentViewController:alert animated:YES completion:nil];

                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar o cadastro. Verifique se todos os campos estão preenchidos corretamente ou se o e-mail utilizado já está em uso." preferredStyle:UIAlertControllerStyleActionSheet];
                        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            NSLog(@"You pressed button OK");
                            singleHousehold.id = nil;
                            singleHousehold = nil;
                            [self.navigationController popViewControllerAnimated:YES];
                            //[self.navigationController popViewControllerAnimated:YES];
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
