//
//  Household.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 08/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Household.h"

@implementation Household

-(id) initWithNick:(NSString *)nick
            andEmail:(NSString *)email
            andDob:(NSString *)dob
         andGender:(NSString *)gender
           andRace:(NSString *)race
         andIdUser:(NSString *)idUser
        andPicture:(NSString *)picture
      andIdPicture:(NSString *)idPicture
    andIdHousehold:(NSString *)idHousehold {
    
    if (self == [super init]) {

        self.nick = nick;
        self.email = email;
        self.dob = dob;
        self.gender = gender;
        self.race = race;
        self.idUSer = idUser;
        self.picture = picture;
        self.idPicture = idPicture;
        self.idHousehold = idHousehold;
    }
    return self;
}

-(id) initWithNick:(NSString *)nick andDob:(NSString *)dob andGender:(NSString *)gender andRace:(NSString *)race andIdUser:(NSString *)idUser
        andPicture:(NSString *)picture andIdHousehold:(NSString *)idHousehold andIdPicture:(NSString *) idPicture {

    if (self == [super init]) {

        self.nick = nick;
        self.dob = dob;
        self.gender = gender;
        self.race = race;
        self.idUSer = idUser;
        self.picture = picture;
        self.idHousehold = idHousehold;
        self.idPicture = idPicture;
    }
    return self;
}
@end
