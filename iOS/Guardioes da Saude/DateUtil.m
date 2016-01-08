//
//  DateUtil.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 28/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSDate *) dateFromString: (NSString *) strDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    if (strDate != nil && ![strDate isEqualToString:@""]) {
        return [formatter dateFromString:strDate];
    }
    
    return nil;
}

+ (NSDate *) dateFromStringUS: (NSString *) strDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (strDate != nil && ![strDate isEqualToString:@""]) {
        return [formatter dateFromString:[strDate substringToIndex:10]];
    }
    
    return nil;
}

+ (NSString *) stringFromDate: (NSDate *) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    if (date != nil) {
        return [formatter stringFromDate:date];
    }
    
    return nil;
}

+ (NSString *) stringUSFromDate: (NSDate *) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (date != nil) {
        return [formatter stringFromDate:date];
    }
    
    return nil;
}

+(NSInteger) getCurrentYear{
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
}

+(NSInteger) diffInDaysDate: (NSDate *) startDate andDate: (NSDate *) endDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    return [components day];
}

@end
