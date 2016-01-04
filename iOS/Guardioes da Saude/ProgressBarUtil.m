//
//  ProgressBarUtil.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/4/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "ProgressBarUtil.h"
#import "MRProgressOverlayView.h"

@implementation ProgressBarUtil

+(void) showProgressBarOnView: (UIView *) view{
    [MRProgressOverlayView showOverlayAddedTo:view title:@"Carregando.." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
}

+(void) hiddenProgressBarOnView: (UIView *) view{
    [MRProgressOverlayView dismissAllOverlaysForView:view animated:YES];
}
@end
