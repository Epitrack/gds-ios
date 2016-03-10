//
//  StateUtil.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/3/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "LocationUtil.h"
#import "AFNetworking/AFNetworking.h"
#import <MapKit/MapKit.h>

@implementation LocationUtil

NSString *const googleUrl = @"https://maps.googleapis.com/maps/api";

+ (NSString *) getStateByUf: (NSString *) uf{
        
    NSString *stateDiscription;
    
    if ([uf isEqualToString:@"AC"]) {
        stateDiscription = @"Acre";
    } else if ([uf isEqualToString:@"AL"]) {
        stateDiscription = @"Alagoas";
    } else if ([uf isEqualToString:@"AP"]) {
        stateDiscription = @"Amapá";
    } else if ([uf isEqualToString:@"AM"]) {
        stateDiscription = @"Amazonas";
    } else if ([uf isEqualToString:@"BA"]) {
        stateDiscription = @"Bahia";
    } else if ([uf isEqualToString:@"CE"]) {
        stateDiscription = @"Ceará";
    } else if ([uf isEqualToString:@"DF"]) {
        stateDiscription = @"Distrito Federal";
    } else if ([uf isEqualToString:@"ES"]) {
        stateDiscription = @"Espirito Santo";
    } else if ([uf isEqualToString:@"GO"]) {
        stateDiscription = @"Goiás";
    } else if ([uf isEqualToString:@"MA"]) {
        stateDiscription = @"Maranhão";
    } else if ([uf isEqualToString:@"MT"]) {
        stateDiscription = @"Mato Grosso";
    } else if ([uf isEqualToString:@"MS"]) {
        stateDiscription = @"Mato Grosso do Sul";
    } else if ([uf isEqualToString:@"MG"]) {
        stateDiscription = @"Minas Gerais";
    } else if ([uf isEqualToString:@"PR"]) {
        stateDiscription = @"Paraná";
    } else if ([uf isEqualToString:@"PB"]) {
        stateDiscription = @"Paraiba";
    } else if ([uf isEqualToString:@"PA"]) {
        stateDiscription = @"Pará";
    } else if ([uf isEqualToString:@"PE"]) {
        stateDiscription = @"Pernambuco";
    } else if ([uf isEqualToString:@"PI"]) {
        stateDiscription = @"Piauí";
    } else if ([uf isEqualToString:@"RJ"]) {
        stateDiscription = @"Rio de Janeiro";
    } else if ([uf isEqualToString:@"RN"]) {
        stateDiscription = @"Rio Grande do Norte";
    } else if ([uf isEqualToString:@"RS"]) {
        stateDiscription = @"Rio Grande do Sul";
    } else if ([uf isEqualToString:@"RO"]) {
        stateDiscription = @"Rondônia";
    } else if ([uf isEqualToString:@"RR"]) {
        stateDiscription = @"Roraima";
    } else if ([uf isEqualToString:@"SC"]) {
        stateDiscription = @"Santa Catarina";
    } else if ([uf isEqualToString:@"SE"]) {
        stateDiscription = @"Sergipe";
    } else if ([uf isEqualToString:@"SP"]) {
        stateDiscription = @"São Paulo";
    } else if ([uf isEqualToString:@"TO"]) {
        stateDiscription = @"Tocantins";
    }
    
    return stateDiscription;
}

+ (void) getLocationByAddress: (NSString *) address
                    onSuccess: (void(^)(NSString *lng, NSString *lat, NSString *fullNameCity)) success
                       onFail: (void(^)(NSError *error)) fail{
    
    AFHTTPRequestOperationManager *manager;
    
    NSDictionary *params = @{@"address": [address stringByAppendingString:@"-BR"],
                             @"key": @"AIzaSyDRoA88MUJbF8TFPnaUXHvIrQzGPU5JC94"};
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/geocode/json", googleUrl ]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *location = responseObject[@"results"][0][@"geometry"][@"location"];
             NSString *lng = location[@"lng"];
             NSString *lat = location[@"lat"];
             NSString *fullNameCity = responseObject[@"results"][0][@"address_components"][0][@"long_name"];
             
             success(lng, lat, fullNameCity);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             fail(error);
         }];
    
}

+ (void)loadPharmacyWithLat:(double)lat andLog:(double)log andOnSuccess:(void (^)(NSArray *))onSuccess andOnError:(void (^)(NSError *))onError{
    
    NSDictionary *params = @{@"query": @"pharmacy",
                             @"location": [NSString stringWithFormat:@"%f,%f", lat, log],
                             @"radius": @"10000",
                             @"key": @"AIzaSyDYl7spN_NpAjAWL7Hi183SK2cApiIS3Eg"};
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/place/textsearch/json", googleUrl ]
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *results = responseObject[@"results"];
             NSMutableArray *pins = [[NSMutableArray alloc] init];
             
             for (NSDictionary *item in results) {
                 
                 NSDictionary *geometry = item[@"geometry"];
                 NSDictionary *location = geometry[@"location"];
                 
                 
                 NSString *latitudePharmacy = location[@"lat"];
                 NSString *longitudePharmacy = location[@"lng"];
                 NSString *name = item[@"name"];
                 NSString *address = item[@"formatted_address"];
                 
                 if (![latitudePharmacy isKindOfClass:[NSNull class]] && ![longitudePharmacy isKindOfClass:[NSNull class]]) {
                     CLLocationCoordinate2D annotationCoord;
                     annotationCoord.latitude = [latitudePharmacy doubleValue];
                     annotationCoord.longitude = [longitudePharmacy doubleValue];
                     
                     MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
                     pin.coordinate = annotationCoord;
                     pin.title = name;
                     pin.subtitle = address;
                     
                     [pins addObject:pin];
                 }
                 
             }
             
             onSuccess(pins);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             onError(error);
         }];
    
}

+ (NSArray *) getCountries{
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    
    NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
    
    for (NSString *countryCode in countryArray) {
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        if (!([displayNameString isEqualToString:@"Brasil"] || [displayNameString isEqualToString:@"Brazil"])) {
            [sortedCountryArray addObject:displayNameString];
        }
    }
    [sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
    
    return sortedCountryArray;
}
@end
