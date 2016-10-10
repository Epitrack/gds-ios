//
//  ViewUtil.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/15/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "ViewUtil.h"
#import <UIKit/UIKit.h>

@implementation ViewUtil

+(UIAlertController *)showAlertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"constant.ok", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    
    return alert;
}

+(UIAlertController *)showNoConnectionAlert{
    return [self showAlertWithMessage:NSLocalizedString(@"constant.no_conection", @"")];
}

+ (NSMutableAttributedString *) applyFont: (UIFont *) font withColor: (UIColor *) color ranges: (NSArray *) ranges atTextView: (UITextView *) textView{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                                  color, NSForegroundColorAttributeName, nil];
    
    [attributedString setAttributedString:textView.attributedText];
    
    for (NSString *range in ranges) {
        NSRange rangeBold = [textView.text rangeOfString:range];
        [attributedString setAttributes:dictBoldText range: rangeBold];
    }
    
    textView.attributedText = attributedString;
    
    return attributedString;
}
@end
