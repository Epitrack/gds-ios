//
//  AboutViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 13/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbVersion;
@property (weak, nonatomic) IBOutlet UILabel *lbBuild;
@property (weak, nonatomic) IBOutlet UITextView *txtAbout;

@end
