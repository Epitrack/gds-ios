//
//  User.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 14/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "User.h"
#import "DateUtil.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import <UIKit/UIKit.h>

NSString *const kAppTokenKey = @"appTokenKey";
NSString *const kUserTokenKey = @"userTokenKey";
NSString *const kPhotoKey = @"photoKey";
NSString *const kAvatarNumberKey = @"avatarNumberKey";
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
@synthesize avatarNumber;
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

- (void)setAvatarImageAtButton: (UIButton *) button orImageView:(UIImageView *) imageView onBackground: (bool) onBackground isSmall: (BOOL) isSmall {
    if(self.photo){
        PHFetchResult* assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[self.photo] options:nil];
        PHAsset *asset = [assetResult firstObject];
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            UIImage* photoImage = [UIImage imageWithData:imageData];
            
            UIBezierPath *path;
            
            CGRect rect;
            
            if (button) {
                rect = button.bounds;
            } else {
                rect = imageView.bounds;
            }
            
            if (isSmall) {
                path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(rect.origin.x+5, rect.origin.y+5, rect.size.width-10, rect.size.height-10)];
            } else {
                path = [UIBezierPath bezierPathWithOvalInRect:rect];
            }
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = path.CGPath;
            
            if (button) {
                button.layer.mask = maskLayer;
                
                if (onBackground) {
                    [button setBackgroundImage:photoImage forState:UIControlStateNormal];
                } else {
                    [button setImage:photoImage forState:UIControlStateNormal];
                }
            } else {
                imageView.layer.mask = maskLayer;
                [imageView setImage:photoImage];
            }
        }];
    }else{
        if ([self.avatarNumber intValue] == 0 || self.avatarNumber == nil) {
            long diffYears = ([DateUtil diffInDaysDate:[DateUtil dateFromStringUS:self.dob] andDate:[NSDate new]]/360);
            
            if ([self.gender isEqualToString:@"M"]) {
                if (diffYears > 50) {
                    if ([self.race isEqualToString:@"preto"] || [self.race isEqualToString:@"indigena"]) {
                        self.avatarNumber = @11;
                        avatar = @"img_profile11.png";
                    } else {
                        self.avatarNumber = @9;
                        avatar = @"img_profile09.png";
                    }
                }else{
                    if ([self.race isEqualToString:@"branco"] || [self.race isEqualToString:@"pardo"]) {
                        self.avatarNumber = @5;
                        avatar = @"img_profile05.png";
                    }else if([self.race isEqualToString:@"preto"]){
                        self.avatarNumber = @4;
                        avatar = @"img_profile04.png";
                    }else if([self.race isEqualToString:@"indigena"]){
                        self.avatarNumber = @6;
                        avatar = @"img_profile06.png";
                    }else if([self.race isEqualToString:@"amarelo"]){
                        self.avatarNumber = @7;
                        avatar = @"img_profile07.png";
                    }
                }
            } else {
                if (diffYears > 50) {
                    if ([self.race isEqualToString:@"preto"] || [self.race isEqualToString:@"indigena"]) {
                        self.avatarNumber = @12;
                        avatar = @"img_profile12.png";
                    } else {
                        self.avatarNumber = @10;
                        avatar = @"img_profile10.png";
                    }
                }else{
                    if ([self.race isEqualToString:@"branco"] || [self.race isEqualToString:@"pardo"]) {
                        self.avatarNumber = @8;
                        avatar = @"img_profile08.png";
                    }else if([self.race isEqualToString:@"preto"]){
                        self.avatarNumber = @2;
                        avatar = @"img_profile02.png";
                    }else if([self.race isEqualToString:@"indigena"]){
                        self.avatarNumber = @1;
                        avatar = @"img_profile01.png";
                    }else if([self.race isEqualToString:@"amarelo"]){
                        self.avatarNumber = @3;
                        avatar = @"img_profile03.png";
                    }
                }
            }
            
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            [preferences setValue:self.avatarNumber forKey:kAvatarNumberKey];
            
            [preferences synchronize];
            
        } else {
            avatar = [NSString stringWithFormat:@"img_profile%02d.png", [self.avatarNumber integerValue]];
        }
        
        if (button) {
            if (onBackground) {
                [button setBackgroundImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
            }else{
                [button setImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
            }
        } else {
            [imageView setImage:[UIImage imageNamed:avatar]];
        }
    }
}

- (void) cloneUser: (User *) user{
    self.nick = user.nick;
    self.email = user.email;
    self.dob = user.dob;
    self.gender = user.gender;
    self.lon = user.lon;
    self.lat = user.lat;
    self.race = user.race;
    self.zip = user.zip;
    self.idUser = user.idUser;
    self.avatarNumber = user.avatarNumber;
    self.user_token = user.user_token;
    self.tw = user.tw;
    self.fb = user.fb;
    self.gl = user.gl;
    self.photo = user.photo;
    self.app_token = user.app_token;
}

- (void) clearUser{
    self.nick = nil;
    self.email = nil;
    self.password = nil;
    self.dob = nil;
    self.gender = nil;
    self.lon = nil;
    self.lat = nil;
    self.race = nil;
    self.zip = nil;
    self.idUser = nil;
    self.avatarNumber = nil;
    self.user_token = nil;
    self.tw = nil;
    self.fb = nil;
    self.gl = nil;
    self.photo = nil;
}

@end