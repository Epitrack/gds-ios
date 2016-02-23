//
//  Symptom.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 27/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Symptom : NSObject

- (id) initWithName:(NSString *) name andCode:(NSString *) code;

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *code;

@end
