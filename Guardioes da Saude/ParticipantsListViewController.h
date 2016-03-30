//
//  ParticipantsListViewController.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/30/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticipantsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableParticipants;

@end
