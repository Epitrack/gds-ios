//
//  SingleNotice.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 01/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleNotice : NSObject {
    
    NSMutableArray *notices;
}

+(SingleNotice *)getInstance;

@property(nonatomic, retain) NSMutableArray *notices;

@end
