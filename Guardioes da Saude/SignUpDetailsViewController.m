//
//  SignUpDetailsViewController.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/17/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "SignUpDetailsViewController.h"
#import "Constants.h"
#import "DateUtil.h"
#import "ViewUtil.h"
#import "UserRequester.h"
#import "MBprogressHUD.h"
#import "HomeViewController.h"
#import <Google/Analytics.h>

@interface SignUpDetailsViewController (){
    NSDate *dob;
    BOOL dobSetted;
    
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
    
    UserRequester *userRequester;
}

@end

@implementation SignUpDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnDob.layer.cornerRadius = 4;
    
    userRequester = [[UserRequester alloc] init];
    
    // Setup down pickers
    (void)[self.txtGender initWithData:[Constants getGenders]];
    [self.txtGender.DownPicker setPlaceholder:NSLocalizedString(@"sign_up_details.tx_gender", @"")];
    [self.txtGender.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"sign_up_details.cancel", @"")];
    [self.txtGender.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"sign_up_details.select", @"")];
    
    (void)[self.txtRace initWithData: [Constants getRaces]];
    [self.txtRace.DownPicker setPlaceholder:NSLocalizedString(@"sign_up_details.tx_race", @"")];
    [self.txtRace.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"sign_up_details.cancel", @"")];
    [self.txtRace.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"sign_up_details.select", @"")];
    
    dob = [DateUtil dateFromString:@"10/10/1990"];
    [self updateBirthDate];
    
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

- (void)viewWillAppear:(BOOL)animated {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Signup Details Account Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    if (self.user.email) {
        self.consTopNick.constant = 8.0f;
        self.lbEmail.hidden = YES;
        self.txtEmail.hidden = YES;
    }
    
    if (self.user.nick) {
        [self.txtNick setText:self.user.nick];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDobAction:(id)sender {
    [self.txtGender endEditing:YES];
    [self.txtRace endEditing:YES];
    
    
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        dob = controller.contentView.date;
        [self updateBirthDate];
        
        [self.btnDob setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dobSetted = YES;
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
    [self.btnDob setTitle:dateFormatted forState:UIControlStateNormal];
}

- (bool)isValid{
    
    if (!self.user.email && [self.txtEmail.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"E-mail é um campo obrigatório"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtNick.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Apelido é um campo obrigatório"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (!dobSetted) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Data de nascimento é um campo obrigatório"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    NSInteger yearsOld = [DateUtil diffInDaysDate:dob andDate: [NSDate date]]/365;
    if (yearsOld < 13) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A idade mínima para o usuário principal é 13 anos."];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (yearsOld > 120) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A idade máxima para o usuário principal é 120 anos."];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtGender.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Sexo é um campo obrigatório"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtRace.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Cor/Raça é um campo obrigatório"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

- (void)populateUser{
    User *singleUser = [User getInstance];
    
    self.user.nick = self.txtNick.text;
    [self.user setGenderByString:self.txtGender.text];
    self.user.race = [self.txtRace.text lowercaseString];
    self.user.dob = [DateUtil stringUSFromDate:dob];
    self.user.lon = [NSString stringWithFormat:@"%g", longitude];
    self.user.lat = [NSString stringWithFormat:@"%g", latitude];
    self.user.app_token = singleUser.app_token;
    self.user.platform = singleUser.platform;
    self.user.client = singleUser.client;
    
    if (!self.user.email) {
        self.user.email = self.txtEmail.text;
    }
}

- (IBAction)btnSignupAction:(id)sender {
    if ([self isValid]) {
        [self populateUser];
        [userRequester createAccountWithUser:self.user andOnStart:^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }andOnSuccess:^(User *userResponse){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            User *singleUser = [User getInstance];
            [singleUser cloneUser:userResponse];
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            [preferences setValue:singleUser.app_token forKey:kAppTokenKey];
            [preferences setValue:singleUser.user_token forKey:kUserTokenKey];
            [preferences setValue:singleUser.nick forKey:kNickKey];
            [preferences setValue:singleUser.avatarNumber forKey:kAvatarNumberKey];
            
            [preferences synchronize];
            
            HomeViewController *homeViewController = [[HomeViewController alloc] init];
            [self.navigationController pushViewController:homeViewController animated:YES];
        }andOnError:^(NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *msgError;
            if (error && error.code == -1009) {
                msgError = kMsgConnectionError;
            }else{
                msgError = @"O e-mail usado já está em uso";
            }
            
            [self presentViewController:[ViewUtil showAlertWithMessage:msgError] animated:YES completion:nil];
        }];
    }
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
