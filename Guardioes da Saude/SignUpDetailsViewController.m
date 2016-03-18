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
#import <Google/Analytics.h>

@interface SignUpDetailsViewController (){
    NSDate *dob;
}

@end

@implementation SignUpDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnDob.layer.cornerRadius = 4;
    
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
@end
