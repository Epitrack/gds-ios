//
//  Notice.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Notice.h"
#import "DateUtil.h"

@implementation Notice

- (id) initWithName:(NSString *)title andSource:(NSString *)source andLink:(NSString *)link {
    
    if (self == [super init]) {
        self.title = title;
        self.source = source;
        self.link = link;
    }
    
    return self;
}

- (void)setDateTime:(NSString *)strDateTime{
    // Date sample Fri Feb 26 18:00:25 +0000 2016
    
    NSDateFormatter *dateFormatter= [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    
    self.date = [dateFormatter dateFromString:strDateTime];
    NSDate *dateNow = [[NSDate alloc] init];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitHour
                                                        fromDate:self.date
                                                          toDate:dateNow
                                                         options:NSCalendarWrapComponents];
    
    self.hoursAgo = [NSNumber numberWithInteger:[components hour]];
}

@end
