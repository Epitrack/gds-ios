//
//  Household.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 08/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Household : NSObject

-(id) initWithNick:(NSString *)nick
          andEmail:(NSString *)email
            andDob:(NSString *)dob
         andGender:(NSString *)gender
           andRace:(NSString *)race
         andIdUser:(NSString *)idUser
        andPicture:(NSString *)picture
      andIdPicture:(NSString *)idPicture
    andIdHousehold:(NSString *)idHousehold
   andRelationship:(NSString *) relationship;

- (id) initWithNick:(NSString *) nick andDob:(NSString *) dob andGender:(NSString *) gender andRace:(NSString *) race andIdUser:(NSString *) idUser
         andPicture:(NSString *) picture andIdHousehold:(NSString *) idHousehold andIdPicture:(NSString *) idPicture;

- (void) setGenderByString: (NSString *) strGender;
- (void) setPerfilByString: (NSString *) strPefil;

+ (NSDictionary *) getRelationshipsDictonary;
+ (NSArray *) getRelationshipArray;

@property(nonatomic, retain) NSString *nick;
@property(nonatomic, retain) NSString *dob;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *gender;
@property(nonatomic, retain) NSString *race;
@property(nonatomic, retain) NSString *idUSer;
@property(nonatomic, retain) NSString *picture;
@property(nonatomic, retain) NSString *idHousehold;
@property(nonatomic, retain) NSString *idPicture;
@property(nonatomic, retain) NSString *relationship;
@property(nonatomic, retain) NSNumber *perfil;
@property(nonatomic, retain) NSString *country;
@property(nonatomic, retain) NSString *state;

@end
