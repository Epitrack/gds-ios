//
//  CreateAccountSocialLoginViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 20/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "CreateAccountSocialLoginViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "HomeViewController.h"
#import "SelectTypeCreateAccoutViewController.h"

@interface CreateAccountSocialLoginViewController () {
    
    User *user;
    NSArray *pickerDataGender;
    NSArray *pickerDataRace;
    
}
@end

@implementation CreateAccountSocialLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = [User getInstance];
    
    [self.txtEmail setDelegate:self];
    [self.txtNick setDelegate:self];
    
    pickerDataGender = @[@"Masculino", @"Feminino"];
    pickerDataRace = @[@"branco", @"preto", @"pardo", @"amarelo", @"indigena"];
    
    (void)[self.downGenre initWithData:pickerDataGender];
    (void)[self.downRace initWithData:pickerDataRace];
    
    NSString *placeHolderDownpicker = @"Toque para selecionar";
    [self.downRace setPlaceholder:placeHolderDownpicker];
    [self.downGenre setPlaceholder:placeHolderDownpicker];
    
    self.txtNick.text = user.nick;
    if(user.email){
        self.txtEmail.text = user.email;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Complete o cadastro a seguir para acessar o Guardiões da Saúde." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtEmail endEditing:YES];
    [self.txtNick endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtNick resignFirstResponder];
    return YES;
}

- (IBAction)btnCadastrar:(id)sender {
    BOOL fieldNull = NO;
    BOOL dateFail = NO;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *formattedDate = nil;//[df stringFromDate:self.dtPikerDob.date];
    
    NSString *datePiker = formattedDate;
    
    if ([self.txtNick.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([datePiker isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtEmail.text isEqualToString:@""]) {
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
    }else if (fieldNull) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Preencha todos os campos do formulário." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSString *gender;
        NSString *race;
        NSInteger row;
        
//        row = [self.pickerGender selectedRowInComponent:0];
//        gender = [pickerDataGender objectAtIndex:row];
        
        if ([gender isEqualToString:@"Masculino"]) {
            gender = @"M";
        } else if ([gender isEqualToString:@"Feminino"]) {
            gender = @"F";
        }
        
//        row = [self.pickerRace selectedRowInComponent:0];
//        race = [pickerDataRace objectAtIndex:row];
        
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
        NSLog(@"client %@", user.client);
        NSLog(@"dob %@", dob);
        NSLog(@"gender %@", gender);
        NSLog(@"app_token %@", user.app_token);
        NSLog(@"race %@", race);
        NSLog(@"paltform %@", user.platform);
        
        NSString *gl = @"";
        NSString *tw = @"";
        NSString *fb = @"";
        
        if (user.gl != nil) {
            gl = user.gl;
        }
        
        if (user.fb != nil) {
            fb = user.fb;
        }
        
        if (user.tw != nil) {
            tw = user.tw;
        }
        
        params = @{@"nick":self.txtNick.text,
                   @"email": self.txtEmail.text.lowercaseString,
                   @"password": self.txtEmail.text.lowercaseString,
                   @"gl": gl,
                   @"tw": tw,
                   @"fb": fb,
                   @"client": user.client,
                   @"dob": dob,
                   @"gender": gender,
                   @"app_token": user.app_token,
                   @"race": race,
                   @"platform": user.platform,
                   @"picture": @"1",
                   @"lat": @"-8.0464492",
                   @"lon": @"-34.9324883"};
        
        manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
        [manager POST:@"http://api.guardioesdasaude.org/user/create"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
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


- (IBAction)backButtonAction:(id)sender {
    SelectTypeCreateAccoutViewController *selectTypeCreateAccountViewController = [[SelectTypeCreateAccoutViewController alloc] init];
    [self.navigationController pushViewController:selectTypeCreateAccountViewController animated:YES];
}
@end
