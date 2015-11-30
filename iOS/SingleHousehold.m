//
// Created by Miqueias Lopes on 27/11/15.
// Copyright (c) 2015 epitrack. All rights reserved.
//

#import "SingleHousehold.h"


@implementation SingleHousehold

@synthesize nick;
@synthesize email;
@synthesize password;
@synthesize client;
@synthesize dob;
@synthesize gender;
@synthesize race;
@synthesize idUser;
@synthesize picture;
@synthesize id;

+ (SingleHousehold *)getInstance {

    static SingleHousehold *getInstance = nil;
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