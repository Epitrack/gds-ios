//
//  GDSTextView.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 3/23/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "GDSTextView.h"

@implementation GDSTextView

- (void)drawRect:(CGRect)rect {
    NSString *text = NSLocalizedStringWithDefaultValue([self text], nil, [NSBundle mainBundle], [self text], @"");
    if (self.attributedText && [[self text] length] > 0) {
        NSDictionary *attributes = [(NSAttributedString *) self.attributedText attributesAtIndex:0 effectiveRange:NULL];
        
        [self setText:text];
        self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    }else{
        [self setText:text];
    }
    
    [super drawRect:rect];
}

@end
