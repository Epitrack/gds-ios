//
//  Phones.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 15/12/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Phones : NSObject {
    
    NSString *lbHeader;
    NSString *imgDetail;
    NSString *lbBody;
    NSString *lbDetailBody;
    NSString *lbPhone;
}

+ (Phones *) getInstance;

@property(nonatomic, retain) NSString *lbHeader;
@property(nonatomic, retain) NSString *imgDetail;
@property(nonatomic, retain) NSString *lbBody;
@property(nonatomic, retain) NSString *lbDetailBody;
@property(nonatomic, retain) NSString *lbPhone;

@end
