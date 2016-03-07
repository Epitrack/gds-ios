//
//  TipsRequester.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/19/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "TipsRequester.h"
#import "User.h"
#import "Constants.h"
#import <MapKit/MapKit.h>

@implementation TipsRequester

- (void)loadUpasOnStart:(void (^)())onStart andOnSuccess:(void (^)(NSArray *))onSuccess andOnError:(void(^)(NSError *))onError{
    User *user = [User getInstance];
    
    [self doGet:[[self getUrl] stringByAppendingString:@"/content/upas.json"]
         header:@{@"app_token": user.app_token,
                  @"user_token": user.user_token}
      parameter:nil
          start:onStart
          error:^(AFHTTPRequestOperation *operation, NSError *error){
              onError(error);
          }
        success:^(AFHTTPRequestOperation *operantion, id responseObject){
            NSMutableArray *upasPin = [[NSMutableArray alloc] init];
            NSDictionary *upas = responseObject;
            
            NSLog(@"UPAS %@", upas);
            
            for (NSDictionary *item in upas) {
                
                NSString *latitude = item[@"latitude"];
                NSString *longitude = item[@"longitude"];
                NSString *name = item[@"name"];
                NSString *logradouro = item[@"logradouro"];
                
                if (![latitude isKindOfClass:[NSNull class]] && ![longitude isKindOfClass:[NSNull class]]) {
                    CLLocationCoordinate2D annotationCoord;
                    annotationCoord.latitude = [latitude doubleValue];
                    annotationCoord.longitude = [longitude doubleValue];
                    
                    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
                    pin.coordinate = annotationCoord;
                    pin.title = name;
                    pin.subtitle = logradouro;
                    
                    [upasPin addObject:pin];
                }
                
            }
            
            onSuccess(upasPin);
        }];
}
@end
