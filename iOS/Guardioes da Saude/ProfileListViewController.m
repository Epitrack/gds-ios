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
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    user = [User getInstance];
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
    
    //[users addObject:user];
    
    if (households.count > 0) {
        for (NSDictionary *h in households) {
            
            NSString *nick = h[@"nick"];
            NSString *picture = h[@"picture"];
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
            
            Household *household = [[Household alloc] initWithNick:nick andDob:@"" andGender:@"" andRace:@"" andIdUser:@"" andPicture:avatar andIdHousehold:@""];
        
            [users addObject:household];
        }
    }
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

@end
