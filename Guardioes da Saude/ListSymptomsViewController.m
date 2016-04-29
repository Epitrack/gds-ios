//
//  ListSymptomsViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 27/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ListSymptomsViewController.h"
#import "Symptom.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "ThankYouForParticipatingViewController.h"
#import "ViewUtil.h"
#import "UserRequester.h"
#import "MBProgressHUD.h"
#import "SurveyMap.h"
#import "SurveyRequester.h"
#import "MBProgressHUD.h"
#import "ViewUtil.h"
#import "LocationUtil.h"
#import <Google/Analytics.h>

@interface ListSymptomsViewController () {
    
    User *user;
    SurveyRequester *surveyRequester;
    NSIndexPath *oldIndexPath;
    NSMutableIndexSet *selected;
    UIColor *bgCellColor;
    UserRequester *userRequester;
}

@end

@implementation ListSymptomsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"list_symptoms.title", @"");
    self.txtPais.text = @"";
    self.txtPais.enabled = NO;
    self.txtPais.hidden = YES;
    selected = [[NSMutableIndexSet alloc] init];
    user = [User getInstance];
    userRequester = [[UserRequester alloc] init];
    surveyRequester = [[SurveyRequester alloc] init];
    [self loadSymptoms];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    bgCellColor = [UIColor colorWithRed:(22/255.0) green:(112/255.0) blue:(200/255.0) alpha:1];
    [self.tableSymptoms setSeparatorColor:bgCellColor];
    
    symptomsSelected = [[NSMutableDictionary alloc] init];
    
    (void)[self.txtPais initWithData:[LocationUtil getCountriesWithBrazil:NO]];
    [self.txtPais.DownPicker setPlaceholder:NSLocalizedString(@"list_symptoms.placeholder_country", @"")];
    [self.txtPais.DownPicker setToolbarCancelButtonText:NSLocalizedString(@"constant.cancel", @"")];
    [self.txtPais.DownPicker setToolbarDoneButtonText:NSLocalizedString(@"constant.select", @"")];
    
    [self setTableSeparator];
    
    self.txHeader.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"List Symptoms Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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

