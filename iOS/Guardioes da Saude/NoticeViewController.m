//
//  NoticeViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "NoticeViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "Notice.h"
#import "SingleNotice.h"

@interface NoticeViewController () {
    User *user;
    SingleNotice *singleNotice;
    NSMutableArray *notices;
}

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Notícias";
    user = [User getInstance];
    singleNotice = [SingleNotice getInstance];
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

- (void) loadNoticesOld {
    
    NSString *url = @"http://api.guardioesdasaude.org/news/get";
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *response = responseObject;
             NSDictionary *data = response[@"data"];
             NSMutableArray *statuses = data[@"statuses"];
             //JSONArray jsonArray = new JSONObject(jsonStr).getJSONObject("data").getJSONArray("statuses");
             
             for (NSDictionary *item in statuses) {
                 
                 NSString *text = item[@"text"];
                 NSString *source = @"via @minsaude";
                 NSString *link = [NSString stringWithFormat: @"https://twitter.com/minsaude/status/%@", item[@"id_str"]];
                 
                 Notice *notice = [[Notice alloc] initWithName:text andSource:source andLink:link];
                 
                 //[notices addObject:notice];
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"You pressed button OK");
         }];    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");
    
    return singleNotice.notices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    static NSString *cellNoticeCacheID = @"CellNoticeCacheID";
    UITableViewCell *cell = [self.tableViewNotice dequeueReusableCellWithIdentifier:cellNoticeCacheID];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellNoticeCacheID];
    }
    
    Notice *notice = [singleNotice.notices objectAtIndex:indexPath.row];
    
    UIFont *textFont = [UIFont fontWithName: @"Arial" size: 9.0];
    UIFont *detailFont = [UIFont fontWithName: @"Arial" size: 7.0];

    
    
    cell.tag = indexPath.row;
    cell.textLabel.font = textFont;
    cell.textLabel.text = notice.title;
    cell.detailTextLabel.font = detailFont;
    cell.detailTextLabel.text = notice.source;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Deseja abrir o link da notícia?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"SIM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button YES");
        
        Notice *openNotice = [notices objectAtIndex:indexPath.row];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openNotice.link]];
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"NÃO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button NO");
    }];
    [alert addAction:yesAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
