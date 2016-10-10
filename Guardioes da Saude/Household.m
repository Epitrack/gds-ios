//
//  Household.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 08/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Household.h"
#import "Constants.h"

@implementation Household

-(id) initWithNick:(NSString *)nick
            andEmail:(NSString *)email
            andDob:(NSString *)dob
         andGender:(NSString *)gender
           andRace:(NSString *)race
         andIdUser:(NSString *)idUser
        andPicture:(NSString *)picture
      andIdPicture:(NSString *)idPicture
    andIdHousehold:(NSString *)idHousehold
   andRelationship:(NSString *) relationship
         andPerfil: (NSNumber *) perfil
        andCountry: (NSString *) country
          andState: (NSString *) state  {
    
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
        self.relationship = relationship;
        self.perfil = perfil;
        self.country = country;
        self.state = state;
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

- (void) setGenderByString: (NSString *) strGender{
    if ([strGender isEqualToString:NSLocalizedString(@"masculino", @"")]) {
        self.gender = @"M";
    } else if ([strGender isEqualToString:NSLocalizedString(@"feminino", @"")]) {
        self.gender = @"F";
    }
}

+ (NSDictionary *) getRelationshipsDictonary{
    NSArray *relationshipsArray = [self getRelationshipArray];
    
    return @{@"pai": relationshipsArray[0],
             @"mae": relationshipsArray[1],
             @"filho": relationshipsArray[2],
             @"irmao": relationshipsArray[3],
             @"avo": relationshipsArray[4],
             @"neto": relationshipsArray[5],
             @"tio": relationshipsArray[6],
             @"sobrinho": relationshipsArray[7],
             @"bisavo": relationshipsArray[8],
             @"bisneto": relationshipsArray[9],
             @"primo": relationshipsArray[10],
             @"sogro": relationshipsArray[11],
             @"genro-nora": relationshipsArray[12],
             @"padrasto": relationshipsArray[13],
             @"madrasta": relationshipsArray[14],
             @"enteado": relationshipsArray[15],
             @"conjuge": relationshipsArray[16],
             @"outro": relationshipsArray[17]};
}

+ (NSArray *) getRelationshipArray{
    NSArray *relationships = @[NSLocalizedString(@"pai", @""),
                               NSLocalizedString(@"mae", @""),
                               NSLocalizedString(@"filho", @""),
                               NSLocalizedString(@"irmao", @""),
                               NSLocalizedString(@"avo", @""),
                               NSLocalizedString(@"neto", @""),
                               NSLocalizedString(@"tio", @""),
                               NSLocalizedString(@"sobrinho", @""),
                               NSLocalizedString(@"bisavo", @""),
                               NSLocalizedString(@"bisneto", @""),
                               NSLocalizedString(@"primo", @""),
                               NSLocalizedString(@"sogro", @""),
                               NSLocalizedString(@"genro-nora", @""),
                               NSLocalizedString(@"padrasto", @""),
                               NSLocalizedString(@"madrasta", @""),
                               NSLocalizedString(@"enteado", @""),
                               NSLocalizedString(@"conjuge", @""),
                               NSLocalizedString(@"outro", @"")];
    
    
    
    return relationships;
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

- (void) setRaceByStr: (NSString *) raceStr{
    if ([raceStr isEqualToString:NSLocalizedString(@"branco", @"")]) {
        self.race = @"branco";
    }else if ([raceStr isEqualToString:NSLocalizedString(@"preto", @"")]){
        self.race = @"preto";
    }else if ([raceStr isEqualToString:NSLocalizedString(@"pardo", @"")]){
        self.race = @"pardo";
    }else if ([raceStr isEqualToString:NSLocalizedString(@"amarelo", @"")]){
        self.race = @"amarelo";
    }else if ([raceStr isEqualToString:NSLocalizedString(@"indigena", @"")]){
        self.race = @"indigena";
    }
}
@end
