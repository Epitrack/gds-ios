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
#import "NoticeRequester.h"
#import "Notice.h"
#import "SingleNotice.h"
#import <Google/Analytics.h>
#import "MBProgressHUD.h"
#import "ViewUtil.h"
#import "NoticeTableViewCell.h"
#import "DateUtil.h"

@interface NoticeViewController () {
    User *user;
    SingleNotice *singleNotice;
    NSMutableArray *notices;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Notícias";
    user = [User getInstance];
    singleNotice = [SingleNotice getInstance];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    [self loadNotices];
    
    self.tableViewNotice.separatorColor = [UIColor clearColor];
}

- (void) loadNotices {
    
    [[[NoticeRequester alloc] init] getNotices:user
                                       onStart:^{
                                           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                       }
                                       onError:^(NSError * error){
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           
                                           NSString *errorMsg;
                                           if (error && error.code == -1009) {
                                               errorMsg = kMsgConnectionError;
                                           } else {
                                               errorMsg = kMsgApiError;
                                           }
                                           
                                           [self presentViewController:[ViewUtil showAlertWithMessage:errorMsg] animated:YES completion:nil];
                                       }
                                     onSuccess:^(NSMutableArray *noticesRequest){
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         
                                         singleNotice.notices = noticesRequest;
                                         [self.tableViewNotice reloadData];
                                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Notice Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");
    
    return singleNotice.notices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    static NSString *simpleTableIdentifier = @"NoticeTableViewCell";
    
    NoticeTableViewCell *cell = (NoticeTableViewCell *)[self.tableViewNotice dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Notice *notice = [singleNotice.notices objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.imgInitTimeLine.hidden = YES;
    }
    
    cell.lbDescription.text = notice.title;
    cell.lbDate.text = [DateUtil stringFromDate:notice.date];
    cell.lbLikes.text = [NSString stringWithFormat:@"%d", [notice.favoreted intValue]];
    cell.lbHoursAgo.text = [NSString stringWithFormat:@"%dh", [notice.hoursAgo intValue]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:@"Deseja abrir o link da notícia?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"SIM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button YES");
        
        Notice *openNotice = [singleNotice.notices objectAtIndex:indexPath.row];
        NSString *url = openNotice.link;
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"NÃO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button NO");
    }];
    [alert addAction:yesAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}



@end
