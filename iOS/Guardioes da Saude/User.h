//
//  User.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 14/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "JSONModel.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : JSONModel {
    NSString *nick;
    NSString *email;
    NSString *password;
    NSString *client;
    NSString *dob;
    NSString *gender;
    NSString *app_token;
    NSString *lon;
    NSString *lat;
    NSString *race;
    NSString *paltform;
    NSString *type;
    NSString *zip;
    NSString *idUser;
    NSString *picture;
    NSString *user_token;
    NSString *tw;
    NSString *fb;
    NSString *gl;
    NSDictionary *hashtag;
    NSDictionary *household;
    NSDictionary *survey;
    NSDictionary *symptoms;
    NSString *idHousehold;
    NSString *avatar;
    NSString *photo;
    
    
}

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
@property(nonatomic, retain) NSString *picture;
@property(nonatomic, retain) NSString *user_token;
@property(nonatomic, retain) NSString *tw;
@property(nonatomic, retain) NSString *fb;
@property(nonatomic, retain) NSString *gl;
@property(nonatomic, retain) NSDictionary *hashtag;
@property(nonatomic, retain) NSDictionary *household;
@property(nonatomic, retain) NSDictionary *survey;
@property(nonatomic, retain) NSDictionary *symptoms;
@property(nonatomic, retain) NSString *idHousehold;
@property(nonatomic, retain) NSString *avatar;
@property(nonatomic, retain) NSString *photo;

- (void) setGenderBySegIndex: (long) segIndex;
- (void) setRaceBySegIndex: (long) segIndex;
- (void) setGenderByString: (NSString *) strGender;
- (UIImage *) getAvatarImage;

@end
