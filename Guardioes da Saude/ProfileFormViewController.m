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
@import Photos;

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
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    userRequester = [[UserRequester alloc] init];
    householdRequester = [[HouseholdRequester alloc] init];
    
    listGender = [Constants getGenders];
    listRace = [Constants getRaces];
    
    // Setup down pickers
    (void)[self.pickerGender initWithData:[Constants getGenders]];
    [self.pickerGender.DownPicker setPlaceholder:@"Selecione seu sexo"];
    [self.pickerGender.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.pickerGender.DownPicker setToolbarDoneButtonText:@"Selecionar"];
    
    (void)[self.pickerRace initWithData: [Constants getRaces]];
    [self.pickerRace.DownPicker setPlaceholder:@"Seleciona sua cor/raça"];
    [self.pickerRace.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.pickerRace.DownPicker setToolbarDoneButtonText:@"Selecionar"];
    
    (void)[self.pickerRelationship initWithData:[Household getRelationshipArray]];
    [self.pickerRelationship.DownPicker setPlaceholder:@"Selecione o parentesco"];
    [self.pickerRelationship.DownPicker setToolbarCancelButtonText:@"Cancelar"];
    [self.pickerRelationship.DownPicker setToolbarDoneButtonText:@"Selecionar"];
    
    [self applyLayerOnPictureLayer];
    
    if (self.operation == EDIT_USER) {
        [self loadEditUser];
    } else if (self.operation == EDIT_HOUSEHOLD){
        [self loadEditHousehold];
    } else if (self.operation == ADD_HOUSEHOLD){
        [self loadAddHousehold];
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
}

- (void) loadEditUser{
    self.navigationItem.title = @"Editar Perfil";
    self.txtEmail.enabled = YES;
    
    //Hide relationship
    [self.pickerRelationship removeFromSuperview];
    self.lbParentesco.hidden = YES;
    self.topTxtEmailContraint.constant = 8;
    
    [self populateFormWithNick:self.user.nick
                        andDob:self.user.dob
                      andEmail:self.user.email
                     andGender:self.user.gender
                       andRace:self.user.race];
    
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

- (void) loadEditHousehold{
    self.navigationItem.title = @"Editar Perfil";
    self.btnChangePasswd.hidden = YES;
    [self populateFormToHouseholdWithNick:self.household.nick
                                   andDob:self.household.dob
                                 andEmail:self.household.email
                                andGender:self.household.gender
                                  andRace:self.household.race
                          andRelationship:self.household.relationship];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [self setAvatarNumber:[f numberFromString:self.household.idPicture]];
}

- (void) loadAddHousehold{
    self.navigationItem.title = @"Adicionar Novo Membro";
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
                         andRelationship: (NSString *) relationship{
    self.pickerRelationship.text = [Household getRelationshipsDictonary][relationship];

    
    [self populateFormWithNick:nick
                        andDob:dob
                      andEmail:email
                     andGender:gender
                       andRace:race];
    
}

- (void) populateFormWithNick: (NSString *) nick
                       andDob: (NSString *) dob
                     andEmail: (NSString *) email
                    andGender: (NSString *) gender
                      andRace: (NSString *) race{
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

- (BOOL) isFormValid{
    BOOL fieldsValid = YES;
    if ([self.txtNick.text isEqualToString:@""]) {
        fieldsValid = NO;
    } else if ([self.txtEmail.text isEqualToString:@""] && self.operation == EDIT_USER) {
        fieldsValid = NO;
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
                                                                       message:@"Preencha todos os campos do formulário."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                    NSLog(@"You pressed button OK");
                }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if(![self isDobValid]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                       message:@"A data de aniversário deve ser menor que hoje."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
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
    userUpdater.race = [self.pickerRace.text lowercaseString];
    userUpdater.avatarNumber = self.pictureSelected;
    
    NSInteger diffDay = [DateUtil diffInDaysDate:birthdate andDate:[NSDate date]];
    
    if((diffDay/365) < 13){
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"A idade mínima para o usuário principal é 13 anos."];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (!userUpdater.isValidEmail) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"E-mail inválido!"];
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

            User *user = [User getInstance];
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
    household.race = [self.pickerRace.text lowercaseString];
    household.picture = [self.pictureSelected stringValue];
    household.relationship = [self getRelationship];
    
    if (self.operation == EDIT_HOUSEHOLD) {
        household.idHousehold = self.household.idHousehold;
    }
    
    return household;
}

- (void) showSuccessMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Operação realizada com sucesso." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showErrorMsg: (NSError *) error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"Error: %@", error);
    UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Ocorreu um problema de comunicação, por favor verifique sua conexão!"];
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
    [self.pickerGender endEditing:YES];
    [self.pickerRace endEditing:YES];
    [self.pickerRelationship endEditing:YES];
    
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
@end