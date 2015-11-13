//
//  TutorialHelpViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 13/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialHelpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgBgTutorial;
@property (strong, nonatomic) IBOutlet UIImageView *imgTutorial;
@property NSInteger indexTutorial;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtTitle;

@end
