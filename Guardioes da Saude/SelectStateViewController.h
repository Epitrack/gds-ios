//
//  SelectStateViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 26/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SelectStateViewController : UIViewController <CLLocationManagerDelegate>
- (IBAction)btnGood:(id)sender;
- (IBAction)btnBad:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txHeader;
@property (weak, nonatomic) IBOutlet UITextView *txFooter;

@end
