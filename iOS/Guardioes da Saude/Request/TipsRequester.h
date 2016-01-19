//
//  TipsRequester.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/19/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "Requester.h"

@interface TipsRequester : Requester

- (void) loadUpasOnStart:(void(^)()) onStart
            andOnSuccess:(void(^)(NSArray *)) onSuccess
              andOnError:(void(^)(NSError *)) onError;
@end
