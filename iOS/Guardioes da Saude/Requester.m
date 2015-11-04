//
//  Requester.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 07/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Requester.h"
#import "AFNetworking/AFNetworking.h"
#import "DTO.h"
#import "Facade.h"

@implementation Requester

- (void) execute {
    
    self.API_URL = @"http://52.20.162.21/";
    NSString *apiUrl =  [self.API_URL stringByAppendingString:self.url];
    AFHTTPRequestOperationManager *manager;
    
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if ([self.method isEqualToString: @"GET"]) {
        
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:apiUrl
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"JSON Request: %@", responseObject);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        
    } else if ([self.method isEqualToString: @"POST"]) {
        
        manager = [AFHTTPRequestOperationManager manager];
        [manager POST:apiUrl
           parameters:self.params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  
                  NSLog(@"JSON %@", responseObject);
                  NSLog(@"JSON %@", responseObject[@"error"]);
                  Facade *facade = [[Facade alloc] init];
                  facade.action = self.action;
                  facade.dictionary = responseObject;
                  [facade run];
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
}
@end
