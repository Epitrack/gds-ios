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
    [self.txtGender.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.txtGender.DownPicker setPlaceholder:@"Selecione seu sexo"];
    [self.txtGender.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.txtGender.DownPicker setToolbarDoneButtonText:@"Selecionar"];
    
    (void)[self.txtRace initWithData: [Constants getRaces]];
    [self.txtRace.DownPicker setPlaceholder:@"Seleciona Cor/Raça"];
    [self.txtRace.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.txtRace.DownPicker setToolbarDoneButtonText:@"Selecionar"];
    
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
    
}

- (IBAction)btnSignupAction:(id)sender {
    if ([self isValid]) {
        
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
