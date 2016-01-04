//
//  GoogleUtil.h
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 12/31/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleUtil : NSObject

+ (void) getLocationByAddress: (NSString *) address
                    onSuccess: (void(^)(NSString *lng, NSString *lat, NSString *fullNameCity)) success
                       onFail: (void(^)(NSError *error)) fail;
@end
