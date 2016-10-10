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
#import "ViewUtil.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import <Google/Analytics.h>
#import "ChangePasswordViewController.h"
#import "SWRevealViewController.h"
#import "TutorialViewController.h"
#import "MenuViewController.h"
#import "LocationUtil.h"
@import Photos;

#define MAXLENGTH 10

@interface ProfileFormViewController () {
    UserRequester *userRequester;
    HouseholdRequester *householdRequester;
    NSDate *birthdate;
    NSArray *listRace;
    NSArray *listGender;
    NSString *photo;
}

@end

@implementation ProfileFormViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnDob.layer.cornerRadius = 4;
    [self.btnDob.layer setBorderWidth:1.0f];
    [self.btnDob.layer setBorderColor:[[UIColor colorWithRed:223.0/255.f green:223.0/255.0f blue:223.0/255.0f alpha:1] CGColor]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    userRequester = [[UserRequester alloc] init];
    householdRequester = [[HouseholdRequester alloc] init];
    
    self.txtNick.delegate = self;
    
    listGender = [Constants getGenders];
    listRace = [Constants getRaces];
    
    // Setup down pickers
    (void)[self.pickerGender initWithData:[Constants getGenders]];
    [self.pickerGender.DownPicker setPlaceholder:NSLocalizedString(@"profile_form.placeholder_gender", @"")];
    [self.pickerGender.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.pickerGender.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    [self.pickerGender.DownPicker addTarget:self action:@selector(genderDownPickerDidSelected:) forControlEvents:UIControlEventValueChanged];
    
    (void)[self.pickerRace initWithData: [Constants getRaces]];
    [self.pickerRace.DownPicker setPlaceholder:NSLocalizedString(@"profile_form.placeholder_race", @"")];
    [self.pickerRace.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.pickerRace.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    [self.pickerRace.DownPicker addTarget:self action:@selector(raceDownPickerDidSelected:) forControlEvents:UIControlEventValueChanged];
    
    (void)[self.pickerRelationship initWithData:[Household getRelationshipArray]];
    [self.pickerRelationship.DownPicker setPlaceholder:NSLocalizedString(@"profile_form.placeholder_relationship", @"")];
    [self.pickerRelationship.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.pickerRelationship.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    [self.pickerRelationship.DownPicker addTarget:self action:@selector(relationshipDownPickerDidSelected:) forControlEvents:UIControlEventValueChanged];
    
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
    
    [self applyLayerOnPictureLayer];
    
    if (self.operation == EDIT_USER) {
        [self loadEditUser];
        [self updateFormWith:self.user.country];
    } else if (self.operation == EDIT_HOUSEHOLD){
        [self loadEditHousehold];
        [self updateFormWith:self.user.country];
    } else if (self.operation == ADD_HOUSEHOLD){
        [self loadAddHousehold];
        [self updateFormWith:@""];
    }
}

-(void)genderDownPickerDidSelected:(id)dp {
    [self.pickerGender resignFirstResponder];
    [self.btnDob sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)raceDownPickerDidSelected:(id)dp {
    if (self.operation == EDIT_USER) {
        [self.txtEmail becomeFirstResponder];
    } else {
        [self.pickerRelationship becomeFirstResponder];
    }
}

-(void)relationshipDownPickerDidSelected:(id)dp {
    [self.txtEmail becomeFirstResponder];
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

- (void) applyLayerOnPictureLayer{
    CGSize screenSize = self.btnPicture.frame.size;
    
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 addArcWithCenter:CGPointMake(screenSize.width/2, screenSize.height/2) radius:50 startAngle:M_PI*.15 endAngle: M_PI*.85 clockwise:YES];
    
    [circleLayer setPath:[path2 CGPath]];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path2.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:.7] CGColor];
    fillLayer.opacity = 0.8;
    
    [self.btnPicture.layer addSublayer:fillLayer];
    
    UIImageView *imgCam = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width/2)-((screenSize.width*.2)/2), screenSize.height*.8, screenSize.width*.2, screenSize.height*.15)];
    imgCam.image = [UIImage imageNamed:@"icon_camera.png"];
    [self.btnPicture addSubview:imgCam];

}

- (void) viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Profile Form Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if (self.operation != EDIT_USER) {
        self.btnSaveBottomConst.constant = 13;
        self.lblOr.hidden = YES;
        self.btnDelete.hidden = YES;
    }
}

