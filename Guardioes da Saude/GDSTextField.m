//
//  GDSTextField.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/22/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "GDSTextField.h"

@implementation GDSTextField

- (void)drawRect:(CGRect)rect {
    NSString *text = NSLocalizedStringWithDefaultValue([self placeholder], nil, [NSBundle mainBundle], [self placeholder], @"");
    [self setPlaceholder:text];
    
    [super drawRect:rect];
}


@end
