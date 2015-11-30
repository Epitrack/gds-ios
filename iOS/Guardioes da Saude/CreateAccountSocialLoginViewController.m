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

@interface CreateAccountSocialLoginViewController () {
    
    User *user;
}

@end

@implementation CreateAccountSocialLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = [User getInstance];
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


- (IBAction)btnCadastrar:(id)sender {
    
    BOOL fieldNull = NO;
    
    if ([self.txtNick.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtDob.text isEqualToString:@""]) {
        fieldNull = YES;
    } else if ([self.txtEmail.text isEqualToString:@""]) {
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
        NSString *gender;
        NSString *race;
        
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
        
        NSLog(@"Data %@", self.txtDob.text);
        
        AFHTTPRequestOperationManager *manager;
        NSDictionary *params;
        
        NSLog(@"Dia %@", [self.txtDob.text substringWithRange:NSMakeRange(0, 2)]);
        NSLog(@"Mês %@", [self.txtDob.text substringWithRange:NSMakeRange(3, 2)]);
        NSLog(@"Ano %@", [self.txtDob.text substringWithRange:NSMakeRange(6, 4)]);
        
        NSString *day = [self.txtDob.text substringWithRange:NSMakeRange(0, 2)];
        NSString *month = [self.txtDob.text substringWithRange:NSMakeRange(3, 2)];
        NSString *year = [self.txtDob.text substringWithRange:NSMakeRange(6, 4)];
        
        NSString *dob = [NSString stringWithFormat: @"%@-%@-%@", year, month, day];
        
        NSLog(@"nick %@", self.txtNick.text);
        NSLog(@"email %@", self.txtEmail.text.lowercaseString);
        NSLog(@"client %@", user.client);
        NSLog(@"dob %@", dob);
        NSLog(@"gender %@", gender);
        NSLog(@"app_token %@", user.app_token);
        NSLog(@"race %@", race);
        NSLog(@"paltform %@", user.platform);
        
        params = @{@"nick":self.txtNick.text,
                   @"email": self.txtEmail.text.lowercaseString,
                   @"password": self.txtEmail.text.lowercaseString,
                   @"gl": user.gl,
                   @"tw": user.tw,
                   @"fb": user.fb,
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
@end
