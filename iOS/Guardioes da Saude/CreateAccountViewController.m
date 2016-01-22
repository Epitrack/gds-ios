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
#import "Constants.h"
#import "ViewUtil.h"
#import "UserRequester.h"
#import "MBProgressHUD.h"

@interface CreateAccountViewController () {
    
    User *user;
    NSDate *dob;
    UserRequester *userRequester;
}

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";
    user = [User getInstance];
    userRequester = [[UserRequester alloc] init];
    
    [self.txtNick setDelegate:self];
    [self.txtEmail setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtDob setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtConfirmPassword setDelegate:self];
    
    dob = [DateUtil dateFromString:@"10/10/1990"];
    [self updateBirthDate];
    
    // Setup down pickers
    (void)[self.pickerGender initWithData:[Constants getGenders]];
    [self.pickerGender setPlaceholder:@"Selecione seu sexo"];
    (void)[self.pickerRace initWithData: [Constants getRaces]];
    [self.pickerRace setPlaceholder:@"Seleciona sua Cor/Raça"];
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
    
    NSInteger diffDay = [DateUtil diffInDaysDate:dob andDate: [NSDate date]];
    
    if ([self.txtNick.text isEqualToString:@""]||
        [self.txtEmail.text isEqualToString:@""] ||
        [self.txtPassword.text isEqualToString:@""]) {
        fieldNull = YES;
    }
    
    if (fieldNull) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Preencha todos os campos do formulário."];
        [self presentViewController:alert animated:YES completion:nil];
    } else if((diffDay/365) < 13){
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A idade mínima para o usuário principal é 13 anos."];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        if (self.txtPassword.text.length < 6) {
            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A senha precisa ter pelo menos 6 carcteres."];
            [self presentViewController:alert animated:YES completion:nil];
        } else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Suas senhas não estão iguais!"];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            user.nick = self.txtNick.text;
            user.email = [self.txtEmail.text lowercaseString];
            [user setGenderByString:self.pickerGender.text];
            user.race = [self.pickerRace.text lowercaseString];
            user.dob = [DateUtil stringUSFromDate:dob];
            user.password = self.txtPassword.text;
            
            [userRequester createAccountWithUser:user andOnStart:^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }andOnSuccess:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                [preferences setValue:user.app_token forKey:kAppTokenKey];
                [preferences setValue:user.user_token forKey:kUserTokenKey];
                [preferences setValue:user.nick forKey:kNickKey];
                [preferences setValue:user.picture forKey:kPictureKey];
                
                HomeViewController *homeViewController = [[HomeViewController alloc] init];
                [self.navigationController pushViewController:homeViewController animated:YES];
            }andOnError:^(NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *msgError;
                if (error && error.code == -1009) {
                    msgError = kMsgConnectionError;
                }else{
                    msgError = @"Não foi possível realizar o cadastro. Verifique se todos os campos estão preenchidos corretamente ou se o e-mail utilizado já está em uso.";
                }
                
                [self presentViewController:[ViewUtil showAlertWithMessage:msgError] animated:YES completion:nil];
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
        dob = controller.contentView.date;
        [self updateBirthDate];
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"Data de nascimento";
    dateSelectionController.message = @"Selecione sua data de nascimento.";
    
    [dateSelectionController addAction:selectAction];
    
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = dob;
    
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
    }
    
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void) updateBirthDate{
    NSString *dateFormatted  = [DateUtil stringFromDate:dob];
    [self.btnBirthDate setTitle:dateFormatted forState:UIControlStateNormal];
}
@end
