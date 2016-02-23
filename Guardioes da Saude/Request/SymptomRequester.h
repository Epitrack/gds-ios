//
//  SymptomRequester.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 2/19/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requester.h"

@interface SymptomRequester : Requester

- (void) getSymptomsOnSuccess: (void(^)(NSMutableArray *symptoms)) onSuccess onError:(void(^)(NSError *error)) onError;

@end
