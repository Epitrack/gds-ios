//
//  Facade.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 19/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Facade : UIViewController

@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSData *data;
@property (retain, nonatomic) NSDictionary *dictionary;

-(void) run;

@end
