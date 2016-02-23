//
// Created by João Guilherme on 11/19/15.
// Copyright (c) 2015 epitrack. All rights reserved.
//

#import "HouseholdThumbnail.h"


@implementation HouseholdThumbnail {

}
- (id)initWithHousehold:(NSString *)household_id frame:(CGRect)frame avatar:(NSString *)avatar nick:(NSString *)nick {
    self = [super initWithFrame:frame];
    self.user_household_id = household_id;
    self.button = [[UIButton alloc] initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:
            CGRectMake(self.button.bounds.size.width/4,
                    5,
                    self.button.bounds.size.width/2,
                    self.button.bounds.size.height/2)];

    [imageView setImage:[UIImage imageNamed:avatar]];

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.button.bounds.size.width/4, 50, self.button.bounds.size.width/2, self.button.bounds.size.height/2)];
    
    NSArray *array = [nick componentsSeparatedByString:@" "];
    
    if (array.count > 0) {
        label.text = [array objectAtIndex:0];
    } else {
        label.text= nick;
    }
    
    label.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Foco-Bold" size:10.0]];
    [self.button addSubview:label];
    [self.button addSubview:imageView];
    [self addSubview:self.button];
    return self;
}

- (id)initWithHousehold:(NSString *)household_id frame:(CGRect)frame avatar:(NSString *)avatar nick:(NSString *)nick dob:(NSString *)dob {
    self = [super initWithFrame:frame];
    self.user_household_id = household_id;
    self.button = [[UIButton alloc] initWithFrame:frame];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    
    NSString *dobUser = [dob componentsSeparatedByString:@"-"][0];
    NSString *currentDate = [format stringFromDate:[NSDate date]];
    NSInteger ageUser= [currentDate intValue] - [dobUser intValue];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(self.button.bounds.size.width/4,
                                         5,
                                         self.button.bounds.size.width/2,
                                         self.button.bounds.size.height/2)];
    
    [imageView setImage:[UIImage imageNamed:avatar]];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.button.bounds.size.width/4, 50, self.button.bounds.size.width/2, self.button.bounds.size.height/2)];
    label.text = [NSString stringWithFormat:@"%@ - %ld Anos", nick, (long)ageUser];
    label.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Foco-Bold" size:8]];
    
    UILabel *labelAge=[[UILabel alloc]initWithFrame:CGRectMake(self.button.bounds.size.width/4, 50, self.button.bounds.size.width/2, self.button.bounds.size.height/2)];
    labelAge.text = [NSString stringWithFormat:@"%ld Anos", (long)ageUser];
    labelAge.backgroundColor = [UIColor colorWithRed:(25/255.0) green:(118/255.0) blue:(211/255.0) alpha:1];
    labelAge.textColor = [UIColor whiteColor];
    [labelAge setTextAlignment:NSTextAlignmentCenter];
    [labelAge setFont:[UIFont fontWithName:@"Foco-Bold" size:10.0]];

    [self.button addSubview:label];
    [self.button addSubview:imageView];
    [self addSubview:self.button];
    return self;
}

@end