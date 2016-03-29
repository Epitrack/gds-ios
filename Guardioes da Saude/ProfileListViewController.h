//
//  ProfileListViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 17/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *users;
}

@property bool showBack;

@property (weak, nonatomic) IBOutlet UITableView *tableViewProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnMainUser;
- (IBAction)btnEditMainUser:(id)sender;
- (IBAction)btnAddHousehold:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *imgMainUser;
- (IBAction)imgMainUserAction:(id)sender;

@end
