//
//  Notice.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject

- (id) initWithName:(NSString *) title andSource:(NSString *) source andLink:(NSString *)
link;

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *source;
@property(nonatomic, retain) NSString *link;
@property(nonatomic, retain) NSNumber *favoreted;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) NSNumber *hoursAgo;

- (void) setDateTime: (NSString *) strDateTime;

@end
