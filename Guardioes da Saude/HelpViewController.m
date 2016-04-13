//
//  HelpViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 13/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "HelpViewController.h"
#import "SWRevealViewController.h"
#import "TermsViewController.h"
#import "TutorialViewController.h"
#import "ReportViewController.h"
#import "ViewUtil.h"
#import "Requester.h"
#import <Google/Analytics.h>

@interface HelpViewController (){
    NSArray *options;
    NSArray *optionsIcons;
    NSArray *contactUs;
    NSArray *contactUsIcons;
}

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Ajuda";
    
    self.navigationItem.hidesBackButton = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    options = @[NSLocalizedString(@"help.tutorial", @""), NSLocalizedString(@"help.terms", @"")];
    //@"iconHelpRelatar"
    optionsIcons = @[@"icon_helptutorial", @"icon_helpprivacy"];
    
    contactUs = @[@"Facebook", @"Twitter"];
    contactUsIcons = @[@"iconHelpFacebook", @"iconHelpTwitter"];
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Help Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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

- (void)btnTutorial {
    
    TutorialViewController *tutorialHelpViewController = [[TutorialViewController alloc] init];
    tutorialHelpViewController.hideButtons = YES;
    [self.navigationController pushViewController:tutorialHelpViewController animated:YES];
}

- (void)btnFacebook {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/minsaude"]];
}

- (void)btnTwitter {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/minsaude"]];
}

- (void)btnTerms {
    
    TermsViewController *termsViewController = [[TermsViewController alloc] init];
    [self.navigationController pushViewController:termsViewController animated:YES];
}

- (void)btnReport {
    if([Requester isConnected]){
    ReportViewController *reportViewController = [[ReportViewController alloc] init];
    [self.navigationController pushViewController:reportViewController animated:YES];
    }else{
        [self presentViewController:[ViewUtil showNoConnectionAlert] animated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0){
        return 2;
    }else if(section==1){
        return 2;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return NSLocalizedString(@"help.options", @"");
    else if (section == 1)
        return NSLocalizedString(@"help.contact_us", @"");
    else
        return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section==0) {
        cell.imageView.image = [UIImage imageNamed:optionsIcons[indexPath.row]];
        cell.textLabel.text = options[indexPath.row];
    }else if (indexPath.section==1){
        cell.imageView.image = [UIImage imageNamed:contactUsIcons[indexPath.row]];
        cell.textLabel.text = contactUs[indexPath.row];
    }else {
        cell.imageView.image = [UIImage imageNamed:@"icon_helprelatar"];
        cell.textLabel.text = NSLocalizedString(@"help.report_bug", @"");
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self btnTutorial];
        }else{
            [self btnTerms];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self btnFacebook];
        }else{
            [self btnTwitter];
        }
    }else{
        [self btnReport];
    }
}
@end
