//
//  SurveyMap.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 29/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SurveyMap.h"

@implementation SurveyMap

- (id) initWithLatitude:(NSString *) latitude andLongitude:(NSString *) longitude andSymptom:(NSString *) isSymptom {
    
    if (self == [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.isSymptom = isSymptom;
    }
    
    return self;
}

@end
