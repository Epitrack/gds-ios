//
//  MenuViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 06/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgHome;
@property (weak, nonatomic) IBOutlet UILabel *lbHome;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lbProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgAbout;
@property (weak, nonatomic) IBOutlet UILabel *lbAbout;
@property (weak, nonatomic) IBOutlet UIImageView *imgHelp;
@property (weak, nonatomic) IBOutlet UILabel *lbHelp;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignout;
@property (weak, nonatomic) IBOutlet UILabel *lbSignout;
- (IBAction)btnHome:(id)sender;
- (IBAction)btnAbout:(id)sender;
- (IBAction)btnHelp:(id)sender;
- (IBAction)btnProfile:(id)sender;
- (IBAction)btnExit:(id)sender;
- (void) setHomeSelected;
- (void) doLogout;
- (IBAction)btnFacebookAction:(id)sender;
- (IBAction)btnTwitterAction:(id)sender;

+ (MenuViewController *)getInstance;
- (IBAction)btnLanguageAction:(id)sender;

@end