- (void) loadEditUser{
    self.navigationItem.title = NSLocalizedString(@"profile_form.edit_profile", @"");
    self.txtEmail.enabled = NO;
    
    //Hide relationship
    [self.pickerRelationship removeFromSuperview];
    self.lbParentesco.hidden = YES;
    
    [self populateFormWithNick:self.user.nick
                        andDob:self.user.dob
                      andEmail:self.user.email
                     andGender:self.user.gender
                       andRace:self.user.race
                     andPerfil:self.user.perfil
                    andCountry:self.user.country
                      andState:self.user.state];
    
    if (self.user.photo) {
        [self.user requestPermissions:^(bool isAuthorazed){
            if (isAuthorazed) {
                [self setPhoto:self.user.photo];
            } else {
                [self setAvatarNumber:self.user.avatarNumber];
            }
        }];
    }else{
        [self setAvatarNumber:self.user.avatarNumber];
    }
}

-(void)downPickerDidSelected:(id)dp {
    NSString *country = ((UITextField *) dp).text;
    [self checkCountry:country];
}

- (void) checkCountry: (NSString *) country{
    NSString *originalCountry = [LocationUtil getCountryNameToEnglish:country];
    [self updateFormWith:originalCountry];
//    if ([originalCountry isEqualToString:@"Brazil"]) {
//        self.btnChangeTopConst.constant = 230;
//        self.lblState.hidden = NO;
//        self.txtState.hidden = NO;
//    }else if ([originalCountry isEqualToString:@"France"]) {
//        self.btnChangeTopConst.constant = 170;
//        self.lblState.hidden = YES;
//        self.txtState.hidden = YES;
//    }else{
//        
//    }
//    
//    if ([originalCountry isEqualToString:@"France"]) {
//        [self updateFormWith:true];
//    } else {
//        [self updateFormWith:false];
//    }
}

- (void) loadEditHousehold{
    self.navigationItem.title = NSLocalizedString(@"profile_form.edit_profile", @"");
    self.btnChangePasswd.hidden = YES;
    [self populateFormToHouseholdWithNick:self.household.nick
                                   andDob:self.household.dob
                                 andEmail:self.household.email
                                andGender:self.household.gender
                                  andRace:self.household.race
                          andRelationship:self.household.relationship
                                andPerfil:self.household.perfil
                               andCountry:self.household.country
                                 andState:self.household.state];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [self setAvatarNumber:[f numberFromString:self.household.idPicture]];
}

- (void) loadAddHousehold{
    self.navigationItem.title = NSLocalizedString(@"profile_form.add_member", @"");
    self.btnChangePasswd.hidden = YES;
    
    self.pictureSelected = @1;

    birthdate = [DateUtil dateFromString:@"10/10/1990"];
    [self updateBirthDate];

}

- (void) populateFormToHouseholdWithNick: (NSString *) nick
                                  andDob: (NSString *) dob
                                andEmail: (NSString *) email
                               andGender: (NSString *) gender
                                 andRace: (NSString *) race
                         andRelationship: (NSString *) relationship
                               andPerfil: (NSNumber *) perfil
                              andCountry: (NSString *) country
                                andState: (NSString *) state{
    self.pickerRelationship.text = [Household getRelationshipsDictonary][relationship];

    
    [self populateFormWithNick:nick
                        andDob:dob
                      andEmail:email
                     andGender:gender
                       andRace:race
                     andPerfil:perfil
                    andCountry:country
                      andState:state];
    
}

