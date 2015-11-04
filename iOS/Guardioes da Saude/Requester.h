//
//  Requester.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 07/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Requester : NSObject
@property NSString *url;
@property NSString *const API_URL;
@property NSString *method;
@property NSDictionary *params;
@property NSString *action;
- (void) execute;
@end
