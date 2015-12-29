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
#import "UserRequester.h"

@interface ProfileFormViewController () {
    NSDictionary *params;
    DTO *dto;
    SingleHousehold *singleHousehold;
}

@end

@implementation ProfileFormViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.operation == EDIT_USER) {
        [self loadEditUser];
    } else if (self.operation == EDIT_HOUSEHOLD){
        [self loadEditHousehold];
    } else if (self.operation == ADD_HOUSEHOLD){
        [self loadAddHousehold];
    }
}

- (void) loadEditUser{
    self.navigationItem.title = @"Editar Perfil";
    self.txtEmail.enabled = NO;
    [self populateFormWithNick:self.user.nick
                        andDob:self.user.dob
                      andEmail:self.user.email
                     andGender:self.user.gender
                       andRace:self.user.race
                    andPicture:self.user.picture];
}

- (void) loadEditHousehold{
    self.navigationItem.title = @"Editar Perfil";
    self.txtPassword.hidden = YES;
    self.txtConfirmPassword.hidden = YES;
    [self populateFormWithNick:self.household.nick
                        andDob:self.household.dob
                      andEmail:@""
                     andGender:self.household.gender
                       andRace:self.household.race
                    andPicture:self.household.picture];
}

- (void) loadAddHousehold{
    self.navigationItem.title = @"Adicionar Membro";
    self.txtPassword.hidden = YES;
    self.txtConfirmPassword.hidden = YES;
}

