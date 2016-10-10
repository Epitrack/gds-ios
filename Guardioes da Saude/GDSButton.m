//
//  GDSButton.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/22/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "GDSButton.h"
#import "LocalizationSystem.h"

@implementation GDSButton

- (void)drawRect:(CGRect)rect {
    NSString *text = NSLocalizedStringWithDefaultValue([self titleLabel].text, nil, [NSBundle mainBundle], [self titleLabel].text, @"");
    
    if (self.titleLabel.attributedText && [[self titleLabel].text length] > 0) {
        NSDictionary *attributes = [(NSAttributedString *) self.titleLabel.attributedText attributesAtIndex:0 effectiveRange:NULL];
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        
        [self setAttributedTitle:title forState:UIControlStateNormal];
    }else{
        [self setTitle:text forState:UIControlStateNormal];
    }
    
    [super drawRect:rect];
}


@end
