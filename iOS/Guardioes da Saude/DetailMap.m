//
//  DetailMap.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 03/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "DetailMap.h"

@implementation DetailMap

@synthesize city;
@synthesize state;
@synthesize totalSurvey;
@synthesize totalNoSymptom;
@synthesize goodPercent;
@synthesize totalWithSymptom;
@synthesize badPercent;
@synthesize diarreica;
@synthesize exantemaica;
@synthesize respiratoria;

+ (DetailMap *)getInstance {
    
    static DetailMap *getInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        getInstance = [[self alloc] init];
    });
    
    return getInstance;
}

- (id) init {
    return self;
}

@end
