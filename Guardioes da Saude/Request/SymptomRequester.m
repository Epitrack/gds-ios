//
//  SymptomRequester.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 2/19/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "SymptomRequester.h"

@implementation SymptomRequester

- (void)getSymptomsOnSuccess:(void (^)(NSMutableArray *))onSuccess onError:(void (^)(NSError *))onError{
    
    [self doGet:@"" header:nil parameter:nil start:^(){} error:^(AFHTTPRequestOperation *operation, NSError *error){
        
    } success:^(AFHTTPRequestOperation *operation, id response){
    
    }];
}

@end
