//
//  DetailMap.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 03/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailMap : NSObject {
    
    NSString *city;
    NSString *state;
    NSString *totalSurvey;
    NSString *totalNoSymptom;
    NSString *goodPercent;
    NSString *totalWithSymptom;
    NSString *badPercent;
    NSString *diarreica;
    NSString *exantemaica;
    NSString *respiratoria;
}

+(DetailMap *) getInstance;

@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSString *totalSurvey;
@property(nonatomic, retain) NSString *totalNoSymptom;
@property(nonatomic, retain) NSString *goodPercent;
@property(nonatomic, retain) NSString *totalWithSymptom;
@property(nonatomic, retain) NSString *badPercent;
@property(nonatomic, retain) NSString *diarreica;
@property(nonatomic, retain) NSString *exantemaica;
@property(nonatomic, retain) NSString *respiratoria;

@end
