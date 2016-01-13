//
//  TutorialViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 06/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgBgTutorial;
@property (strong, nonatomic) IBOutlet UIImageView *imgTutorial;
@property NSInteger indexTutorial;
@property (strong, nonatomic) IBOutlet UILabel *txtDescription;
@property (strong, nonatomic) IBOutlet UILabel *txtTitle;
- (IBAction)btnEnter:(id)sender;
- (IBAction)btnNewUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *lbDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraint;


@end
