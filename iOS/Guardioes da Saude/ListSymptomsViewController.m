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

@interface ListSymptomsViewController () {
    
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
    User *user;
    SurveyRequester *surveyRequester;
    NSIndexPath *oldIndexPath;
    NSMutableIndexSet *selected;
    UIColor *bgCellColor;
}

@end

@implementation ListSymptomsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Participe Agora";
    self.txtPais.text = @"";
    self.txtPais.enabled = NO;
    self.txtPais.hidden = YES;
    selected = [[NSMutableIndexSet alloc] init];
    user = [User getInstance];
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
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    [self setTableSeparator];
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
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Por favor, preencha o nome do pais!"];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (selected.count > 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Deseja registrar suas informações?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Sim" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
            [survey setLatitude:[NSString stringWithFormat:@"%.8f" , latitude]];
            [survey setLongitude:[NSString stringWithFormat:@"%.8f" , longitude]];
            [survey setTravelLocation:self.txtPais.text];
            [survey setIsSymptom:@"Y"];
            if (![user.idHousehold isEqualToString:@""] && user.idHousehold  != nil) {
                [survey setIdHousehold:user.idHousehold];
            }
            
            [surveyRequester createSurvey:survey
                               andOnStart:^{
                                   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                               }
                             andOnSuccess:^(bool isZika){
                                 ScreenType type = BAD_SYMPTON;
                                 if (isZika) {
                                     type = ZIKA;
                                 }
             
                                 ThankYouForParticipatingViewController *thanksViewCtrl = [[ThankYouForParticipatingViewController alloc] initWithType:type];
                                 [self.navigationController pushViewController:thanksViewCtrl animated:YES];
                             }
                               andOnError:^(NSError *error){
                                   UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Infelizmente não conseguimos conlcuir esta operação. Por favor verifique sua conexão."];
                                   [self presentViewController:alert animated:YES completion:nil];
                               }];
        }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Não" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button NO");
        }];
        [alert addAction:yesAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Escolha algum sintoma antes de confirmar."];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (void) loadSymptoms {
    
    symptoms = [[NSMutableArray alloc] init];
    
    Symptom *others;

    for (NSDictionary *item in user.symptoms) {
        NSString *name = item[@"name"];
        NSString *code = item[@"code"];
        
        NSLog(@"Name = %@ and code = %@", name, code);
        
        Symptom *s = [[Symptom alloc] initWithName:name andCode:code];
        [symptoms addObject:s];
    }
    
    others = [[Symptom alloc] initWithName:@"Outros" andCode:@"outros"];
    [symptoms addObject:others];
    others = [[Symptom alloc] initWithName:@"Tive contato com alguém com um desses sintomas" andCode:@"hadContagiousContact"];
    [symptoms addObject:others];
    others = [[Symptom alloc] initWithName:@"Procurei um serviço de saúde" andCode:@"hadHealthCare"];
    [symptoms addObject:others];
    others = [[Symptom alloc] initWithName:@"Estive fora do Brasil nos últimos 14 dias" andCode:@"hadTravelledAbroad"];
    [symptoms addObject:others];
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
    
    if ([symptom.code isEqualToString: @"outros"]) {
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
        
        if ([selected containsIndex:indexPath.row]) {
            UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkbok_true.png"]];
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
        
        
        if (indexPath.row == 16) {
            if ([selected containsIndex:indexPath.row]) {
                self.txtPais.text = @"";
                self.txtPais.enabled = NO;
                self.txtPais.hidden = YES;
            } else {
                self.txtPais.hidden = NO;
                self.txtPais.enabled = YES;
            }
        }
        
        if (indexPath.row == 13) {
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryView = nil;
        } else {
            if ([selected containsIndex:indexPath.row]) {
                [selected removeIndex:indexPath.row];
                UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkbox_false.png"]];
                [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryView = checkmark;
            } else {
                [selected addIndex:indexPath.row];
                UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkbok_true.png"]];
                [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryView = checkmark;
            }
        }

    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception.description);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
    
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
//    UIColor *color = [UIColor colorWithRed:(0/255.0) green:(105/255.0) blue:(216/255.0) alpha:1];
    [self.tableSymptoms setSeparatorColor:color];
    self.tableSymptoms.tableFooterView = [UIView new];
}
@end
