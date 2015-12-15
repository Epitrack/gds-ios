//
//  PhonesViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 11/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "PhonesViewController.h"
#import "DetailPhoneViewController.h"
#import "Phones.h"

@interface PhonesViewController () {
    
    //Phones *phones;
}
@end

@implementation PhonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Dicas de Saúde";
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    
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
    
    static NSString *cellCacheID = @"CellCacheID";
    UITableViewCell *cell = [self.tableViewPhones dequeueReusableCellWithIdentifier:cellCacheID];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellCacheID];
    }
    
    cell.tag = indexPath.row;
    cell.textLabel.text = [phones objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        //cell.imageView.image = [UIImage imageNamed:@"iconSamuMini.png"];
        cell.detailTextLabel.text = @">";
    } else if (indexPath.row == 1) {
        //cell.imageView.image = [UIImage imageNamed:@"iconPMMini.png"];
        cell.detailTextLabel.text = @">";
    } else if (indexPath.row == 2) {
        //cell.imageView.image = [UIImage imageNamed:@"iconBombeirosMini.png"];
        cell.detailTextLabel.text = @">";
    } else if (indexPath.row == 3) {
        //cell.imageView.image = [UIImage imageNamed:@"iconDefesacivilMini.png"];
        cell.detailTextLabel.text = @">";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    //NSString *text;
    
    
    
    if (indexPath.row == 0) {
        //text = @"Ligag para o SAMU";
        Phones *phones = [Phones getInstance];
        phones.lbHeader = @"SAMU";
        phones.lbBody = @"SAMU";
        phones.lbDetailBody = @"Serviço de Atendimento Médico de ";
        phones.lbPhone = @"192";
        phones.imgDetail = @"iconSamu.png";
    } else if (indexPath.row == 1) {
        //text = @"Ligar para a Polícia Militar";
        Phones *phones = [Phones getInstance];
        phones.lbHeader = @"Polícia Militar";
        phones.lbBody = @"Polícia Militar";
        phones.lbDetailBody = @"";
        phones.lbPhone = @"192";
        phones.imgDetail = @"iconPM.png";
    } else if (indexPath.row == 2) {
        //text = @"Ligar para os Bombeiros";
        Phones *phones = [Phones getInstance];
        phones.lbHeader = @"Bombeiros";
        phones.lbBody = @"Bombeiros";
        phones.lbDetailBody = @"";
        phones.lbPhone = @"192";
        phones.imgDetail = @"iconBombeiros.png";
    } else if (indexPath.row == 3) {
        //text = @"Ligar para a Defesa Civil";
        Phones *phones = [Phones getInstance];
        phones.lbHeader = @"Defesa Civil";
        phones.lbBody = @"Defesa Civil";
        phones.lbDetailBody = @"";
        phones.lbPhone = @"192";
        phones.imgDetail = @"iconDefesacivil.png";
    }
    
    DetailPhoneViewController *detailPhoneViewController = [[DetailPhoneViewController alloc] init];
    [self.navigationController pushViewController:detailPhoneViewController animated:YES];
    
    /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde" message:text preferredStyle:UIAlertControllerStyleActionSheet];
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
    [self presentViewController:alert animated:YES completion:nil];*/

    
}
@end
