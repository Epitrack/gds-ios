//
// Created by Miqueias Lopes on 27/11/15.
// Copyright (c) 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SingleHousehold : NSObject {
    NSString *nick;
    NSString *email;
    NSString *password;
    NSString *client;
    NSString *dob;
    NSString *gender;
    NSString *race;
    NSString *idUser;
    NSString *picture;
    NSString *id;
}

+(SingleHousehold *)getInstance;

@property(nonatomic, retain) NSString *nick;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *client;
@property(nonatomic, retain) NSString *dob;
@property(nonatomic, retain) NSString *gender;
@property(nonatomic, retain) NSString *race;
@property(nonatomic, retain) NSString *idUser;
@property(nonatomic, retain) NSString *picture;
@property(nonatomic, retain) NSString *id;

@end