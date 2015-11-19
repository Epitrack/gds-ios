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
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtTitle;
- (IBAction)btnEnter:(id)sender;
- (IBAction)btnNewUser:(id)sender;

@end
