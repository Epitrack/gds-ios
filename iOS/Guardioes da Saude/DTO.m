//
//  DTO.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "DTO.h"

static DTO *_getInstance = nil;

@implementation DTO

@synthesize string;
@synthesize data;

+ (DTO *)getInstance {
    
    static DTO *getInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        getInstance = [[self alloc] init];
    });
    
    return getInstance;
    
}

- (id)init{
    
    self = [super init];
    
    return self;
}

@end
