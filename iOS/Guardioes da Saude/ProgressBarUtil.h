//
//  ProgressBarUtil.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/4/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressBarUtil : NSObject

+(void) showProgressBarOnView: (UIView *) view;
+(void) hiddenProgressBarOnView: (UIView *) view;

@end
