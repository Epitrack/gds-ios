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
@interface ChangeLanguageViewController (){
    NSArray *languages;
}

@end

@implementation ChangeLanguageViewController

static NSBundle *bundle = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    languages = @[@"English", @"Español", @"Fraçais", @"pyccknñ", @"简体中文", @"العربية"];
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellCacheID];
    }
    
    cell.textLabel.text = [languages objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return languages.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];

//    [LocalizationSystem setLanguage:@"en"];
    
    HomeViewController *homeView = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:homeView animated:YES];
}


@end
