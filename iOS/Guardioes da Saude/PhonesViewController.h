//
//  PhonesViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 11/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhonesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

    NSMutableArray *phones;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewPhones;

@end
