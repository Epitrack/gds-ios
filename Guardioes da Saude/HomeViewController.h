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

@property NSBundle *localBundle;
@property (strong, nonatomic) IBOutlet UILabel *txtNameUser;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
<<<<<<< 08f4904e026d80f4327d74ba74c14b878716c28c

- (IBAction)btnNewsAction:(id)sender;
- (IBAction)btnProfileAction:(id)sender;
=======
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
>>>>>>> Creating home screen animation


- (IBAction)btnProfileAction:(id)sender;
- (IBAction)btnStartAction:(id)sender;
@end
