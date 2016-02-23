//
//  Notice.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Notice.h"

@implementation Notice

- (id) initWithName:(NSString *)title andSource:(NSString *)source andLink:(NSString *)link {
    
    if (self == [super init]) {
        self.title = title;
        self.source = source;
        self.link = link;
    }
    
    return self;
}

@end
