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

@interface ListSymptomsViewController () {
    
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
    User *user;
    NSIndexPath *oldIndexPath;
    NSMutableIndexSet *selected;
}

@end

@implementation ListSymptomsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";
    selected = [[NSMutableIndexSet alloc] init];
    user = [User getInstance];
    [self loadSymptoms];
    
    symptomsSelected = [[NSMutableDictionary alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
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

- (IBAction)btnConfirmSurvey:(id)sender {
    
    
    if (selected.count > 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Deseja registrar suas informações?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"SIM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button YES");
            
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            
            [params setValue:user.idUser forKey:@"user_id"];
            [params setValue:[NSString stringWithFormat:@"%.8f" , latitude] forKey:@"lat"];
            [params setValue:[NSString stringWithFormat:@"%.8f", longitude] forKey:@"lon"];
            [params setValue:user.app_token forKey:@"app_token"];
            [params setValue:user.client forKey:@"client"];
            [params setValue:user.platform forKey:@"platform"];
            [params setValue:@"N" forKey:@"no_symptom"];
            [params setValue:user.user_token forKey:@"token"];
            
            if (![user.idHousehold isEqualToString:@""]) {
                [params setValue:user.idHousehold forKey:@"household_id"];
            }
            
            for (int i=0; i < 17; i++) {
                
                if ([selected containsIndex:i]) {
                    Symptom *symptom = [symptoms objectAtIndex:i];
                    if([symptom.code isEqualToString:@"hadContagiousContact"] || [symptom.code isEqualToString:@"hadHealthCare"] || [symptom.code isEqualToString:@"hadTravelledAbroad"]) {
                        [params setValue:@"true" forKey:symptom.code];
                    } else {
                        [params setValue:@"Y" forKey:symptom.code];
                    }
                    
                }
            }
            
            NSLog(@"params %@", params);
            
            AFHTTPRequestOperationManager *manager;
            
            manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://52.20.162.21/survey/create"
               parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      user.idHousehold = @"";
                      ThankYouForParticipatingViewController *thankYouForParticipatingViewController = [[ThankYouForParticipatingViewController alloc] init];
                      [self.navigationController pushViewController:thankYouForParticipatingViewController animated:YES];
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"error %@", error);
                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Infelizmente não conseguimos conlcuir esta operação. Tente novamente dentro de alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
                      UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                          NSLog(@"You pressed button OK");
                      }];
                      [alert addAction:defaultAction];
                      [self presentViewController:alert animated:YES completion:nil];
                      
                  }];
        }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"NÃO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button NO");
        }];
        [alert addAction:yesAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Escolha algum sintoma antes de confirmar.." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (void) loadSymptoms {
    
    symptoms = [[NSMutableArray alloc] init];
    
    Symptom *others;

    for (NSDictionary *item in user.symptoms) {
        NSString *name = item[@"name"];
        NSString *code = item[@"code"];
        
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
    
    if (indexPath.row == 0) {
        if ([symptom.code isEqualToString: @"febre"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 1) {
        if ([symptom.code isEqualToString: @"tosse"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 2) {
        if ([symptom.code isEqualToString: @"nausea-vomito"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 3) {
        if ([symptom.code isEqualToString: @"manchas-vermelhas"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 4) {
        if ([symptom.code isEqualToString: @"dor-nas-juntas"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 5) {
        if ([symptom.code isEqualToString: @"diarreia"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 6) {
        if ([symptom.code isEqualToString: @"dor-no-corpo"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 7) {
        if ([symptom.code isEqualToString: @"sangramento"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 8) {
        if ([symptom.code isEqualToString: @"dor-de-cabeca"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 9) {
        if ([symptom.code isEqualToString: @"olhos-vermelhos"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 10) {
        if ([symptom.code isEqualToString: @"coceira"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 11) {
        if ([symptom.code isEqualToString: @"falta-de-ar"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 12) {
        if ([symptom.code isEqualToString: @"urina-escura-ou-olhos-amarelados"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 13) {
        if ([symptom.code isEqualToString: @"outros"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.row == 14) {
        if ([symptom.code isEqualToString: @"hadContagiousContact"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 15) {
        if ([symptom.code isEqualToString: @"hadHealthCare"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    } else if (indexPath.row == 16) {
        if ([symptom.code isEqualToString: @"hadTravelledAbroad"]) {
            //UITableViewCell *cell = [self.tableSymptoms dequeueReusableCellWithIdentifier:symptom.code];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            cell.tag = indexPath.row;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = symptom.name;
            
            if ([selected containsIndex:indexPath.row]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
        
   return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"didSelectRowAtIndexPath");
    @try {
        //[self.tableSymptoms deselectRowAtIndexPath:indexPath animated:YES];
        //Symptom *currentSymptom = [symptoms objectAtIndex:indexPath.row];
        
        //NSLog(@"Row: %d", indexPath.row);
        //BOOL indexExists = NO;
        
        if (indexPath.row == 13) {
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor whiteColor];
            
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
            
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].selectedBackgroundView = bgColorView;
        } else {
        
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
            
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].selectedBackgroundView = bgColorView;
            
            if ([selected containsIndex:indexPath.row]) {
                [selected removeIndex:indexPath.row];
                [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            }
            else {
                [selected addIndex:indexPath.row];
                [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception.description);
    }
    
    /*if([self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [symptomsSelected removeObjectForKey:selectedSymptom.code];
    }else{
        [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [symptomsSelected setObject:selectedSymptom forKey:selectedSymptom.code];
    }*/
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
    
}
@end
