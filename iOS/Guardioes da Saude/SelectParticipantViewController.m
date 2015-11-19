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
                    
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                              CGRectMake(button.bounds.size.width/4,
                                                         5,
                                                         button.bounds.size.width/2,
                                                         button.bounds.size.height/2)];
                    
                    [imageView setImage:[UIImage imageNamed:avatar]];
                    
                    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(button.bounds.size.width/4, 50, button.bounds.size.width/2, button.bounds.size.height/2)];
                    label.text= nick;
                    label.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
                    label.textColor = [UIColor whiteColor];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    [label setFont:[UIFont fontWithName:@"Arial" size:10.0]];
                    //[label setValue:idHousehold forKey:idHousehold];
                    //[button addSubview:label];
                    //[button setTitle:idHousehold forState:UIControlStateNormal];
                    //[button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:10.0]];
                    //[button.titleLabel setTextAlignment: NSTextAlignmentCenter];
                    //[button addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
                    [button addSubview:imageView];
                    //i++;
                    //[button setTag:*(i)];
                    
                    [buttons addObject:button];
                    [householdsDictionary setValue:idHousehold forKey:[NSString stringWithFormat: @"%ld", (long)i]];
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
    UIButton *button = (UIButton*) sender;
    NSString *idHousehold = [householdsDictionary objectForKey:[NSString stringWithFormat: @"%ld", (long)button.tag]];
    NSLog(@"id %@", idHousehold);
    //button.
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
}


@end
