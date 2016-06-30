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
#import "Constants.h"

NSString *const kAppTokenKey = @"appTokenKey";
NSString *const kUserTokenKey = @"userTokenKey";
NSString *const kPhotoKey = @"photoKey";
NSString *const kAvatarNumberKey = @"avatarNumberKey";
NSString *const kNickKey = @"nickKey";
NSString *const kIsTest = @"isTest";
NSString *const kLastJoinNotification = @"lastJoinNotification";
NSString *const kGameTutorialReady = @"gameTutorialReady";
NSString *const kGCMToken = @"gcmToken";

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
@synthesize lastJoinNotification;

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
        self.level = 1;
        self.isGameTutorailReady = false;
        self.points = 0;
        [self resetPuzzleMatriz];
    }
    
    return self;
}

- (void) resetPuzzleMatriz{
    self.partsCompleted = 0;
    self.puzzleMatriz = [[NSMutableArray alloc] initWithArray:@[@0, @0, @0, @0, @0, @0, @0, @0, @0]];
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

- (void) setPerfilByString: (NSString *) strPefil{
    NSArray *perfis = [Constants getPerfis];
    for (int i = 0; i < perfis.count; i++) {
        NSString *curPefil = perfis[i];
        if ([curPefil isEqualToString:strPefil]) {
            self.perfil = [NSNumber numberWithInt:i+1];
        }
    }
}

- (void)requestPermissions:(void(^)(bool)) block
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status)
    {
        case PHAuthorizationStatusAuthorized:
            block(YES);
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus)
             {
                 if (authorizationStatus == PHAuthorizationStatusAuthorized)
                 {
                     block(YES);
                 }
                 else
                 {
                     block(NO);
                 }
             }];
            break;
        }
        default:
            block(NO);
            break;
    }
}

- (void)setAvatarImageAtButton: (UIButton *) button orImageView:(UIImageView *) imageView {
    
    if(self.photo){
        [self requestPermissions:^(bool isAutorized){
            if (isAutorized) {
                [self setPhotoOnButton:button orImageView:imageView];
            }else{
                [self setAvatarOnButton:button orImageView:imageView];
            }
        }];
    }else{
        [self setAvatarOnButton:button orImageView:imageView];
    }
}

- (void) setPhotoOnButton: (UIButton *) button orImageView:(UIImageView *) imageView{
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
        
        path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        
        if (button) {
            button.layer.mask = maskLayer;
            [button setBackgroundImage:photoImage forState:UIControlStateNormal];
        } else {
            imageView.layer.mask = maskLayer;
            [imageView setImage:photoImage];
        }
    }];
}

- (void) setAvatarOnButton: (UIButton *) button orImageView:(UIImageView *) imageView{
    if ([self.avatarNumber intValue] == 0 || self.avatarNumber == nil) {
        if ([self.gender isEqualToString:@"M"]) {
            if ([self.race isEqualToString:@"branco"]) {
                self.avatarNumber = @11;
                avatar = @"img_profile11.png";
            }else if ([self. race isEqualToString:@"preto"]){
                self.avatarNumber = @5;
                avatar = @"img_profile05.png";
            }else if ([self. race isEqualToString:@"pardo"]){
                self.avatarNumber = @4;
                avatar = @"img_profile04.png";
            }else if ([self. race isEqualToString:@"amarelo"]){
                self.avatarNumber = @10;
                avatar = @"img_profile10.png";
            }else if ([self. race isEqualToString:@"indigena"]){
                self.avatarNumber = @4;
                avatar = @"img_profile04.png";
            }
        } else {
            if ([self.race isEqualToString:@"branco"]) {
                self.avatarNumber = @8;
                avatar = @"img_profile08.png";
            }else if ([self. race isEqualToString:@"preto"]){
                self.avatarNumber = @1;
                avatar = @"img_profile01.png";
            }else if ([self. race isEqualToString:@"pardo"]){
                self.avatarNumber = @2;
                avatar = @"img_profile02.png";
            }else if ([self. race isEqualToString:@"amarelo"]){
                self.avatarNumber = @7;
                avatar = @"img_profile07.png";
            }else if ([self. race isEqualToString:@"indigena"]){
                self.avatarNumber = @8;
                avatar = @"img_profile08.png";
            }
        }
        
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setValue:self.avatarNumber forKey:kAvatarNumberKey];
        
        [preferences synchronize];
        
    } else {
        avatar = [NSString stringWithFormat:@"img_profile%02d.png", (int)[self.avatarNumber integerValue]];
    }
    
    if (button) {
        [button setBackgroundImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];
        
    } else {
        [imageView setImage:[UIImage imageNamed:avatar]];
    }
}

- (void) setGameTutorialReady{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:@"true" forKey:kGameTutorialReady];
    [preferences synchronize];
}

- (BOOL)isValidEmail
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.email];
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
    self.country = user.country;
    self.perfil = user.perfil;
    self.state = user.state;
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
    self.lastJoinNotification = nil;
    
    [self resetPuzzleMatriz];
    self.points = 0;
}

- (void)setPuzzleMatrizWithResponse:(NSMutableArray *)puzzleMatriz{
    [self resetPuzzleMatriz];

    int index = 0;
    for (NSString *strItem in puzzleMatriz) {
        NSNumber *item = [NSNumber numberWithInteger:[strItem integerValue]];
        [self.puzzleMatriz replaceObjectAtIndex:index withObject:item];
        if ([item isEqual: @1]) {
            self.partsCompleted += 1;
        }
        
        index++;
    }
}

@end