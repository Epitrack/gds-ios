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
#import "SingleHousehold.h"
#import "HouseholdRequester.h"
#import "MBProgressHUD.h"
#import "ViewUtil.h"
#import <Google/Analytics.h>
@import Photos;

@interface ProfileListViewController () {
    User *user;
    HouseholdRequester *householdeRequest;
}

@property NSMutableArray *households;

@end

@implementation ProfileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Perfil";
    self.navigationItem.hidesBackButton = YES;
    householdeRequest = [[HouseholdRequester alloc]init];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    

}

- (void)  viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Profile List Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    user = [User getInstance];
    [self.btnMainUser setTitle:user.nick forState:UIControlStateNormal];
    [user setAvatarImageAtButton:self.imgMainUser orImageView:nil onBackground:YES isSmall:NO];
    
    [self loadHouseholds];
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
            
            //NSString *p = [NSString stringWithFormat:@"%@", picture];
            
            if (picture.length > 2) {
                avatar = @"img_profile01.png";
            } else if (picture.length == 1) {
                avatar = [NSString stringWithFormat: @"img_profile0%@.png", picture];
            } else if (picture.length == 2) {
                avatar = [NSString stringWithFormat: @"img_profile%@.png", picture];
            }
            
            Household *household = [[Household alloc] initWithNick:nick andDob:dob andGender:gender andRace:race andIdUser:user.idUser andPicture:avatar andIdHousehold:idHousehold andIdPicture:picture];
        
            [users addObject:household];
        }
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileFormViewController *profileFormViewController = [[ProfileFormViewController alloc] init];
    Household *household = [users objectAtIndex:indexPath.row];
    [profileFormViewController setHousehold:household];
    [profileFormViewController setOperation:EDIT_HOUSEHOLD];
    
    [self.navigationController pushViewController:profileFormViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        
        [householdeRequest deleteHouseholdWithId:household.idHousehold
                                      andOnStart:^{ [MBProgressHUD showHUDAddedTo:self.view animated:YES];}
                                    andOnSuccess:^{
                                        [self loadHouseholds];
                                        [users removeObjectAtIndex:indexPath.row];
                                        [self.tableViewProfile reloadData];
                                    }
                                      andOnError:^(NSError *error){
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          NSString *errorMsg;
                                          if (error && error.code == -1009) {
                                              errorMsg = kMsgConnectionError;
                                          } else {
                                              errorMsg = kMsgApiError;
                                          }
                                          
                                          [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
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
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_edit_main_user"
                                                           label:@"Edit Main User"
                                                           value:nil] build]];
    
    ProfileFormViewController *profileFormViewController = [[ProfileFormViewController alloc] init];
    [profileFormViewController setOperation:EDIT_USER];
    [profileFormViewController setUser:user];
    
    [self.navigationController pushViewController:profileFormViewController animated:YES];
}

- (IBAction)btnAddHousehold:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_edit_household"
                                                           label:@"Edit Household"
                                                           value:nil] build]];
    
    ProfileFormViewController *profileFormViewController = [[ProfileFormViewController alloc] init];
    [profileFormViewController setOperation:ADD_HOUSEHOLD];
    
    [self.navigationController pushViewController:profileFormViewController animated:YES];
}

- (void) loadHouseholds {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [householdeRequest getHouseholdsByUser:user onSuccess:^(NSMutableArray *householdes){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        users = [[NSMutableArray alloc] initWithArray:householdes];
        [self.tableViewProfile reloadData];
    }onFail:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Ocorreu um erro ao carregar os households");
    }];
}
- (IBAction)imgMainUserAction:(id)sender {
    ProfileFormViewController *profileFormViewController = [[ProfileFormViewController alloc] init];
    [profileFormViewController setOperation:EDIT_USER];
    [profileFormViewController setUser:user];
    
    [self.navigationController pushViewController:profileFormViewController animated:YES];
}
@end
