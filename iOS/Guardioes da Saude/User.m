//
//  User.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 14/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "User.h"
#import "DateUtil.h"

NSString *const kAppTokenKey = @"appTokenKey";
NSString *const kUserTokenKey = @"userTokenKey";
NSString *const kPictureKey = @"pictureKey";
NSString *const kNickKey = @"nickKey";

@implementation User

@synthesize nick;
@synthesize email;
@synthesize password;
@synthesize client;
@synthesize dob;
@synthesize gender;
@synthesize app_token;
@synthesize lon;
@synthesize lat;
@synthesize race;
@synthesize platform;
@synthesize type;
@synthesize zip;
@synthesize idUser;
@synthesize picture;
@synthesize user_token;
@synthesize tw;
@synthesize fb;
@synthesize gl;
@synthesize hashtag;
@synthesize household;
@synthesize survey;
@synthesize symptoms;
@synthesize idHousehold;
@synthesize avatar;
@synthesize photo;

+ (User *)getInstance {
    
    static User *getInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        getInstance = [[self alloc] init];
    });
    
    return getInstance;
}

- (id)init{
    
    if (self = [super init]) {
        client = @"api";
        app_token = @"d41d8cd98f00b204e9800998ecf8427e";
        platform = @"ios";
    }
    return self;
}

- (void) setGenderBySegIndex: (long) segIndex{
    if (segIndex == 0) {
        gender = @"M";
    } else if (segIndex == 1) {
        gender = @"F";
    }
}

- (void) setRaceBySegIndex: (long) segIndex{
    if (segIndex == 0) {
        race = @"branco";
    } else if (segIndex == 1) {
        race = @"preto";
    } else if (segIndex == 2) {
        race = @"pardo";
    } else if (segIndex == 3) {
        race = @"amarelo";
    } else if (segIndex == 4) {
        race = @"indigena";
    }
}

- (void) setGenderByString: (NSString *) strGender{
    if ([strGender isEqualToString:@"Masculino"]) {
        gender = @"M";
    } else if ([strGender isEqualToString:@"Feminino"]) {
        gender = @"F";
    }
}

- (UIImage *)getAvatarImage{
    if ([self.picture isEqualToString:@"0"] || self.picture == nil) {
        long diffYears = ([DateUtil diffInDaysDate:[NSDate new] andDate:[DateUtil dateFromStringUS:self.dob]]/360);
        
        if ([self.gender isEqualToString:@"M"]) {
            if (diffYears > 50) {
                if ([self.race isEqualToString:@"preto"] || [self.race isEqualToString:@"indigena"]) {
                    self.picture = @"11";
                    avatar = @"img_profile11.png";
                } else {
                    self.picture = @"9";
                    avatar = @"img_profile09.png";
                }
            }else{
                if ([self.race isEqualToString:@"branco"] || [self.race isEqualToString:@"pardo"]) {
                    self.picture = @"5";
                    avatar = @"img_profile05.png";
                }else if([self.race isEqualToString:@"negro"]){
                    self.picture = @"4";
                    avatar = @"img_profile04.png";
                }else if([self.race isEqualToString:@"indigena"]){
                    self.picture = @"6";
                    avatar = @"img_profile06.png";
                }else if([self.race isEqualToString:@"amarelo"]){
                    self.picture = @"7";
                    avatar = @"img_profile07.png";
                }
            }
        } else {
            if (diffYears > 50) {
                if ([self.race isEqualToString:@"preto"] || [self.race isEqualToString:@"indigena"]) {
                    self.picture = @"12";
                    avatar = @"img_profile12.png";
                } else {
                    self.picture = @"10";
                    avatar = @"img_profile10.png";
                }
            }else{
                if ([self.race isEqualToString:@"branco"] || [self.race isEqualToString:@"pardo"]) {
                    self.picture = @"8";
                    avatar = @"img_profile08.png";
                }else if([self.race isEqualToString:@"negro"]){
                    self.picture = @"2";
                    avatar = @"img_profile02.png";
                }else if([self.race isEqualToString:@"indigena"]){
                    self.picture = @"1";
                    avatar = @"img_profile01.png";
                }else if([self.race isEqualToString:@"amarelo"]){
                    self.picture = @"3";
                    avatar = @"img_profile03.png";
                }
            }
        }
        
    } else {
        
        if (self.picture.length == 1) {
            avatar = [NSString stringWithFormat: @"img_profile0%@.png", self.picture];
        } else if (self.picture.length == 2) {
            avatar = [NSString stringWithFormat: @"img_profile%@.png", self.picture];
        }
    }
    
    return [UIImage imageNamed:avatar];
}

@end