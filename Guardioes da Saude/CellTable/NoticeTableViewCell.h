//
//  NoticeTableViewCell.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 2/26/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgInitTimeLine;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbDescription;
@property (weak, nonatomic) IBOutlet UILabel *lbLikes;
@property (weak, nonatomic) IBOutlet UILabel *lbHoursAgo;

@end
