//
//  LocalizationSystem.h
//  Battle of Puppets
//
//  Created by Juan Albero Sanchis on 27/02/10.
//  Copyright Aggressive Mediocrity 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationSystem : NSObject

+(void)setLanguage:(NSString *)l;

+(NSString *)get:(NSString *)key alter:(NSString *)alternate;

@end
