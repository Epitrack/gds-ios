//
//  ViewUtil.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/15/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil

+(UIAlertController *)showAlertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
        NSLog(@"You pressed button OK");
    }];
    [alert addAction:defaultAction];
    
    return alert;
}
@end
