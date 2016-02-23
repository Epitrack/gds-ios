//
//  DetailPhoneViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "ViewController.h"

@interface DetailPhoneViewController : ViewController
@property (weak, nonatomic) IBOutlet UILabel *lbHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbBody;
@property (weak, nonatomic) IBOutlet UILabel *lbDetailBody;
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;
- (IBAction)btnCallAction:(id)sender;



@end
