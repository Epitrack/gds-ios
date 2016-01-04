//
//  GoogleUtil.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 12/31/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "GoogleUtil.h"
#import "AFNetworking/AFNetworking.h"

@implementation GoogleUtil

+ (void) getLocationByAddress: (NSString *) address
                    onSuccess: (void(^)(NSString *lng, NSString *lat, NSString *fullNameCity)) success
                       onFail: (void(^)(NSError *error)) fail{
    
    AFHTTPRequestOperationManager *manager;

    NSDictionary *params = @{@"address": address,
                             @"key": @"AIzaSyDRoA88MUJbF8TFPnaUXHvIrQzGPU5JC94"};
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://maps.googleapis.com/maps/api/geocode/json"
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

@end
