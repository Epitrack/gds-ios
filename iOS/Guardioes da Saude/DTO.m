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

+ (DTO *)getInstance {
    
    if(_getInstance == nil){
        
        @synchronized([DTO class]){
            _getInstance = [[DTO alloc] init];
        }
        
    }
    
    return _getInstance;
    
}

- (id)init{
    
    self = [super init];
    
    /*if (self) {
        string = @"";
    }*/
    
    return self;
    
}

@end