- (void) populateFormWithNick: (NSString *) nick
                       andDob: (NSString *) dob
                     andEmail: (NSString *) email
                    andGender: (NSString *) gender
                      andRace: (NSString *) race
                    andPerfil: (NSNumber *) perfil
                   andCountry: (NSString *) country
                     andState: (NSString *) state{
    self.txtNick.text = nick;
    self.txtEmail.text = email;
    
    birthdate = [DateUtil dateFromStringUS:dob];
    [self updateBirthDate];
    [self.btnDob setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
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
    
    if (perfil) {
        self.txtPerfil.text = [Constants getPerfis][[perfil intValue] - 1];
    }
    NSString *strCountry = [LocationUtil getCountryNameToCurrentLocale: country];
    self.txtCountry.text = strCountry;
    [self checkCountry: country];
    
    if (state){
        if (state.length > 2) {
            self.txtState.text = state;
        } else {
            self.txtState.text = [LocationUtil getStatebyUf:state];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtNick endEditing:YES];
    [self.txtEmail endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.txtNick resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    
    [self.pickerGender becomeFirstResponder];
    
    return YES;
}

- (BOOL) isFormValid{
    BOOL fieldsValid = YES;
    if ([self.txtNick.text isEqualToString:@""]) {
        fieldsValid = NO;
    } else if ([self.txtEmail.text isEqualToString:@""] && self.operation == EDIT_USER) {
        fieldsValid = NO;
    }else if (self.operation != EDIT_USER && [self.pickerRelationship.text isEqualToString:@""]){
        fieldsValid = NO;
    }else if ([self.txtCountry.text isEqualToString:@""]){
        fieldsValid = NO;
    }else if ([self.txtPerfil.text isEqualToString:@""]){
        fieldsValid = NO;
    }else if ([self.txtState.text isEqualToString:@""]){
        if ([self.txtCountry.text isEqualToString:@"Brasil"] ||
            [self.txtCountry.text isEqualToString:@"Brazil"] ||
            [self.txtCountry.text isEqualToString:@"Brésil"] ||
            [self.txtCountry.text isEqualToString:@"Бразилия"] ||
            [self.txtCountry.text isEqualToString:@"巴西"] ||
            [self.txtCountry.text isEqualToString:@"البرازيل"]) {
            
            fieldsValid = NO;
        }
    }
    
    return fieldsValid;
}

- (BOOL) isDobValid{
    NSInteger diffDay = [DateUtil diffInDaysDate:[NSDate date] andDate:birthdate];
    if (diffDay > 0) {
        return NO;
    }
    
    return YES;
}

- (IBAction)btnAction:(id)sender {
    
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_exec_form"
                                                           label:@"Execute Profile form"
                                                           value:nil] build]];
    
    if (![self isFormValid]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                       message:NSLocalizedString(@"profile_form.fill_in_fields", @"")
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.ok", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                    NSLog(@"You pressed button OK");
                }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if(![self isDobValid]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                       message:NSLocalizedString(@"profile_form.invalid_dob", @"")
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.ok", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button OK");
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
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
    userUpdater.email = self.txtEmail.text;
    userUpdater.dob = [NSString stringWithFormat:@"%@", birthdate];
    [userUpdater setGenderByString:self.pickerGender.text];
    [userUpdater setRaceByStr:self.pickerRace.text];
    userUpdater.avatarNumber = self.pictureSelected;
    userUpdater.country = [LocationUtil getCountryNameToEnglish: self.txtCountry.text];
    userUpdater.state = [LocationUtil getUfByState:self.txtState.text];
    [userUpdater setPerfilByString: self.txtPerfil.text];
    
    NSInteger diffDay = [DateUtil diffInDaysDate:birthdate andDate:[NSDate date]];
    
    if((diffDay/365) < 13){
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"profile_form.min_dob", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    if((diffDay/365) > 120){
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"profile_form.max_dob", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    if (!userUpdater.isValidEmail) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"profile_form.invalid_email", @"")];
        [self presentViewController:alert animated:YES completion:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    
    [userRequester updateUser:userUpdater onSuccess:^(User *user){
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        if (user && user.user_token) {
            [preferences setValue:user.avatarNumber forKey:kAvatarNumberKey];
            [preferences setValue:photo forKey:kPhotoKey];
            [preferences setValue:user.nick forKey:kNickKey];
            
            [preferences synchronize];

//            User *user = [User getInstance];
            user.avatarNumber = self.pictureSelected;
            user.photo = photo;
        }
        
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
    Household *household = [[Household alloc]init];
    household.nick = self.txtNick.text;
    household.email = self.txtEmail.text;
    household.dob = [DateUtil stringUSFromDate:birthdate];
    [household setGenderByString:self.pickerGender.text];
    [household setRaceByStr:self.pickerRace.text];
    household.picture = [self.pictureSelected stringValue];
    household.relationship = [self getRelationship];
    household.country = [LocationUtil getCountryNameToEnglish: self.txtCountry.text];
    household.state = [LocationUtil getUfByState:self.txtState.text];
    [household setPerfilByString: self.txtPerfil.text];
    
    if (self.operation == EDIT_HOUSEHOLD) {
        household.idHousehold = self.household.idHousehold;
    }
    
    return household;
}

- (void) showSuccessMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:NSLocalizedString(@"profile_form.success", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showErrorMsg: (NSError *) error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"Error: %@", error);
    UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"profile_form.fail", @"")];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnSelectPicture:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_edit_avatar"
                                                           label:@"Edit avatar"
                                                           value:nil] build]];
    
    BOOL showCamaraButton = NO;
    
    if (self.operation == EDIT_USER) {
        showCamaraButton = YES;
    }
    
    
    SelectAvatarViewController *selectAvatarViewController = [[SelectAvatarViewController alloc] initWithBtnCamera:showCamaraButton];
    selectAvatarViewController.profileFormCtr = self;

    [self.navigationController pushViewController:selectAvatarViewController animated:YES];
}

