//
//  CreateAccountViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 17/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "HomeViewController.h"
#import "TutorialViewController.h"

@interface CreateAccountViewController () {
    
    User *user;
    NSArray *pickerDataGender;
    NSArray *pickerDataRace;
}

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";
    user = [User getInstance];
    [self.txtNick setDelegate:self];
    [self.txtEmail setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtDob setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtConfirmPassword setDelegate:self];
    
    pickerDataGender = @[@"Masculino", @"Feminino"];
    pickerDataRace = @[@"branco", @"preto", @"pardo", @"amarelo", @"indigena"];
    
    self.pickerGender.dataSource = self;
    self.pickerGender.delegate = self;
    self.pickRace.dataSource = self;
    self.pickRace.delegate = self;
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

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtNick endEditing:YES];
    [self.txtEmail endEditing:YES];
    [self.txtPassword endEditing:YES];
    [self.txtDob endEditing:YES];
    [self.txtPassword endEditing:YES];
    [self.txtConfirmPassword endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.txtNick resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtDob resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    return TRUE;
}

- (IBAction)btnAddUser:(id)sender {
    
    BOOL fieldNull = NO;
    BOOL dateFail = NO;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *formattedDate = [df stringFromDate:self.dtPikerDob.date];
    
    NSString *datePiker = formattedDate;
    
    if ([self.txtNick.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([datePiker isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtEmail.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtPassword.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtConfirmPassword.text isEqualToString:@""]) {
        fieldNull = YES;
    }
    
    if (![datePiker isEqualToString:@""]) {
        if (datePiker.length == 10) {

            NSString *bar1 = [datePiker substringWithRange:NSMakeRange(2, 1)];
            NSString *bar2 = [datePiker substringWithRange:NSMakeRange(5, 1)];
            NSString *day = [datePiker substringWithRange:NSMakeRange(0, 2)];
            NSString *month = [datePiker substringWithRange:NSMakeRange(3, 2)];
            NSString *year = [datePiker substringWithRange:NSMakeRange(6, 4)];
        
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
    } else if (fieldNull) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Preencha todos os campos do formulário." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
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
            NSString *gender;
            NSString *race;
            NSInteger row;
            
            row = [self.pickerGender selectedRowInComponent:0];
            gender = [pickerDataGender objectAtIndex:row];
            
            if ([gender isEqualToString:@"Masculino"]) {
                gender = @"M";
            } else if ([gender isEqualToString:@"Feminino"]) {
                gender = @"F";
            }
            
            row = [self.pickRace selectedRowInComponent:0];
            race = [pickerDataRace objectAtIndex:row];
            
            /*if (self.segmentRace.selectedSegmentIndex == 0) {
                race = @"branco";
            } else if (self.segmentRace.selectedSegmentIndex == 1) {
                race = @"preto";
            } else if (self.segmentRace.selectedSegmentIndex == 2) {
                race = @"pardo";
            } else if (self.segmentRace.selectedSegmentIndex == 3) {
                race = @"amarelo";
            } else if (self.segmentRace.selectedSegmentIndex == 4) {
                race = @"indigena";
            }*/
            
            NSLog(@"Data %@", datePiker);
            
            //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            //[dateFormat setDateFormat:@"yyyy-MM-dd"];
            //NSDate *date = [dateFormat dateFromString:datePiker];
            //NSString *stringDate = [dateFormat stringFromDate:date];
            
            AFHTTPRequestOperationManager *manager;
            NSDictionary *params;

            NSLog(@"Dia %@", [datePiker substringWithRange:NSMakeRange(0, 2)]);
            NSLog(@"Mês %@", [datePiker substringWithRange:NSMakeRange(3, 2)]);
            NSLog(@"Ano %@", [datePiker substringWithRange:NSMakeRange(6, 4)]);
            
            NSString *day = [datePiker substringWithRange:NSMakeRange(0, 2)];
            NSString *month = [datePiker substringWithRange:NSMakeRange(3, 2)];
            NSString *year = [datePiker substringWithRange:NSMakeRange(6, 4)];
            
            NSString *dob = [NSString stringWithFormat: @"%@-%@-%@", year, month, day];
            
            NSLog(@"nick %@", self.txtNick.text);
            NSLog(@"email %@", self.txtEmail.text.lowercaseString);
            NSLog(@"password %@", self.txtPassword.text);
            NSLog(@"client %@", user.client);
            NSLog(@"dob %@", dob);
            NSLog(@"gender %@", gender);
            NSLog(@"app_token %@", user.app_token);
            NSLog(@"race %@", race);
            NSLog(@"paltform %@", user.platform);

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
                       @"lat": @"-8.0464492",
                       @"lon": @"-34.9324883"};
            
            manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
            [manager POST:@"http://api.guardioesdasaude.org/user/create"
               parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"responseObject: %@", responseObject);
                      if ([responseObject[@"error"] boolValue] == 1) {
                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar o cadastro. Verifique se todos os campos estão preenchidos corretamente ou se o e-mail utilizado já está em uso." preferredStyle:UIAlertControllerStyleActionSheet];
                          UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                              NSLog(@"You pressed button OK");
                          }];
                          [alert addAction:defaultAction];
                          [self presentViewController:alert animated:YES completion:nil];
                      } else {
                          
                          NSDictionary *userRequest = responseObject[@"user"];
                          
                          user.nick = userRequest[@"nick"];
                          user.email = userRequest[@"email"];
                          user.gender = userRequest[@"gender"];
                          
                          @try {
                              user.picture = userRequest[@"picture"];
                          }
                          @catch (NSException *exception) {
                              user.picture = @"0";
                          }
                          
                          user.idUser=  userRequest[@"id"];
                          user.race = userRequest[@"race"];
                          user.dob = userRequest[@"dob"];
                          user.user_token = userRequest[@"token"];
                          user.hashtag = userRequest[@"hashtags"];
                          user.household = userRequest[@"household"];
                          user.survey = userRequest[@"surveys"];
                       
                          HomeViewController *homeViewController = [[HomeViewController alloc] init];
                          [self.navigationController pushViewController:homeViewController animated:YES];
                      }
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar o cadastro. Verifique se todos os campos estão preenchidos corretamente ou se o e-mail utilizado já está em uso." preferredStyle:UIAlertControllerStyleActionSheet];
                      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                          NSLog(@"You pressed button OK");
                      }];
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                  }];
            }
    }
}
- (IBAction)backButtonAction:(id)sender {
    TutorialViewController *tutorialViewController = [[TutorialViewController alloc] init];
    [self.navigationController pushViewController:tutorialViewController animated:YES];
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int iReturn = 0;
    
    if (pickerView == self.pickRace) {
        iReturn = pickerDataRace.count;
    } else if (pickerView == self.pickerGender) {
        iReturn = pickerDataGender.count;
    }
    
    return iReturn;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *strReturn;
    
    if (pickerView == self.pickRace) {
        strReturn = pickerDataRace[row];
    } else if (pickerView == self.pickerGender) {
        strReturn = pickerDataGender[row];
    }
    
    return strReturn;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* tView = (UILabel*)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [tView setTextAlignment:UITextAlignmentCenter];

    }
    
    if (pickerView == self.pickRace) {
        tView.text = [pickerDataRace objectAtIndex:row];
    } else if (pickerView == self.pickerGender) {
        tView.text = [pickerDataGender objectAtIndex:row];
    }
    
    return tView;
}
@end