- (IBAction)btnConfirmSurvey:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_confirm_survey"
                                                           label:@"Confirm Survey"
                                                           value:nil] build]];
    
    BOOL isTxtPaisValid = YES;
    
    for (int i=0; i < symptoms.count; i++) {
        
        if ([selected containsIndex:i]) {
            Symptom *symptom = [symptoms objectAtIndex:i];
            if([symptom.code isEqualToString:@"hadTravelledAbroad"] && [self.txtPais.text isEqualToString:@""]) {
                isTxtPaisValid = NO;
            }
        }
    }
    
    if (!isTxtPaisValid) {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"list_symptoms.country_required", @"")];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (selected.count > 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:NSLocalizedString(@"list_symptoms.allow_send", @"") preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.yes", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button YES");
            
            SurveyMap *survey = [[SurveyMap alloc] init];
            NSMutableDictionary *surveySymptoms = [[NSMutableDictionary alloc] init];
            for (int i=0; i < 17; i++) {
                if ([selected containsIndex:i]) {
                    Symptom *symptom = [symptoms objectAtIndex:i];
                    if([symptom.code isEqualToString:@"hadContagiousContact"] || [symptom.code isEqualToString:@"hadHealthCare"] || [symptom.code isEqualToString:@"hadTravelledAbroad"]) {
                        [surveySymptoms setValue:@"true" forKey:symptom.code];
                    } else {
                        [surveySymptoms setValue:@"Y" forKey:symptom.code];
                    }
                }
            }
            
            [survey setSymptoms:surveySymptoms];
            [survey setLatitude:[NSString stringWithFormat:@"%.8f" , self.latitude]];
            [survey setLongitude:[NSString stringWithFormat:@"%.8f" , self.longitude]];
            [survey setTravelLocation:self.txtPais.text];
            [survey setIsSymptom:@"Y"];
            if (![user.idHousehold isEqualToString:@""] && user.idHousehold  != nil) {
                [survey setIdHousehold:user.idHousehold];
            }
            
            [surveyRequester createSurvey:survey
                               andOnStart:^{
                                   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                               }
                             andOnSuccess:^(SurveyType surveyType){
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 
                                 user.idHousehold = @"";
                                 ThankYouForParticipatingViewController *thanksViewCtrl = [[ThankYouForParticipatingViewController alloc] initWithType:surveyType];
                                 [self.navigationController pushViewController:thanksViewCtrl animated:YES];
                             }
                               andOnError:^(NSError *error){
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
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.no", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button NO");
        }];
        [alert addAction:yesAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"list_symptoms.check_a_symptom", @"")];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (void) loadSymptoms {
    [userRequester getSymptonsOnStart:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }andSuccess:^(NSMutableArray *symptomsResponse){
        symptoms = [[NSMutableArray alloc] init];
        
        [symptoms addObject:[[Symptom alloc] initWithName:NSLocalizedString(@"list_symptoms.symptoms", @"") andCode:@"sintomas"]];
        [symptoms addObjectsFromArray: symptomsResponse];
        [symptoms addObject:[[Symptom alloc] initWithName:NSLocalizedString(@"list_symptoms.others", @"") andCode:@"outros"]];
        [symptoms addObject:[[Symptom alloc] initWithName:NSLocalizedString(@"list_symptoms.had_contact_symptom", @"") andCode:@"hadContagiousContact"]];
        [symptoms addObject:[[Symptom alloc] initWithName:NSLocalizedString(@"list_symptoms.find_a_health_service", @"") andCode:@"hadHealthCare"]];
        [symptoms addObject:[[Symptom alloc] initWithName:NSLocalizedString(@"list_symptoms.traveled", @"") andCode:@"hadTravelledAbroad"]];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableSymptoms reloadData];
        [self adjustHeightOfTableview];
    } andOnError:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");
    return symptoms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    static NSString *cellSymptomCacheID = @"CellSymptomCacheID";
    UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:cellSymptomCacheID];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellSymptomCacheID];
    }
    
    Symptom *symptom = [symptoms objectAtIndex:indexPath.row];
    
    if ([symptom.code isEqualToString: @"outros"] || [symptom.code isEqualToString: @"sintomas"]) {
        cell.backgroundColor = bgCellColor;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"Foco-Bold" size:18];
        cell.tag = indexPath.row;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.text = symptom.name;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }else{
        cell.backgroundColor = bgCellColor;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.tag = indexPath.row;
        cell.textLabel.font = [UIFont fontWithName:@"Foco-Regular" size:14];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.text = symptom.name;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        if ([selected containsIndex:indexPath.row]) {
            UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checked"]];
            cell.accessoryView = checkmark;
        } else {
            UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkbox_false.png"]];
            cell.accessoryView = checkmark;
        }
    }
   return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"didSelectRowAtIndexPath");
    @try {
        [self.tableSymptoms deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell = [self.tableSymptoms cellForRowAtIndexPath:indexPath];
        
        UIView *bgColorView = [[UIView alloc] initWithFrame:cell.frame];
        bgColorView.backgroundColor = bgCellColor;

        cell.selectedBackgroundView = bgColorView;
        
        [self.view layoutIfNeeded];
        
        if (indexPath.row == (symptoms.count-1)) {
            if ([selected containsIndex:indexPath.row]) {
                self.txtPais.text = @"";
                self.txtPais.enabled = NO;
                self.txtPais.hidden = YES;
                
                self.topConfirmationConstraint.constant = 8.0;
            } else {
                self.txtPais.hidden = NO;
                self.txtPais.enabled = YES;
                
                self.topConfirmationConstraint.constant = 30.0;
            }
            
            [UIView animateWithDuration:.25 animations:^(){
                [self.view layoutIfNeeded];
            }];
        }
        
        Symptom *symptom = [symptoms objectAtIndex:indexPath.row];
        if ([symptom.code isEqualToString: @"outros"] || [symptom.code isEqualToString: @"sintomas"]) {
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryView = nil;
        } else {
            if ([selected containsIndex:indexPath.row]) {
                [selected removeIndex:indexPath.row];
                UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkbox_false.png"]];
                [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryView = checkmark;
            } else {
                [selected addIndex:indexPath.row];
                UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checked"]];
                [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryView = checkmark;
            }
        }

    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception.description);
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableSymptoms respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableSymptoms setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableSymptoms respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableSymptoms setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void) setTableSeparator{
    UIColor *color = [UIColor whiteColor];
    [self.tableSymptoms setSeparatorColor:color];
    self.tableSymptoms.tableFooterView = [UIView new];
}

- (void)adjustHeightOfTableview
{
    CGFloat height = symptoms.count * 44;
    
    // now set the height constraint accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableViewHeightConstraint.constant = height;
        [self.view setNeedsUpdateConstraints];
    }];
}
@end
