//
//  SelectParticipantViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 26/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectParticipantViewController.h"
#import "User.h"
#import "SelectStateViewController.h"
#import "Household.h"
#import "HouseholdThumbnail.h"
#import "DateUtil.h"
#import <Google/Analytics.h>
#import "HouseholdRequester.h"
#import "MBProgressHUD.h"
#import "ProfileFormViewController.h"
@import Photos;

@interface SelectParticipantViewController ()

@end

@implementation SelectParticipantViewController {
    HouseholdRequester *houseHoldRequester;
    User *user;
    NSMutableDictionary *householdsDictionary;
    NSInteger *i;
}

const float kCellHeight = 100.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"select_participant.title", @"");
    user = [User getInstance];
    houseHoldRequester = [[HouseholdRequester alloc] init];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //create table view to contain ASHorizontalScrollView
    
    sampleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenHeight-95, screenWidth, screenHeight)];
    sampleTableView.delegate = self;
    sampleTableView.dataSource = self;
    sampleTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sampleTableView.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
    sampleTableView.alwaysBounceVertical = NO;
    [self.view addSubview:sampleTableView];
    
    self.txtNameMainMember.text = user.nick;
    
    NSDate *dateDob = [DateUtil dateFromStringUS:user.dob];
    long days = [DateUtil diffInDaysDate:dateDob andDate:[[NSDate alloc] init]];
    long ageUser = days/360;
    
    self.txtDobMainMember.text = [NSString stringWithFormat:NSLocalizedString(@"select_participant.year_old", @""), (long)ageUser];
    [self loadAvatar];
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Select Participant Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self loadHouseHolds];
}

- (void) loadAvatar {
    [user setAvatarImageAtButton:self.imgMainMember orImageView:nil];
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

- (IBAction)btnSelectMainMember:(id)sender {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_select_main_user"
                                                           label:@"Select Main User"
                                                           value:nil] build]];
    
    
    SelectStateViewController *selectStateViewController = [[SelectStateViewController alloc] init];
    [self.navigationController pushViewController:selectStateViewController animated:YES];
}

#pragma tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    //sample code of how to use this scroll view
    ASHorizontalScrollView *horizontalScrollView = [[ASHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight)];
    [cell.contentView addSubview:horizontalScrollView];
    horizontalScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    horizontalScrollView.uniformItemSize = CGSizeMake(136, 100);
    //this must be called after changing any size or margin property of this class to get acurrate margin
    [horizontalScrollView setItemsMarginOnce];
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *households = user.household;
    
    HouseholdThumbnail *thumb = [[HouseholdThumbnail alloc] initWithHousehold:nil frame:CGRectMake(0, 0, 150, 150) avatar:@"icon_addmember" nick:NSLocalizedString(@"select_participant.new_member", @"")];
    [buttons addObject:thumb];
    [thumb.button addTarget:self action:@selector(addNewMember) forControlEvents:UIControlEventTouchUpInside];
    
        
    for (Household *h in households) {
        
        NSString *nick = h.nick;
        NSString *picture = h.picture;
        NSString *avatar;
        NSString *idHousehold = h.idHousehold;
        
        //picture = @"0";
        
        if ([picture isEqualToString:@"0"]) {
            avatar = @"img_profile01.png";
        } else {
            if (picture.length == 1) {
                avatar = [NSString stringWithFormat: @"img_profile0%@.png", picture];
            } else if (picture.length == 2) {
                avatar = [NSString stringWithFormat: @"img_profile%@.png", picture];
            } else if (picture.length > 2) {
                avatar = picture;
            }
        }
        
        HouseholdThumbnail *thumb = [[HouseholdThumbnail alloc] initWithHousehold:idHousehold frame:CGRectMake(0, 0, 150, 150) avatar:avatar nick:nick];
        [buttons addObject:thumb];
        [thumb.button addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (buttons.count > 0) {
        if ([UIScreen mainScreen].bounds.size.width >= 375 ) {
            UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 150)];
            [buttons addObject:blankView];
        }
        [horizontalScrollView addItems:buttons];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void) pushAction: (id)sender{
    NSLog(@"Clicou");
    UIButton *b = (UIButton *) sender;
    HouseholdThumbnail *thumb = (HouseholdThumbnail*) b.superview;
    NSString *idHousehold = thumb.user_household_id;
    NSLog(@"id %@", idHousehold);
    
    user.idHousehold = idHousehold;
    SelectStateViewController *selectStateViewController = [[SelectStateViewController alloc] init];
    [self.navigationController pushViewController:selectStateViewController animated:YES];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
}

- (void) loadHouseHolds{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [houseHoldRequester getHouseholdsByUser:user onSuccess:^(NSMutableArray *houseHolds){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        user.household = houseHolds;
        [sampleTableView reloadData];
    } onFail:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void) addNewMember{
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

@end
