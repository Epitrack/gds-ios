//
//  Symptom.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 27/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Symptom.h"

@implementation Symptom

- (id) initWithName:(NSString *)name andCode:(NSString *)code {
    
    if (self == [super init]) {
        self.name = name;
        self.code = code;
    }
    
    return self;
}

@end
