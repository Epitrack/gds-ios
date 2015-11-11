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
}

@end

@implementation ListSymptomsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";
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
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];;
    
    [params setValue:@"user_id" forKey:user.idUser];
    [params setValue:@"lat" forKey:[NSString stringWithFormat:@"%.8f", latitude]];
    [params setValue:@"lon" forKey:[NSString stringWithFormat:@"%.8f", longitude]];
    [params setValue:@"app_token" forKey:user.app_token];
    [params setValue:@"client" forKey:user.client];
    [params setValue:@"platform" forKey:user.platform];
    [params setValue:@"no_symptom" forKey:@"N"];
    [params setValue:@"token" forKey:user.user_token];
    
    for (Symptom *s in symptomsSelected) {
        NSString *code = [NSString stringWithFormat:@"%@", s];
        if([code isEqualToString:@"hadContagiousContact"] || [code isEqualToString:@"hadHealthCare"] || [code isEqualToString:@"hadTravelledAbroad"]) {
            [params setValue:@"true" forKey:code];
        } else {
            [params setValue:@"Y" forKey:code];
        }
    }
        
    NSLog(@"params %@", params);
    
    
    AFHTTPRequestOperationManager *manager;
    
    manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://52.20.162.21/survey/create"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              ThankYouForParticipatingViewController *thankYouForParticipatingViewController = [[ThankYouForParticipatingViewController alloc] init];
              [self.navigationController pushViewController:thankYouForParticipatingViewController animated:YES];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Infelizmente não conseguimos conlcuir esta operação. Tente novamente dentro de alguns minutos." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
}

- (void) loadSymptoms {
    
    symptoms = [[NSMutableArray alloc] init];
    
    Symptom *others = [[Symptom alloc] initWithName:@"Sintomas" andCode:@"sintomas"];
    [symptoms addObject:others];
    
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
    
    if ([symptom.code isEqualToString: @"sintomas"] || [symptom.code isEqualToString: @"outros"]) {
        cell.backgroundColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithRed:(30/255.0) green:(136/255.0) blue:(229/255.0) alpha:1];
    }
    
    cell.tag = indexPath.row;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = symptom.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"didSelectRowAtIndexPath");
    @try {
        //[self.tableSymptoms deselectRowAtIndexPath:indexPath animated:YES];
        Symptom *currentSymptom = [symptoms objectAtIndex:indexPath.row];
        
        NSLog(@"Row: %d", indexPath.row);
        BOOL indexExists = NO;
        
        if (indexPath.row == 0 || indexPath.row == 14) {
            [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        } else {
        
            for (Symptom *s in symptomsSelected) {
            
                NSString *curremtCode = currentSymptom.code;
                NSString *code = [NSString stringWithFormat:@"%@", s];
            
                if ([code isEqualToString:curremtCode]) {
                    //[symptomsSelected removeObjectForKey:currentSymptom.code];
                    [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                    indexExists = YES;
                }
            }
            if (indexExists == NO) {
                [self.tableSymptoms cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                //[symptomsSelected setObject:currentSymptom forKey:currentSymptom.code];
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
