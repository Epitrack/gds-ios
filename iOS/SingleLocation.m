//
//  SingleLocation.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 07/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SingleLocation.h"

@implementation SingleLocation

@synthesize lat;
@synthesize lon;

+ (SingleLocation *)getInstance {
    
    static SingleLocation *getInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        getInstance = [[self alloc] init];
    });
    
    return getInstance;
}

@end