- (void) populateFormWithNick: (NSString *) nick
                       andDob: (NSString *) dob
                     andEmail: (NSString *) email
                    andGender: (NSString *) gender
                      andRace: (NSString *) race
                   andPicture: (NSString *) picture{
    self.txtNick.text = nick;
    self.txtDob.text = [self formatterDate:dob];
    self.txtEmail.text = email;
    
    if ([gender isEqualToString:@"0"]) {
        self.segmentGender.selectedSegmentIndex = 0;
    } else {
        self.segmentGender.selectedSegmentIndex = 1;
    }
    
    if ([race isEqualToString:@"branco"]) {
        self.segmentRace.selectedSegmentIndex = 0;
    } else if ([race isEqualToString:@"preto"]) {
        self.segmentRace.selectedSegmentIndex = 1;
    } else if ([race isEqualToString:@"pardo"]) {
        self.segmentRace.selectedSegmentIndex = 2;
    } else if ([race isEqualToString:@"amarelo"]) {
        self.segmentRace.selectedSegmentIndex = 3;
    } else if ([race isEqualToString:@"indigena"]) {
        self.segmentRace.selectedSegmentIndex = 4;
    }
    
    NSString *avatar = @"img_profile01.png";
    if ([picture isEqualToString:@"0"]) {
        avatar = @"img_profile01.png";
    } else if (picture.length == 1) {
        avatar = [NSString stringWithFormat:@"img_profile0%@.png", picture];
    } else if (picture.length == 2) {
        avatar = [NSString stringWithFormat:@"img_profile%@.png", picture];
    }
    
    [self.btnPicture setBackgroundImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
}

- (NSString *) formatterDate: (NSString *) date{
    NSString *day = [date substringWithRange:NSMakeRange(8, 2)];
    NSString *month = [date substringWithRange:NSMakeRange(5, 2)];
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    
    return [NSString stringWithFormat:@"%@/%@/%@", day, month, year];
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

- (BOOL) validateForm{
    BOOL fieldsValid = YES;
    if ([self.txtNick.text isEqualToString:@""]) {
        fieldsValid = NO;
    } else if ([self.txtDob.text isEqualToString:@""]) {
        fieldsValid = NO;
    } else if ([self.txtEmail.text isEqualToString:@""]) {
        fieldsValid = NO;
    }
    
    return fieldsValid;
}

- (BOOL) validateDate{
    BOOL dateValid = YES;
    if (![self.txtDob.text isEqualToString:@""]) {
        if (self.txtDob.text.length == 10) {
            NSString *bar1 = [self.txtDob.text substringWithRange:NSMakeRange(2, 1)];
            NSString *bar2 = [self.txtDob.text substringWithRange:NSMakeRange(5, 1)];
            NSString *day = [self.txtDob.text substringWithRange:NSMakeRange(0, 2)];
            NSString *month = [self.txtDob.text substringWithRange:NSMakeRange(3, 2)];
            NSString *year = [self.txtDob.text substringWithRange:NSMakeRange(6, 4)];
            
            if (![bar1 isEqualToString:@"/"] || ![bar2 isEqualToString:@"/"]) {
                dateValid = NO;
            }
            
            @try {
                int validateDay = [day intValue];
                
                if (validateDay <= 0) {
                    dateValid = NO;
                }
                
                if (validateDay > 31) {
                    dateValid = NO;
                }
                
                int validateMonth = [month intValue];
                
                if (validateMonth <= 0) {
                    dateValid = NO;
                }
                
                if (validateMonth > 12) {
                    dateValid = NO;
                }
                
                int validateYear = [year intValue];
                
                if (validateYear <= 0) {
                    dateValid = NO;
                }
            }
            @catch (NSException *exception) {
                dateValid = NO;
            }
        } else {
            dateValid = NO;
        }
    }
    
    return dateValid;
}

- (IBAction)btnAction:(id)sender {
    
    if (![self validateDate]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                       message:@"Data de nascimento inválida."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                    NSLog(@"You pressed button OK");
                }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (![self validateForm]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                       message:@"Preencha todos os campos do formulário."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                    NSLog(@"You pressed button OK");
                }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
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
    
            NSString *gender = [self getGender];
            NSString *race = [self getRace];
    
            NSLog(@"Dia %@", [self.txtDob.text substringWithRange:NSMakeRange(0, 2)]);
            NSLog(@"Mês %@", [self.txtDob.text substringWithRange:NSMakeRange(3, 2)]);
            NSLog(@"Ano %@", [self.txtDob.text substringWithRange:NSMakeRange(6, 4)]);
    
            NSString *day = [self.txtDob.text substringWithRange:NSMakeRange(0, 2)];
            NSString *month = [self.txtDob.text substringWithRange:NSMakeRange(3, 2)];
            NSString *year = [self.txtDob.text substringWithRange:NSMakeRange(6, 4)];
    
            NSString *dob = [NSString stringWithFormat: @"%@-%@-%@", year, month, day];

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
                                
                                // O ideal é atualizar o singleton na camada de serviço
//                                if(singleHousehold.id != nil){
//                                    user.nick = self.txtNick.text;
//                                    //user.dob = self.txtDob.text;
//                                    user.gender = [self getGender];
//                                    user.race = [self getRace];
//                                    user.picture = [self getPicture];
//                                }else{
//                                    singleHousehold.nick = self.txtNick.text;
//                                    //user.dob = self.txtDob.text;
//                                    singleHousehold.gender = [self getGender];
//                                    singleHousehold.race = [self getRace];
//                                    singleHousehold.picture = [self getPicture];
//                                }
                                
                                
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

- (void) updateUser{
    User *userUpdater = [[User alloc] init];
    userUpdater.client = self.user.client;
    userUpdater.app_token = self.user.app_token;
    userUpdater.user_token = self.user.user_token;
    userUpdater.nick = self.txtNick.text;
    userUpdater.email = self.user.email;
//    userUpdater.dob =
    userUpdater.gender = [self getGender];
    userUpdater.race = [self getRace];
}

- (void) createHousehold{
    
}

- (void) updateHousehold{
    
}

- (IBAction)btnSelectPicture:(id)sender {
    
    SelectAvatarViewController *selectAvatarViewController = [[SelectAvatarViewController alloc] init];
    [self.navigationController pushViewController:selectAvatarViewController animated:YES];
}

- (NSString *) getRace{
    NSString *race;
    
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
    
    return race;
}

- (NSString *) getGender{
    NSString *gender;
    if (self.segmentGender.selectedSegmentIndex == 0) {
        gender = @"M";
    } else if (self.segmentGender.selectedSegmentIndex == 1) {
        gender = @"F";
    }
    
    return gender;
}

- (NSString *) getPicture{
    NSString *picture = @"";
//    if (![dto.string isEqualToString:@""] && dto.string != nil) {
//        picture = dto.string;
//    } else if (![user.picture isEqualToString:@""] && user.picture != nil) {
//        picture = user.picture;
//    } else {
//        picture = @"1";
    //}
    
    return picture;
}
@end
