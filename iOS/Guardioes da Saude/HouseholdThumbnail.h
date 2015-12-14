//
// Created by João Guilherme on 11/19/15.
// Copyright (c) 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HouseholdThumbnail : UIView
@property(nonatomic, copy) NSString *user_household_id;

@property(nonatomic, strong) UIButton *button;

- (id)initWithHousehold:(NSString *)household_id frame:(CGRect)frame avatar:(NSString *)avatar nick:(NSString *)nick;

- (id)initWithHousehold:(NSString *)household_id frame:(CGRect)frame avatar:(NSString *)avatar nick:(NSString *)nick dob:(NSString *)dob;

@end