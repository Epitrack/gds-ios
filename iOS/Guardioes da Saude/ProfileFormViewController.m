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
#import "UserRequester.h"
#import "HouseholdRequester.h"
#import "DateUtil.h"

@interface ProfileFormViewController () {
    UserRequester *userRequester;
    HouseholdRequester *householdRequester;
    NSDate *birthdate;
    NSArray *listRace;
    NSArray *listGender;
}

@end

@implementation ProfileFormViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    userRequester = [[UserRequester alloc] init];
    householdRequester = [[HouseholdRequester alloc] init];
    
    listGender = @[@"Masculino", @"Feminino"];
    listRace = @[@"Branco", @"Preto", @"Pardo", @"Amarelo", @"Indigena"];
    
    // Setup down pickers
    (void)[self.pickerGender initWithData:listGender];
    (void)[self.pickerRace initWithData: listRace];
    
    if (self.operation == EDIT_USER) {
        [self loadEditUser];
    } else if (self.operation == EDIT_HOUSEHOLD){
        [self loadEditHousehold];
    } else if (self.operation == ADD_HOUSEHOLD){
        [self loadAddHousehold];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    if (self.pictureSelected) {
        [self updatePicture:self.pictureSelected];
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
                      andEmail:self.household.email
                     andGender:self.household.gender
                       andRace:self.household.race
                    andPicture:self.household.idPicture];
}

- (void) loadAddHousehold{
    self.navigationItem.title = @"Adicionar Membro";
    self.txtPassword.hidden = YES;
    self.txtConfirmPassword.hidden = YES;
    
    self.pictureSelected = @"1";

    birthdate = [DateUtil dateFromString:@"10/10/1990"];
    [self updateBirthDate];

}

- (void) populateFormWithNick: (NSString *) nick
                       andDob: (NSString *) dob
                     andEmail: (NSString *) email
                    andGender: (NSString *) gender
                      andRace: (NSString *) race
                   andPicture: (NSString *) picture{
    self.txtNick.text = nick;
    self.txtEmail.text = email;
    
    birthdate = [DateUtil dateFromStringUS:dob];
    [self updateBirthDate];
    
    if ([gender isEqualToString:@"M"]) {
        self.pickerGender.text = listGender[0];
    } else {
        self.pickerGender.text = listGender[1];
    }
    
    if ([race isEqualToString:@"branco"]) {
        self.pickerRace.text = listRace[0];
    } else if ([race isEqualToString:@"preto"]) {
        self.pickerRace.text = listRace[1];
    } else if ([race isEqualToString:@"pardo"]) {
        self.pickerRace.text = listRace[2];
    } else if ([race isEqualToString:@"amarelo"]) {
        self.pickerRace.text = listRace[3];
    } else if ([race isEqualToString:@"indigena"]) {
        self.pickerRace.text = listRace[4];
    }
    
    [self updatePicture:picture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtNick endEditing:YES];
    [self.txtEmail endEditing:YES];
    [self.txtPassword endEditing:YES];
    [self.txtConfirmPassword endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.txtNick resignFirstResponder];
    [self.txtEmail resignFirstResponder];
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
    } else if ([self.txtEmail.text isEqualToString:@""] && self.operation == EDIT_USER) {
        fieldsValid = NO;
    }
    
    return fieldsValid;
}

-(BOOL) validatePassword{
    BOOL isPasswordValid = YES;
    
    if (![self.txtPassword.text isEqualToString:@""]) {
        if (self.txtPassword.text.length < 6) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"A senha precisa ter pelo menos 6 carcteres." preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"You pressed button OK");
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            isPasswordValid = NO;
        } else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Senha inválida" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"You pressed button OK");
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            isPasswordValid = NO;
        }
    }
    
    return isPasswordValid;
}

- (IBAction)btnAction:(id)sender {
    
    if (![self validateForm]) {
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
        if (self.operation == EDIT_USER) {
            [self updateUser];
        } else if(self.operation == EDIT_HOUSEHOLD){
            [self updateHousehold];
        }else if(self.operation == ADD_HOUSEHOLD){
            [self createHousehold];
        }
        
    }
}

- (void) updateUser{
    User *userUpdater = [[User alloc] init];
    userUpdater.idUser = self.user.idUser;
    userUpdater.client = self.user.client;
    userUpdater.app_token = self.user.app_token;
    userUpdater.user_token = self.user.user_token;
    userUpdater.nick = self.txtNick.text;
    userUpdater.email = self.user.email;
    userUpdater.dob = [NSString stringWithFormat:@"%@", birthdate];
    [userUpdater setGenderByString:self.pickerGender.text];
    userUpdater.race = [self.pickerRace.text lowercaseString];
    userUpdater.picture = self.pictureSelected;
    
    NSInteger diffDay = [DateUtil diffInDaysDate:[NSDate date] andDate:birthdate];
    
    if (![self.txtPassword.text isEqualToString:@""]) {
        if (self.txtPassword.text.length < 6) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"A senha precisa ter pelo menos 6 carcteres." preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"You pressed button OK");
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        } else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Senha inválida" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"You pressed button OK");
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }else {
            userUpdater.password = self.txtPassword.text;
        }
    } else if((diffDay/365) < 13){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"A idade mínima para o usuário principal é 13 anos." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [userRequester updateUser:userUpdater onSuccess:^(User *user){
        [self showSuccessMsg];
    }onFail:^(NSError *error){
        [self showErrorMsg:error];
    }];
}

- (void) createHousehold{
    Household *updaterHousehold = [self populateHousehold];
    [householdRequester createHousehold:updaterHousehold onSuccess:^(void){
        [self showSuccessMsg];
    }onFail:^(NSError *error){
        [self showErrorMsg:error];
    }];
}

- (void) updateHousehold{
    Household *updaterHousehold = [self populateHousehold];
    [householdRequester updateHousehold:updaterHousehold onSuccess:^(void){
        [self showSuccessMsg];
    }onFail:^(NSError *error){
        [self showErrorMsg:error];
    }];
    
}

- (Household *) populateHousehold{
    Household *updaterHousehold = [[Household alloc]init];
    updaterHousehold.nick = self.txtNick.text;
    updaterHousehold.email = self.txtEmail.text;
    updaterHousehold.dob = [DateUtil stringUSFromDate:birthdate];
    [updaterHousehold setGenderByString:self.pickerGender.text];
    updaterHousehold.race = [self.pickerRace.text lowercaseString];
    updaterHousehold.picture = self.pictureSelected;
    
    if (self.operation == EDIT_HOUSEHOLD) {
        updaterHousehold.idHousehold = self.household.idHousehold;
    }
    
    return updaterHousehold;
}

- (void) showSuccessMsg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Operação realizada com sucesso." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showErrorMsg: (NSError *) error{
    NSLog(@"Error: %@", error);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível realizar o cadastro. Verifique se todos os campos estão preenchidos corretamente ou se o e-mail utilizado já está em uso." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnSelectPicture:(id)sender {
    SelectAvatarViewController *selectAvatarViewController = [[SelectAvatarViewController alloc] init];
    selectAvatarViewController.profileFormCtr = self;

    [self.navigationController pushViewController:selectAvatarViewController animated:YES];
}

- (void) updatePicture: (NSString *) picture{
    self.pictureSelected = picture;
    
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
- (IBAction)btnDobAction:(id)sender {
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
    [self.btnDob setTitle:dateFormatted forState:UIControlStateNormal];
}
@end
