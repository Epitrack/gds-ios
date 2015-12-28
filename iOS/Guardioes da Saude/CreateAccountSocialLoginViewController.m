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
    NSDate *birthdate;
    
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
    
    birthdate = [DateUtil dateFromString:@"10/10/1990"];
    [self updateBirthDate];
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
    
    if ([self.txtEmail.text isEqualToString:@""] ||
        [self.txtNick.text isEqualToString:@""] ||
        [self.downGenre.text isEqualToString:@""] ||
        [self.downGenre.text isEqualToString:@""]) {
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
        NSString *gender = self.downGenre.text;
        NSString *race = self.downRace.text;
        
        if ([gender isEqualToString:@"Masculino"]) {
            gender = @"M";
        } else if ([gender isEqualToString:@"Feminino"]) {
            gender = @"F";
        }
        
        AFHTTPRequestOperationManager *manager;
        NSDictionary *params;
        
        NSString *dob = [DateUtil stringUSFromDate:birthdate];
        
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
- (IBAction)changeBirthDate:(id)sender {
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        birthdate = controller.contentView.date;
        [self updateBirthDate];
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"Data de nascimento";
    dateSelectionController.message = @"Selecione sua data de nascimento.";
    
    [dateSelectionController addAction:selectAction];

    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = birthdate;
    
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
    }
    
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void) updateBirthDate{
    NSString *dateFormatted  = [DateUtil stringFromDate:birthdate];
    [self.btnDate setTitle:dateFormatted forState:UIControlStateNormal];
}
@end
