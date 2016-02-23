//
//  DTO.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTO : NSObject {
    
    NSString *string;
    id data;
}

@property(nonatomic, retain) NSString *string;
@property(nonatomic, retain) id data;

+(DTO *) getInstance;

@end
