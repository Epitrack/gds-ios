//
//  SingleNotice.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 01/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SingleNotice.h"

@implementation SingleNotice

@synthesize notices;

+ (SingleNotice *)getInstance {
    
    static SingleNotice *getInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        getInstance = [[self alloc] init];
    });
    
    return getInstance;
}

- (id)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

@end
