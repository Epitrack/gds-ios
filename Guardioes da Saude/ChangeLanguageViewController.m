//
//  ChangeLanguageViewController.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/4/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "ChangeLanguageViewController.h"
#import "HomeViewController.h"
#import "LocalizationSystem.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "TutorialViewController.h"

@interface ChangeLanguageViewController (){
    NSArray *languages;
    NSArray *languagesDetails;
    NSArray *languagesCode;
    NSString *currentLanguage;
}

@end

@implementation ChangeLanguageViewController

static NSBundle *bundle = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"change_language.title", @"");
    
    currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    languages = @[@"English", @"Español", @"Français", @"Português (Brasil)", @"pyccknñ", @"简体中文", @"العربية"];
    languagesDetails = @[@"Inglês", @"Espanhol", @"Francês", @"Portugues(Brasil)", @"Russo", @"Chinês (Tradicional)", @"Árabe"];
    languagesCode = @[@"en", @"es", @"fr", @"pt-BR", @"ru", @"zh-Hans-CN", @"ar"];
    
    if (!self.goToTutorial) {
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"constant.cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        btnCancel.tintColor = [UIColor colorWithRed:1 green:180.0/255.0 blue:0 alpha:1];
        self.navigationItem.leftBarButtonItem = btnCancel;
    }
    
    self.tableLanguages.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) cancelAction{
    HomeViewController *homeView = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:homeView animated:YES];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellCacheID = @"CellCacheID";
    UITableViewCell *cell = [self.tableLanguages dequeueReusableCellWithIdentifier:cellCacheID];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellCacheID];
    }
    
    cell.textLabel.text = [languages objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    cell.detailTextLabel.text = [languagesDetails objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1];
    cell.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    if ([[languagesCode objectAtIndex:indexPath.row] isEqualToString:currentLanguage]) {
        UIImageView *imgCheck = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"icon_selected"]];
        [imgCheck sizeToFit];
        cell.accessoryView = imgCheck;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return languages.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *newLanguage = [languagesCode objectAtIndex:indexPath.row];
    
    if ([currentLanguage isEqualToString: newLanguage]) {
        [self savePreference:newLanguage];
        if (self.goToTutorial) {
            TutorialViewController *tutorialViewCtrl = [[TutorialViewController alloc] init];
            [self.navigationController pushViewController:tutorialViewCtrl animated:YES];
        }else{
            [self cancelAction];
        }
    } else {
        [self changeLanguage:newLanguage];
    }
}

- (void)changeLanguage: (NSString *) newLanguagesCode{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                   message:NSLocalizedString(@"change_language.confirmation_msg", @"")
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.yes", @"")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          [self savePreference:newLanguagesCode];
                                                          exit(0);
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.no", @"")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         
                                                     }];
    
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)savePreference: (NSString *) newLanguagesCode{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults] ;
    [preferences setObject:[NSArray arrayWithObjects:newLanguagesCode, nil] forKey:@"AppleLanguages"];
    [preferences setObject:[NSArray arrayWithObjects:newLanguagesCode, nil] forKey:kCurrentLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
