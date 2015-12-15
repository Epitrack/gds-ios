//
//  Phones.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Phones.h"

@implementation Phones

@synthesize lbHeader;
@synthesize imgDetail;
@synthesize lbBody;
@synthesize lbDetailBody;
@synthesize lbPhone;

+ (Phones *)getInstance {
    
    static Phones *getInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        getInstance = [[self alloc] init];
    });
    
    return getInstance;
}

@end
