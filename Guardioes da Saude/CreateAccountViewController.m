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
#import <Google/Analytics.h>

@interface CreateAccountViewController () {
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
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
    [self.pickerGender.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.pickerGender.DownPicker setPlaceholder:@"Selecione seu sexo"];
    [self.pickerGender.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.pickerGender.DownPicker setToolbarDoneButtonText:@"Selecionar"];
    
    (void)[self.pickerRace initWithData: [Constants getRaces]];
    [self.pickerRace.DownPicker setPlaceholder:@"Seleciona sua Cor/Raça"];
    [self.pickerRace.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.pickerRace.DownPicker setToolbarDoneButtonText:@"Selecionar"];
    
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
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
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Create Account Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
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
    
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_create_account"
                                                           label:@"Create Account"
                                                           value:nil] build]];
    
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
            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A senha precisa ter pelo menos 6 caracteres."];
            [self presentViewController:alert animated:YES completion:nil];
        } else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Suas senhas não estão iguais!"];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            User *userCreated = [[User alloc] init];
            userCreated.nick = self.txtNick.text;
            userCreated.email = [self.txtEmail.text lowercaseString];
            [userCreated setGenderByString:self.pickerGender.text];
            userCreated.race = [self.pickerRace.text lowercaseString];
            userCreated.dob = [DateUtil stringUSFromDate:dob];
            userCreated.password = self.txtPassword.text;
            userCreated.lon = [NSString stringWithFormat:@"%g", longitude];
            userCreated.lat = [NSString stringWithFormat:@"%g", latitude];
            userCreated.app_token = user.app_token;
            userCreated.platform = user.platform;
            userCreated.client = user.client;
            
            if (!userCreated.isValidEmail) {
                UIAlertController *alert = [ViewUtil showAlertWithMessage:@"E-mail inválido!"];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            [userRequester createAccountWithUser:userCreated andOnStart:^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }andOnSuccess:^(User *userResponse){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [user cloneUser:userResponse];
                
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                [preferences setValue:user.app_token forKey:kAppTokenKey];
                [preferences setValue:user.user_token forKey:kUserTokenKey];
                [preferences setValue:user.nick forKey:kNickKey];
                [preferences setValue:user.avatarNumber forKey:kAvatarNumberKey];
                
                [preferences synchronize];
                
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
    [self.pickerGender endEditing:YES];
    [self.pickerRace endEditing:YES];
    
    
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não estamos conseguindo obter sua localização. Verifique se os serviços estão habilitados no aparelho." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
    
    [locationManager stopUpdatingLocation];
    
}
@end
