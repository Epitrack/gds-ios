//
//  ProfileListViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 17/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ProfileListViewController.h"
#import "User.h"
#import "Household.h"
#import "SWRevealViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "ProfileFormViewController.h"

@interface ProfileListViewController () {
    
    User *user;
}

@end

@implementation ProfileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Perfil";
    self.navigationItem.hidesBackButton = YES;
    user = [User getInstance];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    //[self.btnMainUser setTitle:user.nick forState:UIControlStateNormal];
    [self loadUsers];
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
- (void) loadUsers {
    
    NSDictionary *households = user.household;
    users = [[NSMutableArray alloc] init];
    
    if (households.count > 0) {
        for (NSDictionary *h in households) {
            
            NSString *nick = h[@"nick"];
            NSString *picture = h[@"picture"];
            NSString *idHousehold = h[@"id"];
            NSString *dob = h[@"dob"];
            NSString *gender = h[@"gender"];
            NSString *race = h[@"race"];
            NSString *avatar;
            
            @try {
                if (picture.length > 2) {
                    avatar = @"img_profile01";
                }
            }
            @catch (NSException *exception) {
                
                NSString *p = [NSString stringWithFormat:@"%@", picture];
                
                if (p.length == 1) {
                    avatar = [NSString stringWithFormat: @"img_profile0%@", p];
                } else if (p.length == 2) {
                    avatar = [NSString stringWithFormat: @"img_profile%@", p];
                }
            }
            
            Household *household = [[Household alloc] initWithNick:nick andDob:dob andGender:gender andRace:race andIdUser:user.idUser andPicture:avatar andIdHousehold:idHousehold];
        
            [users addObject:household];
        }
    }
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Household *household = [users objectAtIndex:indexPath.row];
    
    ProfileFormViewController *profileFormViewController = [[ProfileFormViewController alloc] init];
    profileFormViewController.idUser = user.idUser;
    profileFormViewController.idHousehold = household.idHousehold;
    profileFormViewController.newMember = 1;
    
    profileFormViewController.txtNick.text = household.nick;
    profileFormViewController.txtDob.text = household.dob;
    		[profileFormViewController.btnPicture setBackgroundImage:[UIImage imageNamed:household.picture] forState:UIControlStateNormal];
    
    if ([household.gender isEqualToString:@"M"]) {
        profileFormViewController.segmentGender.selectedSegmentIndex = 0;
    } else {
        profileFormViewController.segmentGender.selectedSegmentIndex = 1;
    }
    
    if ([household.race isEqualToString:@"branco"]) {
        profileFormViewController.segmentRace.selectedSegmentIndex = 0;
    } else if ([household.race isEqualToString:@"preto"]) {
        profileFormViewController.segmentRace.selectedSegmentIndex = 1;
    } else if ([household.race isEqualToString:@"pardo"]) {
        profileFormViewController.segmentRace.selectedSegmentIndex = 2;
    } else if ([household.race isEqualToString:@"amarelo"]) {
        profileFormViewController.segmentRace.selectedSegmentIndex = 3;
    } else if ([household.race isEqualToString:@"indigena"]) {
        profileFormViewController.segmentRace.selectedSegmentIndex = 4;
    }
    
    [self.navigationController pushViewController:profileFormViewController animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");
    return users.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    
    static NSString *cellCacheID = @"CellCacheID";
    UITableViewCell *cell = [self.tableViewProfile dequeueReusableCellWithIdentifier:cellCacheID];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellCacheID];
    }
    
    cell.tag = indexPath.row;
    
    Household *household = [users objectAtIndex:indexPath.row];
    
    cell.textLabel.text = household.nick;
    cell.imageView.image = [UIImage imageNamed:household.picture];
    cell.detailTextLabel.text = @">";
    
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Deseja remover o perfil definitivamente? Essa operação é irreversível." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"SIM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button YES");
        
        Household *household = [users objectAtIndex:indexPath.row];
        
        NSString *idHousehold = household.idHousehold;
        NSString *url = [NSString stringWithFormat: @"http://52.20.162.21/household/delete/%@?client=api", idHousehold];
        
        AFHTTPRequestOperationManager *manager;
        manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
        [manager.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
        [manager GET:url
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self loadHouseholds];
                 [users removeObjectAtIndex:indexPath.row];
                 [self.tableViewProfile reloadData];
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Não foi possível executar a operação. Tente novamente em alguns instantes." preferredStyle:UIAlertControllerStyleActionSheet];
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
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Deletar";
}

- (IBAction)btnEditMainUser:(id)sender {
    
    ProfileFormViewController *profileFormViewController = [[ProfileFormViewController alloc] init];
    profileFormViewController.idUser = user.idUser;
    profileFormViewController.idHousehold = nil;
    profileFormViewController.newMember = 1;
    [self.navigationController pushViewController:profileFormViewController animated:YES];
}

- (IBAction)btnAddHousehold:(id)sender {
    
    ProfileFormViewController *profileFormViewController = [[ProfileFormViewController alloc] init];
    profileFormViewController.idUser = user.idUser;
    profileFormViewController.idHousehold = nil;
    profileFormViewController.newMember = 0;
    [self.navigationController pushViewController:profileFormViewController animated:YES];
}

- (void) loadHouseholds {
    
    NSString *idUSer = user.idUser;
    NSString *url = [NSString stringWithFormat: @"http://52.20.162.21/user/household/%@", idUSer];
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *households = responseObject[@"data"];
             
             user.household = households;
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
}
@end