- (void) setAvatarNumber: (NSNumber *) avatarNumber{
    self.pictureSelected = avatarNumber;

    photo = nil;
    
    NSString *avatar = [NSString stringWithFormat:@"img_profile%02ld.png", (long)[avatarNumber integerValue]];
    [self.btnPicture setBackgroundImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
}

- (void) setPhoto: (NSString *) photoUrl{
    photo = photoUrl;
    
    PHFetchResult* assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[photo] options:nil];
    PHAsset *asset = [assetResult firstObject];
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        UIImage* photoImage = [UIImage imageWithData:imageData];
        
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.btnPicture.bounds];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        self.btnPicture.layer.mask = maskLayer;
        
        [self.btnPicture setBackgroundImage:photoImage forState:UIControlStateNormal];
    }];
}


- (IBAction)btnDobAction:(id)sender {
    [self.txtEmail endEditing:YES];
    [self.txtNick endEditing:YES];
    [self.pickerGender endEditing:YES];
    [self.pickerRace endEditing:YES];
    [self.pickerRelationship endEditing:YES];
    
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:NSLocalizedString(@"constant.select", @"") style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        birthdate = controller.contentView.date;
        [self updateBirthDate];
        
        [self.btnDob setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        [self.pickerRace becomeFirstResponder];
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = NSLocalizedString(@"profile_form.title_dob", @"");
    dateSelectionController.message = NSLocalizedString(@"profile_form.msg_dob", @"");
    
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

- (NSString *) getRelationship{
    for(NSString *relationshipKey in [Household getRelationshipsDictonary]){
        NSString *relationship = [[Household getRelationshipsDictonary] objectForKey:relationshipKey];
        if ([relationship isEqualToString:self.pickerRelationship.text]) {
            return relationshipKey;
        }
    }
    
    return nil;
}
- (void)btnChangePasswdAction:(id)sender{
    ChangePasswordViewController *changePasswdViewCtrl = [[ChangePasswordViewController alloc] init];\
    [self.navigationController pushViewController:changePasswdViewCtrl animated:YES];
}

- (IBAction)btnDeleteAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da saúde" message:NSLocalizedString(@"profile_form.delete_confirmation", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.yes", @"")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         [userRequester deleteAccountUser:self.user
                                                                                  onStart:^{
                                                                                      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                                                  } onSuccess:^{
                                                                                      [self deleteAccountSuccess];
                                                                                  } onErro:^(NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                                      NSString *errorMsg;
                                                                                      if (error && error.code == -1009) {
                                                                                          errorMsg = NSLocalizedString(kMsgConnectionError, @"");
                                                                                      } else {
                                                                                          errorMsg = NSLocalizedString(kMsgApiError, @"");
                                                                                      }
                                                                                      
                                                                                      [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                                                                  }];
                                                     }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.no", @"")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action){}];
    
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) deleteAccountSuccess{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"profile_form.modal_delete_title", @"")
                                                                   message:NSLocalizedString(@"profile_form.modal_delete_body", @"")
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.ok", @"")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
        [[MenuViewController getInstance] doLogout];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) updateFormWith: (NSString *) enCountryName{
    bool hiddenRace = ([enCountryName isEqualToString:@"France"] || [enCountryName isEqualToString:@""]);
    self.lbRace.hidden = hiddenRace;
    self.pickerRace.hidden = hiddenRace;
    
    bool showState = [enCountryName isEqualToString:@"Brazil"];
    self.lblState.hidden = !showState;
    self.txtState.hidden = !showState;
    
    if (self.operation == EDIT_USER) {
        self.constTopEmail.constant = 8.0;
    }else{
        self.constTopEmail.constant = 70.0;
    }
    
    if (showState) {
        self.btnChangeTopConst.constant = 280;
        self.lbRaceTopConst.constant = 72.0;
    } else if (!hiddenRace){
        self.btnChangeTopConst.constant = 230.0;
        self.lbRaceTopConst.constant = 8.0;
    }else {
        self.btnChangeTopConst.constant = 170.0;
    }
    
    self.lbParentesco.hidden = (self.operation == EDIT_USER);
    self.pickerRelationship.hidden = (self.operation == EDIT_USER);
}

@end