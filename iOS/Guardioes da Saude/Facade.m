//
//  Facade.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 19/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Facade.h"
#import "User.h"
#import "HomeViewController.h"

@interface Facade ()

@end

@implementation Facade

-(void) run {
    
    if ([self.action isEqualToString: @"LOGIN"]) {
        
        NSDictionary *jsonObject = self.dictionary;
        
        if ([jsonObject[@"error"] boolValue] == 0) {
                
            NSDictionary *jsonObjectUser = jsonObject[@"user"];
            
            User *user = [User getInstance];
            
            user.nick = jsonObjectUser[@"nick"];
            user.email = jsonObjectUser[@"email"];
            user.gender = jsonObjectUser[@"gender"];
            
            @try {
                user.picture = jsonObjectUser[@"picture"];
            }
            @catch (NSException *exception) {
                user.picture = @"0";
            }
            
            user.idUser=  jsonObjectUser[@"id"];
            user.race = jsonObjectUser[@"race"];
            user.dob = jsonObjectUser[@"dob"];
            user.user_token = jsonObject[@"token"];
            user.hashtag = jsonObjectUser[@"hashtags"];
            user.household = jsonObjectUser[@"household"];
            user.survey = jsonObjectUser[@"surveys"];
        }
    }
}

@end
