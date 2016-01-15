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
#import "Constants.h"
#import "ViewUtil.h"
#import "UserRequester.h"
#import "MBProgressHUD.h"

@interface CreateAccountSocialLoginViewController () {
    User *user;
    NSDate *dob;
    UserRequester *userRequester;
}
@end

@implementation CreateAccountSocialLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = [User getInstance];
    userRequester = [[UserRequester alloc] init];
    
    [self.txtEmail setDelegate:self];
    [self.txtNick setDelegate:self];
    
    self.txtNick.text = user.nick;
    if(user.email){
        self.txtEmail.text = user.email;
    }
    
    UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Complete o cadastro a seguir para acessar o Guardiões da Saúde."];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    // Setup down pickers
    (void)[self.pickerGender initWithData:[Constants getGenders]];
    [self.pickerGender setPlaceholder:@"Selecione seu sexo"];
    (void)[self.pickerRace initWithData: [Constants getRaces]];
    [self.pickerRace setPlaceholder:@"Selecione sua Cor/Raça"];
    
    // Setup Dob
    dob = [DateUtil dateFromString:@"10/10/1990"];
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
    
    if ([self.txtNick.text isEqualToString:@""]||
        [self.txtEmail.text isEqualToString:@""]) {
        fieldNull = YES;
    }
    
    NSInteger diffDay = [DateUtil diffInDaysDate:dob andDate:[NSDate date]];
    
    if (fieldNull) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Preencha todos os campos do formulário."];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if((diffDay/365) < 13){
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A idade mínima para o usuário principal é 13 anos."];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [user setGenderByString:self.pickerGender.text];
        user.race = [self.pickerRace.text lowercaseString];
        user.nick = self.txtNick.text;
        user.email = [self.txtEmail.text lowercaseString];
        user.dob = [DateUtil stringUSFromDate:dob];
        
        [userRequester createAccountWithUser:user andOnStart:^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }andOnSuccess:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            HomeViewController *homeViewController = [[HomeViewController alloc] init];
            [self.navigationController pushViewController:homeViewController animated:YES];
        }andOnError:^(NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertController *alert;
            if (error) {
                alert = [ViewUtil showAlertWithMessage:@"Ocorreu um erro de comunicação. Por favor, verifique sua conexão com a internet!"];
            }else{
                alert = [ViewUtil showAlertWithMessage:@"Não foi possível realizar o cadastro. Verifique se todos os campos estão preenchidos corretamente ou se o e-mail utilizado já está em uso."];
            }
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
    [self.btnDate setTitle:dateFormatted forState:UIControlStateNormal];
}
@end
