//
//  HomeViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 14/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *txtNameUser;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnStartTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnStartTrailingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnStartLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnStartWithConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnJoinTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnNewTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnNewsLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTipsLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTipsTopConst;


- (IBAction)btnProfileAction:(id)sender;
- (IBAction)btnStartAction:(id)sender;
@end
