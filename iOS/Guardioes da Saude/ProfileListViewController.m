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
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    

}

- (void)  viewWillAppear:(BOOL)animated{
    user = [User getInstance];
    [self.btnMainUser setTitle:user.nick forState:UIControlStateNormal];
    
    NSString *avatar;
    
    if ([user.picture isEqualToString:@"0"]) {
        avatar = @"img_profile01.png";
    } else {
        
        if (user.picture.length == 1) {
            avatar = [NSString stringWithFormat: @"img_profile0%@.png", user.picture];
        } else if (user.picture.length == 2) {
            avatar = [NSString stringWithFormat: @"img_profile%@.png", user.picture];
        }
    }
    
    [self.imgMainUser setBackgroundImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
    
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
        
        NSString *idHousehold = household.idHousehold;
        NSString *url = [NSString stringWithFormat: @"http://api.guardioesdasaude.org/household/delete/%@?client=api", idHousehold];
        
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
    [profileFormViewController setOperation:EDIT_USER];
    [profileFormViewController setUser:user];
    
    [self.navigationController pushViewController:profileFormViewController animated:YES];
}

- (IBAction)btnAddHousehold:(id)sender {
    ProfileFormViewController *profileFormViewController = [[ProfileFormViewController alloc] init];
    [profileFormViewController setOperation:ADD_HOUSEHOLD];
    
    [self.navigationController pushViewController:profileFormViewController animated:YES];
}

- (void) loadHouseholds {
    [householdeRequest getHouseholdsByUser:user onSuccess:^(NSMutableArray *householdes){
        users = [[NSMutableArray alloc] initWithArray:householdes];
        [self.tableViewProfile reloadData];
    }onFail:^(NSError *error){
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
