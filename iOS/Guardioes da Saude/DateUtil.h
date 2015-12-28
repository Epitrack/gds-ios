//
//  DateUtil.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 28/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSDate *) dateFromString: (NSString *) strDate;
+ (NSString *) stringFromDate: (NSDate *) date;
+ (NSString *) stringUSFromDate: (NSDate *) date;

@end
