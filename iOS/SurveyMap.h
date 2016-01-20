//
//  SurveyMap.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 29/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyMap : NSObject

- (id) initWithLatitude:(NSString *) latitude andLongitude:(NSString *) longitude andSymptom:(NSString *) isSymptom;

@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) NSString *longitude;
@property(nonatomic, retain) NSString *isSymptom;
@property(nonatomic, retain) NSString *survey_id;
@property(nonatomic, retain) NSString *idHousehold;
@property(nonatomic, retain) NSString *travelLocation;
@property(nonatomic, retain) NSDictionary *symptoms;


@end
