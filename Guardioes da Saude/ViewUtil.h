//
//  ViewUtil.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/15/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewUtil : NSObject

+ (UIAlertController *) showAlertWithMessage: (NSString *) message;
+ (UIAlertController *) showNoConnectionAlert;
+ (NSMutableAttributedString *) applyFont: (UIFont *) font withColor: (UIColor *) color ranges: (NSArray *) ranges atTextView: (UITextView *) textView;
@end
