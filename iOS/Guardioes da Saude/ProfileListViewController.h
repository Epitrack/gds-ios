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
@property (weak, nonatomic) IBOutlet UITableView *tableViewProfile;

@end
