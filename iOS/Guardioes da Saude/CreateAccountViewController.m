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
    NSDate *birthDate;
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
    
    birthDate = [DateUtil dateFromString:@"10/10/1990"];
    [self updateBirthDate];
    
    // Setup down pickers
    (void)[self.pickerGender initWithData:@[@"Masculino", @"Feminino"]];
    (void)[self.pickerRace initWithData: @[@"Branco", @"Preto", @"Pardo", @"Amarelo", @"Indigena"]];
    
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
    
    if ([self.txtNick.text isEqualToString:@""]||
        [self.txtEmail.text isEqualToString:@""] ||
        [self.txtPassword.text isEqualToString:@""]) {
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
            [user setGenderByString:self.pickerGender.text];
            NSString *race = [self.pickerRace.text lowercaseString];
            
            AFHTTPRequestOperationManager *manager;
            NSDictionary *params;
            
            NSString *dob = [DateUtil stringUSFromDate:birthDate];
            
            NSLog(@"nick %@", self.txtNick.text);
            NSLog(@"email %@", self.txtEmail.text.lowercaseString);
            NSLog(@"password %@", self.txtPassword.text);
            NSLog(@"client %@", user.client);
            NSLog(@"dob %@", dob);
            NSLog(@"gender %@", user.gender);
            NSLog(@"app_token %@", user.app_token);
            NSLog(@"race %@", user.race);
            NSLog(@"paltform %@", user.platform);

            params = @{@"nick":self.txtNick.text,
                       @"email": self.txtEmail.text.lowercaseString,
                       @"password": self.txtPassword.text,
                       @"client": user.client,
                       @"dob": dob,
                       @"gender": user.gender,
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
- (IBAction)btnBirthDateAction:(id)sender {
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        birthDate = controller.contentView.date;
        [self updateBirthDate];
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"Data de nascimento";
    dateSelectionController.message = @"Selecione sua data de nascimento.";
    
    [dateSelectionController addAction:selectAction];
    
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = birthDate;
    
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
    }
    
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void) updateBirthDate{
    NSString *dateFormatted  = [DateUtil stringFromDate:birthDate];
    [self.btnBirthDate setTitle:dateFormatted forState:UIControlStateNormal];
}
@end
