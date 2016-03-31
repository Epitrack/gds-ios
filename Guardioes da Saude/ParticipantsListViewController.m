//
//  ParticipantsListViewController.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/30/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "ParticipantsListViewController.h"
#import "HouseholdRequester.h"
#import "MBProgressHUD.h"

@interface ParticipantsListViewController (){
    HouseholdRequester *householdeRequest;
    NSMutableArray *households;
    User *user;
}

@end

@implementation ParticipantsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    householdeRequest = [[HouseholdRequester alloc] init];
    user = [User getInstance];
    
    self.navigationItem.title = @"Selecionar Integrante";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadHouseholds];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return households.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellCacheID = @"CellCacheID";
    UITableViewCell *cell = [self.tableParticipants dequeueReusableCellWithIdentifier:cellCacheID];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellCacheID];
    }
    
    cell.tag = indexPath.row;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = user.nick;
        [user setAvatarImageAtButton:nil orImageView:cell.imageView];
    } else {
        Household *household = [households objectAtIndex:indexPath.row - 1];
        
        cell.textLabel.text = household.nick;
        cell.imageView.image = [UIImage imageNamed:household.picture];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.referenceDiaryHealthView refreshInformationToUser:nil];
    } else {
        [self.referenceDiaryHealthView refreshInformationToUser:[households objectAtIndex:indexPath.row - 1]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadHouseholds {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [householdeRequest getHouseholdsByUser:user onSuccess:^(NSMutableArray *householdes){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        households = [[NSMutableArray alloc] initWithArray:householdes];
        [self.tableParticipants reloadData];
    }onFail:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Ocorreu um erro ao carregar os households");
    }];
}
@end
