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
@property (strong, nonatomic) IBOutlet UITextView *txtNameUser;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
- (IBAction)btnJoinNow:(id)sender;
- (IBAction)btnMapHealth:(id)sender;
- (IBAction)notice:(id)sender;
- (IBAction)healthTips:(id)sender;

@end
