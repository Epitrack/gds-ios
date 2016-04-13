//
//  HealthTipsViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 05/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HealthTipsViewController : UIViewController
- (IBAction)emergency:(id)sender;
- (IBAction)vacine:(id)sender;
- (IBAction)pharmacy:(id)sender;
- (IBAction)basicCare:(id)sender;
- (IBAction)prevention:(id)sender;
- (IBAction)phones:(id)sender;
- (IBAction)zika:(id)sender;
- (IBAction)travelerHealth:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *txZika;
@property (weak, nonatomic) IBOutlet UITextView *txEmergency;
@property (weak, nonatomic) IBOutlet UITextView *txVacine;
@property (weak, nonatomic) IBOutlet UITextView *txPhones;
@property (weak, nonatomic) IBOutlet UITextView *txPharmacy;
@property (weak, nonatomic) IBOutlet UITextView *txBasicCare;
@property (weak, nonatomic) IBOutlet UITextView *txPrevention;
@property (weak, nonatomic) IBOutlet UITextView *txSafeSex;
@property (weak, nonatomic) IBOutlet UITextView *txHealthTraveler;

@end
