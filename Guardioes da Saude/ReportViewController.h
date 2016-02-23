//
//  ReportViewController.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController
- (IBAction)btSendReport:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;

@end
