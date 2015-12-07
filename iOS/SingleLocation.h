//
//  SingleLocation.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 07/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleLocation : NSObject {
    
    NSString *lat;
    NSString *lon;
}


+(SingleLocation *)getInstance;

@property(nonatomic, retain) NSString *lat;
@property(nonatomic, retain) NSString *lon;



@end
