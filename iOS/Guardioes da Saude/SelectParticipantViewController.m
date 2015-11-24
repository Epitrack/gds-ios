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

@interface SelectParticipantViewController ()

@end

@implementation SelectParticipantViewController {
    
    User *user;
    NSMutableDictionary *householdsDictionary;
    NSInteger *i;
}

const float kCellHeight = 100.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Guardiões da Saúde";
    user = [User getInstance];
    
    NSMutableDictionary *householdsDictionary = [[NSMutableDictionary alloc] init];
    i = 0;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    //CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //create table view to contain ASHorizontalScrollView
    
    sampleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenHeight-100, self.view.frame.size.width, self.view.frame.size.height)];
    sampleTableView.delegate = self;
    sampleTableView.dataSource = self;
    sampleTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:sampleTableView];
    
    self.txtNameMainMember.text = user.nick;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    
    NSString *dobUser = [user.dob componentsSeparatedByString:@"-"][0];
    NSString *currentDate = [format stringFromDate:[NSDate date]];
    NSInteger ageUser= [currentDate intValue] - [dobUser intValue];
    
    self.txtDobMainMember.text = [NSString stringWithFormat:@"%ld Anos", (long)ageUser];
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
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        if (indexPath.row == 0) {
            //sample code of how to use this scroll view
            ASHorizontalScrollView *horizontalScrollView = [[ASHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight)];
            [cell.contentView addSubview:horizontalScrollView];
            horizontalScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            horizontalScrollView.uniformItemSize = CGSizeMake(100, 100);
            //this must be called after changing any size or margin property of this class to get acurrate margin
            [horizontalScrollView setItemsMarginOnce];
            NSMutableArray *buttons = [NSMutableArray array];
            NSDictionary *households = user.household;
            
            if (households.count > 0) {
                
                for (NSDictionary *h in households) {
                    
                    NSString *nick = h[@"nick"];
                    NSString *picture = h[@"picture"];
                    NSString *avatar;
                    NSString *idHousehold = h[@"id"];
                    
                    @try {
                        if (picture.length > 2) {
                            avatar = @"img_profile01";
                        }
                    }@catch (NSException *exception) {
                        
                        NSString *p = [NSString stringWithFormat:@"%@", picture];
                        
                        if (p.length == 1) {
                            avatar = [NSString stringWithFormat: @"img_profile0%@", p];
                        } else if (p.length == 2) {
                            avatar = [NSString stringWithFormat: @"img_profile%@", p];
                        }
                    }
                    
                    HouseholdThumbnail *thumb = [[HouseholdThumbnail alloc] initWithHousehold:idHousehold frame:CGRectMake(0, 0, 150, 150) avatar:avatar nick:nick];
                    [buttons addObject:thumb];
                    [thumb.button addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                if (buttons.count > 0) {
                    [horizontalScrollView addItems:buttons];
                }
            }
        }
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


@end