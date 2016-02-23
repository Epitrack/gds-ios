//
//  NoticeRequester.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 30/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "NoticeRequester.h"
#import "Constants.h"
#import "StatusCode.h"
#import "Notice.h"

@implementation NoticeRequester

- (void) getNotices: (User *) user
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/news/get", Url];
    
    [self doGet: url
         header: @{ @"user_token": user.user_token }
      parameter: nil
          start: onStart
     
          error: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(error);
          }
     
        success: ^(AFHTTPRequestOperation * request, id responseObject) {

            NSMutableArray *notices = [[NSMutableArray alloc] init];
            
            if ([request.response statusCode] == Ok) {
                
                NSDictionary *response = responseObject;
                NSDictionary *data = response[@"data"];
                NSMutableArray *statuses = data[@"statuses"];
                
                for (NSDictionary *item in statuses) {
                    
                    NSString *text = item[@"text"];
                    NSString *source = @"via @minsaude";
                    NSString *link = [NSString stringWithFormat: @"https://twitter.com/minsaude/status/%@", item[@"id_str"]];
                    
                    Notice *notice = [[Notice alloc] initWithName:text andSource:source andLink:link];
                    
                    [notices addObject:notice];
                    
                }
                
                onSuccess(notices);
                
            } else {
                
                onError(nil);
            }
        }
     ];
    
    
}

@end
