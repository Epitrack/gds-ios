//
//  User.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 14/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import Photos;

extern NSString *const kAppTokenKey;
extern NSString *const kUserTokenKey;
extern NSString *const kPhotoKey;
extern NSString *const kAvatarNumberKey;
extern NSString *const kNickKey;
extern NSString *const kIsTest;
extern NSString *const kLastJoinNotification;
extern NSString *const kGameTutorialReady;

@interface User : NSObject

+(User *)getInstance;

@property(nonatomic, retain) NSString *nick;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *client;
@property(nonatomic, retain) NSString *dob;
@property(nonatomic, retain) NSString *gender;
@property(nonatomic, retain) NSString *app_token;
@property(nonatomic, retain) NSString *lon;
@property(nonatomic, retain) NSString *lat;
@property(nonatomic, retain) NSString *race;
@property(nonatomic, retain) NSString *platform;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *zip;
@property(nonatomic, retain) NSString *idUser;
@property(nonatomic, retain) NSNumber *avatarNumber;
@property(nonatomic, retain) NSString *user_token;
@property(nonatomic, retain) NSString *tw;
@property(nonatomic, retain) NSString *fb;
@property(nonatomic, retain) NSString *gl;
@property(nonatomic, retain) NSDictionary *hashtag;
@property(nonatomic, retain) NSMutableArray *household;
@property(nonatomic, retain) NSDictionary *survey;
@property(nonatomic, retain) NSMutableArray *symptoms;
@property(nonatomic, retain) NSString *idHousehold;
@property(nonatomic, retain) NSString *avatar;
@property(nonatomic, retain) NSString *photo;
@property(nonatomic, retain) NSString *gcmToken;
@property(nonatomic, assign) bool isTest;
@property(nonatomic, retain) NSDate *lastJoinNotification;
@property(nonatomic, assign) int level;
@property(nonatomic, retain) NSMutableArray *levelCorrectAnswers;
@property(nonatomic, assign) int points;
@property(nonatomic, assign) BOOL isGameTutorailReady;
@property(nonatomic, retain) NSMutableArray *puzzleMatriz;
@property(nonatomic, assign) int partsCompleted;

- (void) setGenderBySegIndex: (long) segIndex;
- (void) setRaceBySegIndex: (long) segIndex;
- (void) setGenderByString: (NSString *) strGender;
- (void) requestPermissions:(void(^)(bool)) block;
- (void) setAvatarImageAtButton: (UIButton *) button orImageView:(UIImageView *) imageView;
- (BOOL) isValidEmail;
- (void) cloneUser: (User *) user;
- (void) clearUser;

@end
