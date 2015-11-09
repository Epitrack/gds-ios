//
//  SelectParticipantViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 26/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASHorizontalScrollView.h"

@interface SelectParticipantViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *sampleTableView;
}
@property (strong, nonatomic) IBOutlet UIButton *imgMainMember;
- (IBAction)btnSelectMainMember:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *txtDobMainMember;
@property (strong, nonatomic) IBOutlet UITextView *txtNameMainMember;

@end
