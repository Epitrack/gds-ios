//
//  NoticeViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
@property (strong, nonatomic) IBOutlet UITableView *tableViewNotice;

@end
