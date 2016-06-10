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
#import "LocationUtil.h"
#import <Google/Analytics.h>

#define MAXLENGTH 10

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
    [self.txtGender.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.txtGender.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    [self.txtGender.DownPicker addTarget:self action:@selector(downPickerDidSelected:) forControlEvents:UIControlEventValueChanged];
    
    (void)[self.txtRace initWithData: [Constants getRaces]];
    [self.txtRace.DownPicker setPlaceholder:NSLocalizedString(@"sign_up_details.tx_race", @"")];
    [self.txtRace.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.txtRace.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    [self.txtRace.DownPicker addTarget:self action:@selector(downPickerDidSelected:) forControlEvents:UIControlEventValueChanged];
    
    (void)[self.txtCountry initWithData: [LocationUtil getCountriesWithBrazil:YES]];
    [self.txtCountry.DownPicker setPlaceholder:NSLocalizedString(@"sign_up_details.tx_country", @"")];
    [self.txtCountry.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.txtCountry.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    [self.txtCountry.DownPicker addTarget:self action:@selector(downPickerDidSelected:) forControlEvents:UIControlEventValueChanged];
    
    (void)[self.txtState initWithData: [LocationUtil getStates]];
    [self.txtState.DownPicker setPlaceholder:NSLocalizedString(@"sign_up_details.tx_state", @"")];
    [self.txtState.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.txtState.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    
    (void)[self.txtPerfil initWithData: [Constants getPerfis]];
    [self.txtPerfil.DownPicker setPlaceholder:NSLocalizedString(@"sign_up_details.tx_perfil", @"")];
    [self.txtPerfil.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.txtPerfil.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    
    dob = [DateUtil dateFromString:@"10/10/1990"];
    [self updateBirthDate];
    
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downPickerDidSelected:(id)dp {
    if ([dp isEqual:self.txtGender]) {
        [self.txtRace becomeFirstResponder];
    }else if([dp isEqual:self.txtRace]){
        [self.txtCountry becomeFirstResponder];
    }else{
        NSString *country = ((UITextField *) dp).text;
        if ([country isEqualToString:@"Brasil"] ||
            [country isEqualToString:@"Brazil"] ||
            [country isEqualToString:@"Brésil"] ||
            [country isEqualToString:@"Бразилия"] ||
            [country isEqualToString:@"巴西"] ||
            [country isEqualToString:@"البرازيل"]) {
            
            [self.txtState becomeFirstResponder];
        }
    }
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

- (BOOL)canBecomeFirstResponder {
    NSString *country = self.txtCountry.text;
    if ([country isEqualToString:@"Brasil"] ||
        [country isEqualToString:@"Brazil"] ||
        [country isEqualToString:@"Brésil"] ||
        [country isEqualToString:@"Бразилия"] ||
        [country isEqualToString:@"巴西"] ||
        [country isEqualToString:@"البرازيل"]) {
        
        self.constTopButton.constant = 94;
        self.txtState.hidden = NO;
        self.lbState.hidden = NO;
        
        [self.txtState becomeFirstResponder];
    }else{
        self.constTopButton.constant = 30;
        self.txtState.hidden = YES;
        self.lbState.hidden = YES;
    }
    
    return YES;
}

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.btnDob sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    if (newLength < oldLength) {
        return YES;
    } else {
        return newLength <= MAXLENGTH || returnKey;
    }
}

- (IBAction)btnDobAction:(id)sender {
    [self.txtEmail endEditing:YES];
    [self.txtNick endEditing:YES];
    [self.txtGender endEditing:YES];
    [self.txtRace endEditing:YES];
    
    
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:NSLocalizedString(@"constant.select", @"") style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        dob = controller.contentView.date;
        [self updateBirthDate];
        
        [self.btnDob setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dobSetted = YES;
        
        [self.txtGender becomeFirstResponder];
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = NSLocalizedString(@"sign_up_details.lb_dob", @"");
    dateSelectionController.message = NSLocalizedString(@"sign_up_details.tx_dob_placeholder", @"");
    
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
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"sign_up_details.email_required", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtNick.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"sign_up_details.nick_required", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (!dobSetted) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"sign_up_details.dob_required", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    NSInteger yearsOld = [DateUtil diffInDaysDate:dob andDate: [NSDate date]]/365;
    if (yearsOld < 13) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"sign_up_details.min_dob", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (yearsOld > 120) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"sign_up_details.max_dob", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtGender.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"sign_up_details.gender_required", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtRace.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"sign_up_details.race_required", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if ([self.txtPerfil.text isEqualToString:@""]) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"sign_up_details.perfil_required", @"")];
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
                msgError = NSLocalizedString(kMsgConnectionError, @"");
            }else{
                msgError = NSLocalizedString(@"sign_up_details.email_already_used", @"");
            }
            
            [self presentViewController:[ViewUtil showAlertWithMessage:msgError] animated:YES completion:nil];
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:NSLocalizedString(@"sign_up_details.without_localization", @"") preferredStyle:UIAlertControllerStyleActionSheet];
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
