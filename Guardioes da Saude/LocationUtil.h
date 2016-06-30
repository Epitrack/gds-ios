//
//  StateUtil.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/3/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationUtil : NSObject

+ (NSString *) getStateByUf: (NSString *) uf;
+ (void) getLocationByAddress: (NSString *) address
                    onSuccess: (void(^)(NSString *lng, NSString *lat, NSString *fullNameCity)) success
                       onFail: (void(^)(NSError *error)) fail;

+ (void) loadPharmacyWithLat:(double) lat
                      andLog:(double) log
                andOnSuccess:(void(^)(NSArray *)) onSuccess
                  andOnError:(void(^)(NSError *)) onError;

+ (NSArray *) getCountriesWithBrazil: (bool) withBrazil;

+ (NSArray *) getStates;

+ (NSString *) getCountryNameToEnglish: (NSString *) countryStr;

+ (NSString *) getCountryNameToCurrentLocale: (NSString *) countryStr;

@end
