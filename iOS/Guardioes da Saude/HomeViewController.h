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
- (IBAction)btnJoinNow:(id)sender;
- (IBAction)btnMapHealth:(id)sender;
- (IBAction)notice:(id)sender;
- (IBAction)healthTips:(id)sender;
- (IBAction)diaryHealth:(id)sender;
- (IBAction)btnProfileAction:(id)sender;

@end
