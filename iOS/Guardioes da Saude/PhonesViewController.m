//
//  PhonesViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 11/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "PhonesViewController.h"

@interface PhonesViewController () 
@end

@implementation PhonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Telefones Úteis";
    [self loadPhones];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadPhones {
    
    phones = [[NSMutableArray alloc] init];
    [phones addObject:@"SAMU"];
    [phones addObject:@"Polícia Militar"];
    [phones addObject:@"Bombeiros"];
    [phones addObject:@"Defesa Civil"];
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
    return phones.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    
    static NSString *cellSymptomCacheID = @"CellSymptomCacheID";
    UITableViewCell *cell = [self.tableViewPhones dequeueReusableCellWithIdentifier:cellSymptomCacheID];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellSymptomCacheID];
    }
    
    cell.tag = indexPath.row;
    cell.textLabel.text = [phones objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"iconSamuMini.png"];
        cell.detailTextLabel.text = @"192";
    } else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"iconPMMini.png"];
        cell.detailTextLabel.text = @"190";
    } else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"iconBombeirosMini.png"];
        cell.detailTextLabel.text = @"193";
    } else if (indexPath.row == 3) {
            cell.imageView.image = [UIImage imageNamed:@"iconDefesacivilMini.png"];
        cell.detailTextLabel.text = @"0800 644 0199";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    NSString *text;
    
    if (indexPath.row == 0) {
        text = @"Ligag para o SAMU";
    } else if (indexPath.row == 1) {
        text = @"Ligar para a Polícia Militar";
    } else if (indexPath.row == 2) {
        text = @"Ligar para os Bombeiros";
    } else if (indexPath.row == 3) {
        text = @"Ligar para a Defesa Civil";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:text preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"SIM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button YES");
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:192"]];
        } else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:190"]];
        } else if (indexPath.row == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:193"]];
        } else if (indexPath.row == 3) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:08006440199"]];
        }
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"NÃO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button NO");
    }];
    [alert addAction:yesAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

    
}
@end
