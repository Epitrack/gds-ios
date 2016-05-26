// Igor Morais

#import "Constants.h"
#import "StatusCode.h"
#import "Sumary.h"
#import "SumaryCalendar.h"
#import "SumaryGraph.h"
#import "UserRequester.h"
#import "Symptom.h"

@implementation UserRequester

- (void) login: (User *) user
       onStart: (Start) onStart
       onError: (Error) onError
     onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/user/login", [self getUrl]];
    
    NSMutableDictionary * paramMap = [[NSMutableDictionary alloc] init];
    [paramMap setObject:user.email forKey:@"email"];
    [paramMap setObject:user.password forKey:@"password"];
    
    NSString *gcmToken = [User getInstance].gcmToken;
    if (gcmToken) {
        [paramMap setObject:gcmToken forKey:@"gcm_token"];
    }
    
    [self doPost: url
          header: nil
       parameter: paramMap
           start: onStart
     
           error: ^(AFHTTPRequestOperation * request, NSError * error) {
               
               onError(error);
           }
     
         success: ^(AFHTTPRequestOperation * request, id response) {
             
             if ([request.response statusCode] == Ok) {
                 
                 if ([response[@"error"] boolValue]) {
                     
                     onError(nil);
                 
                 } else {
                     
                     NSDictionary * paramMap = response[@"user"];
                     
                     User * user = [User getInstance];
                     
                     user.nick = paramMap[@"nick"];
                     user.email = paramMap[@"email"];
                     user.gender = paramMap[@"gender"];
                     user.avatarNumber = paramMap[@"picture"];
                     user.idUser =  paramMap[@"id"];
                     user.race = paramMap[@"race"];
                     user.dob = paramMap[@"dob"];
                     user.user_token = response[@"token"];
                     user.hashtag = paramMap[@"hashtags"];
                     user.survey = paramMap[@"surveys"];
                     
                     onSuccess(user);
                 }
             
             } else {
                 
                 onError(nil);
             }
         }
    ];
}

- (void) createAccountWithUser: (User *) user
                       andOnStart: (void(^)()) onStart
                  andOnSuccess: (void(^)(User *user)) onSuccess
                    andOnError: (void(^)(NSError *)) onError {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:user.nick forKey:@"nick"];
    [params setObject:user.email forKey:@"email"];
    [params setObject:user.client forKey:@"client"];
    [params setObject:user.dob forKey:@"dob"];
    [params setObject:user.gender forKey:@"gender"];
    [params setObject:user.app_token forKey:@"app_token"];
    [params setObject:user.race forKey:@"race"];
    [params setObject:user.platform forKey:@"platform"];
    [params setObject:@"0" forKey:@"picture"];
    [params setObject:user.lat forKey:@"lat"];
    [params setObject:user.lon forKey:@"lon"];
    
    if (user.password) {
        [params setObject:user.password forKey:@"password"];
    }else{
        [params setObject:user.email forKey:@"password"];
    }
    
    if (user.gl) {
        [params setObject:user.gl forKey:@"gl"];
    }
    
    if (user.fb) {
        [params setObject:user.fb forKey:@"fb"];
    }
    
    if (user.tw) {
        [params setObject:user.tw forKey:@"tw"];
    }
    
    NSString *gcmToken = [User getInstance].gcmToken;
    if (gcmToken) {
        [params setObject:gcmToken forKey:@"gcm_token"];
    }
    
    [self doPost:[[self getUrl] stringByAppendingString:@"/user/create"]
          header:@{@"app_token": user.app_token}
       parameter:params
           start:onStart
           error:^(AFHTTPRequestOperation *operation, NSError *error){
               onError(error);
           }
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             if ([responseObject[@"error"] boolValue] == 1) {
                 onError(nil);
             }else{
                 NSDictionary *userRequest = responseObject[@"user"];
                 
                 user.nick = userRequest[@"nick"];
                 user.email = userRequest[@"email"];
                 user.gender = userRequest[@"gender"];
                 
                 @try {
                     user.avatarNumber = userRequest[@"picture"];
                 }
                 @catch (NSException *exception) {
                     user.avatarNumber = @0;
                 }
                 
                 user.idUser=  userRequest[@"id"];
                 user.race = userRequest[@"race"];
                 user.dob = userRequest[@"dob"];
                 user.user_token = userRequest[@"token"];
                 user.hashtag = userRequest[@"hashtags"];
                 user.survey = userRequest[@"surveys"];
                 
                 onSuccess(user);
             }
         }];
}

- (void) getSummary: (User *) user
        idHousehold: (NSString *)idHousehold
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url;
    
    if ([idHousehold isEqualToString:@""] || [idHousehold isEqualToString:user.idUser]) {
        url = [NSString stringWithFormat: @"%@/user/survey/summary", [self getUrl]];
    } else {
        url = [NSString stringWithFormat: @"%@/household/survey/summary?household_id=%@", [self getUrl], idHousehold];
    }
    
    [self doGet: url
         header: @{ @"user_token": user.user_token,
                    @"app_token": user.app_token}
      parameter: nil
          start: onStart
     
          error: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(error);
          }
     
        success: ^(AFHTTPRequestOperation * request, id response) {
            
            if ([request.response statusCode] == Ok) {
                
                NSDictionary * paramMap = response[@"data"];
                
                Sumary * sumary = [[Sumary alloc] init];
                
                sumary.noSymptom = [paramMap[@"no_symptom"] intValue];
                sumary.symptom = [paramMap[@"symptom"] intValue];
                sumary.total = [paramMap[@"total"] intValue];
                
                onSuccess(sumary);
                
            } else {
                
                onError(nil);
            }
        }
     ];
}

- (void) getSummary: (User *) user
        idHousehold: (NSString *) idHousehold
              month: (NSInteger) month
               year: (NSInteger) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url;
    
    if ([idHousehold isEqualToString:@""] || [idHousehold isEqualToString:user.idUser]) {
        url = [NSString stringWithFormat: @"%@/user/calendar/month?", [self getUrl]];
    } else {
        url = [NSString stringWithFormat: @"%@/household/calendar/month?household_id=%@", [self getUrl], idHousehold];
    }
    
    NSDictionary * paramMap = @{ @"month": [NSNumber numberWithInteger: month],
                                 @"year": [NSNumber numberWithInteger: year] };
    
    [self doGet: url
         header: @{ @"user_token": user.user_token,
                    @"app_token": user.app_token}
      parameter: paramMap
          start: onStart
          error: ^(AFHTTPRequestOperation * request, NSError * error) {
              onError(error);
          }
        success: ^(AFHTTPRequestOperation * request, id response) {
            
            if ([request.response statusCode] == Ok) {
                
                if ([response[@"error"] boolValue]) {
                    
                    onError(nil);
                    
                } else {
                    
                    NSMutableDictionary * sumaryCalendarMap = [NSMutableDictionary dictionary];
                    
                    NSDictionary * paramMap = response[@"data"];
                    
                    for (NSDictionary * key in paramMap) {
                        
                        NSDictionary * sumaryMap = key[@"_id"];
                        
                        NSString * keyMap = [NSString stringWithFormat: @"%@-%@-%@",
                                          [sumaryMap[@"day"] stringValue], [sumaryMap[@"month"] stringValue], [sumaryMap[@"year"] stringValue]];
                        
                        SumaryCalendar * sumaryCalendar = [sumaryCalendarMap objectForKey: keyMap];
                                                           
                        if (sumaryCalendar) {
                            
                            if ([sumaryMap[@"no_symptom"] isEqualToString: @"N"]) {
                                sumaryCalendar.symptomAmount = [key[@"count"] intValue];
                                
                            } else {
                                sumaryCalendar.noSymptomAmount = [key[@"count"] intValue];
                            }
                                                               
                        } else {
                            
                            SumaryCalendar * sumaryCalendar = [[SumaryCalendar alloc] init];
                            
                            sumaryCalendar.day = [sumaryMap[@"day"] intValue];
                            sumaryCalendar.month = [sumaryMap[@"month"] intValue];
                            sumaryCalendar.year = [sumaryMap[@"year"] intValue];
                            
                            if ([sumaryMap[@"no_symptom"] isEqualToString: @"N"]) {
                                sumaryCalendar.symptomAmount = [key[@"count"] intValue];
                                
                            } else {
                                sumaryCalendar.noSymptomAmount = [key[@"count"] intValue];
                            }
                            
                            [sumaryCalendarMap setValue: sumaryCalendar forKey: keyMap];
                        }
                    }
                    
                    onSuccess(sumaryCalendarMap);
                }
            
            } else {
                
                onError(nil);
            }
        }
     ];
}

- (void)getSummary:(User *)user
              date:(NSDate *)data
           onStart:(void (^)())onStart
         onSuccess:(void (^)(NSDictionary *))onSuccess
           onError:(void (^)(NSError *))onError{
    NSString *url = [[self getUrl] stringByAppendingString:@"/user/calendar/day?"];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:data];
    
    [self doGet:url
         header:@{@"user_token": user.user_token,
                  @"app_token": user.app_token}
      parameter:@{@"day": [NSString stringWithFormat:@"%d", (int) [components day]],
                  @"month": [NSString stringWithFormat:@"%d", (int) [components month]],
                  @"year": [NSString stringWithFormat:@"%d", (int) [components year]]}
          start:onStart
          error:^(AFHTTPRequestOperation *operation, NSError *error){
              onError(error);
          }
        success:^(AFHTTPRequestOperation *operation, id response){
            if ([operation.response statusCode] == Ok) {
                
                if ([response[@"error"] boolValue]) {
                    
                    onError(nil);
                    
                } else {
                    
                    NSMutableDictionary * sumaryGraphMap = [NSMutableDictionary dictionary];
                    
                    for (NSDictionary * jsonMap in response[@"data"]) {
                        
                        SumaryGraph * sumaryGraph = [[SumaryGraph alloc] init];
                        
                        NSDictionary * sumaryJson = jsonMap[@"_id"];
                        
                        sumaryGraph.month = [sumaryJson[@"month"] intValue];
                        sumaryGraph.year = [sumaryJson[@"year"] intValue];
                        sumaryGraph.count = [jsonMap[@"count"] intValue];
                        sumaryGraph.percent = [jsonMap[@"percent"] floatValue];
                        
                        [sumaryGraphMap setValue: sumaryGraph forKey: sumaryJson[@"month"]];
                    }
                    
                    onSuccess(sumaryGraphMap);
                }
                
            } else {
                
                onError(nil);
            }
        }];
}

- (void) getSummary: (User *) user
        idHousehold: (NSString *) idHousehold
               year: (int) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url;
    
    if ([idHousehold isEqualToString:@""] || [idHousehold isEqualToString:user.idUser]) {
        url = [NSString stringWithFormat: @"%@/user/calendar/year?", [self getUrl]];
    } else {
        url = [NSString stringWithFormat: @"%@/household/calendar/year?household_id=%@", [self getUrl], idHousehold];
    }
    
    [self doGet: url
         header: @{ @"user_token": user.user_token,
                    @"app_token": user.app_token}
      parameter: @{ @"year": [NSNumber numberWithInt: year] }
          start: onStart
     
          error: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(error);
          }
     
        success: ^(AFHTTPRequestOperation * request, id response) {
            
            if ([request.response statusCode] == Ok) {
                
                if ([response[@"error"] boolValue]) {
                    
                    onError(nil);
                    
                } else {
                    
                    NSMutableDictionary * sumaryGraphMap = [NSMutableDictionary dictionary];
                    
                    for (NSDictionary * jsonMap in response[@"data"]) {
                        
                        SumaryGraph * sumaryGraph = [[SumaryGraph alloc] init];
                        
                        NSDictionary * sumaryJson = jsonMap[@"_id"];
                        
                        sumaryGraph.month = [sumaryJson[@"month"] intValue];
                        sumaryGraph.year = [sumaryJson[@"year"] intValue];
                        sumaryGraph.count = [jsonMap[@"count"] intValue];
                        sumaryGraph.percent = [jsonMap[@"percent"] floatValue];
                        
                        [sumaryGraphMap setValue: sumaryGraph forKey: sumaryJson[@"month"]];
                    }
                         
                    onSuccess(sumaryGraphMap);
                }
            
            } else {
                
                onError(nil);
            }
        }
     ];
}

- (void) updateUser: (User *) user
          onSuccess: (void(^)(User* user)) success
             onFail: (void(^) (NSError *error)) fail{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:user.nick forKey:@"nick"];
    [params setValue:user.email forKey:@"email"];
    [params setValue:user.client forKey:@"client"];
    [params setValue:user.dob forKey:@"dob"];
    [params setValue:user.gender forKey:@"gender"];
    [params setValue:user.app_token forKey:@"app_token"];
    [params setValue:user.race forKey:@"race"];
    [params setValue:user.platform forKey:@"platform"];
    [params setValue:user.idUser forKey:@"id"];
    
    if (user.password) {
        [params setValue:user.password forKey:@"password"];
    }
    

    [params setValue:user.avatarNumber forKey:@"picture"];
    
    NSError *error;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:user.puzzleMatriz options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        [params setValue:jsonString forKey:@"puzzleMatriz"];
    }
    
    [params setValue:[NSString stringWithFormat:@"%d", user.level] forKey:@"level"];
    
    [self doPost:[[self getUrl] stringByAppendingString:@"/user/update"]
          header:@{@"user_token": user.user_token,
                   @"app_token": user.app_token}
       parameter:params
           start:^(void){
        
    }error:^(AFHTTPRequestOperation *request, NSError *error){
        fail(error);
    }success:^(AFHTTPRequestOperation *request, id response){
        // Update system's user
        User *sysUser = [User getInstance];
        sysUser.nick = user.nick;
        sysUser.email = user.email;
        sysUser.dob = user.dob;
        sysUser.gender = user.gender;
        sysUser.race = user.race;
        sysUser.avatarNumber = user.avatarNumber;
        
        //Call back success
        success(user);
    }];
}

-(void) getSymptonsOnStart: (void(^)()) onStart
                andSuccess: (void(^)(NSMutableArray *)) onSuccess
                andOnError: (void(^)(NSError *)) onError{
    User *user = [User getInstance];
    
    [self doGet:[[self getUrl] stringByAppendingString:@"/symptoms"]
         header:@{@"app_token": user.app_token,
                  @"user_token": user.user_token}
      parameter:nil
          start:onStart
          error:^(AFHTTPRequestOperation *operation, NSError *error){
            onError(error);
          }
        success:^(AFHTTPRequestOperation * request, id response){
            NSMutableArray *symptoms = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dicSymptom in response[@"data"]) {
                Symptom *symptom = [[Symptom alloc] init];
                symptom.code = dicSymptom[@"code"];
                symptom.name = dicSymptom[@"name"];
                
                [symptoms addObject:symptom];
            }
            
            onSuccess(symptoms);
        }];
}

-(void) lookupWithUsertoken: (NSString *) userToken
                    OnStart: (void(^)()) onStart
               andOnSuccess: (void(^)()) onSuccess
                 andOnError: (void(^)(NSError *, int)) onError{
    User * user = [User getInstance];
    
    [self doGet:[[self getUrl] stringByAppendingString:@"/user/lookup/"]
         header:@{@"app_token": user.app_token,
                  @"user_token": userToken}
      parameter:nil
          start:onStart
          error:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"%d", (int) operation.response.statusCode);
              onError(error, (int) operation.response.statusCode);
          }
        success:^(AFHTTPRequestOperation *operation, id responseObject){
            if ([responseObject[@"error"] boolValue] == 1) {
                user.user_token = nil;
            } else {
                NSDictionary *response = responseObject[@"data"];
                
                user.nick = response[@"nick"];
                user.email = response[@"email"];
                user.gender = response[@"gender"];
                user.idUser =  response[@"id"];
                user.race = response[@"race"];
                user.dob = response[@"dob"];
                user.user_token = response[@"token"];
                user.hashtag = response[@"hashtags"];
                user.survey = response[@"surveys"];
                
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                NSString *userKey = user.user_token;
                
                if ([preferences valueForKey:kPhotoKey] != nil) {
                    user.photo = [preferences valueForKey:kPhotoKey];
                }
                
                user.avatarNumber = response[@"picture"];
                
                [preferences setValue:userKey forKey:kUserTokenKey];
                BOOL didSave = [preferences synchronize];
                
                if (!didSave) {
                    user.user_token = nil;
                }
                
                onSuccess();
            }
        }];
}

- (void) checkSocialLoginWithToken:(NSString *)socialToken
                         andSocial:(SocialNetwork)socialType
                          andStart:(void (^)())onStart
                      andOnSuccess:(void (^)(User *))onSuccess
                          andError:(void (^)(NSError *))onError{
    User *user = [User getInstance];
    NSDictionary *params;
    
    
    switch (socialType) {
        case GdsGoogle:
            params = @{@"gl": socialToken};
            break;
            
        case GdsTwitter:
            params = @{@"tw": socialToken};
            break;
            
        case GdsFacebook:
            params = @{@"fb": socialToken};
            break;
            
        default:
            break;
    }
    
    [self doGet:[[self getUrl] stringByAppendingString:@"/user/get"]
         header:@{@"app_token": user.app_token}
      parameter:params
          start:onStart
          error:^(AFHTTPRequestOperation *operation, NSError *error){
              onError(error);
          }
        success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSArray *response = responseObject[@"data"];
            
            if ([responseObject[@"error"] boolValue] != 1 && response.count != 0) {
                NSDictionary *userObject = [response objectAtIndex:0];
                User *user = [[User alloc] init];
                
                user.nick = userObject[@"nick"];
                user.email = userObject[@"email"];
                user.gender = userObject[@"gender"];
                user.avatarNumber = userObject[@"picture"];
                user.idUser =  userObject[@"id"];
                user.race = userObject[@"race"];
                user.dob = userObject[@"dob"];
                user.hashtag = userObject[@"hashtags"];
                user.survey = userObject[@"surveys"];
                
                switch (socialType) {
                    case GdsGoogle:
                        user.gl = userObject[@"gl"];
                        break;
                        
                    case GdsTwitter:
                        user.tw = userObject[@"tw"];
                        break;
                        
                    case GdsFacebook:
                        user.fb = userObject[@"fb"];
                        break;
                        
                    default:
                        break;
                }
                
                onSuccess(user);
                
            } else {
                onError(nil);
            }
        }];
}

- (void)forgotPasswordWithEmail:(NSString *)email
                     andOnStart:(void (^)())onStart
                   andOnSuccess:(void (^)())onSuccess
                     andOnError:(void (^)(NSError *))onError{
    
    [self doPost:[[self getUrl] stringByAppendingString:@"/user/forgot-password"]
          header:@{}
       parameter:@{@"email":email}
           start:^{
               onStart();
           }
           error:^(AFHTTPRequestOperation *operation, NSError *error){
               onError(error);
           }
         success:^(AFHTTPRequestOperation *operation, id response){
             if ([response[@"error"] boolValue] == 1) {
                 onError(nil);
             }else{
                 onSuccess();
             }
         }];
}

- (void)reportBugWithTitle:(NSString *)title
                   andText:(NSString *)text
                andOnStart:(void (^)())onStart
              andOnSuccess:(void (^)())onSuccess
                andOnError:(void (^)(NSError *))onError{
    
    [self doPost:[[self getUrl] stringByAppendingString:@"/email/log"]
          header:@{@"user_token": [User getInstance].user_token}
       parameter:@{@"title":title,
                   @"text": text,
                   @"email": [User getInstance].email}
           start:onStart
           error:^(AFHTTPRequestOperation *operation, NSError *error){
               onError(error);
           }
         success:^(AFHTTPRequestOperation *operation, id response){
             if ([response[@"error"] boolValue] == 1) {
                 onError(nil);
             }else{
                 onSuccess();
             }
         }];
}

- (void) deleteAccountUser:(User *)user
                   onStart:(void (^)())onStart
                 onSuccess:(void (^)())onSuccess
                    onErro:(void (^)(NSError *))onError{
    
    NSString *url = [[self getUrl] stringByAppendingString:@"/user/delete/"];
    
    [self doDelete:url
            header:@{@"app_token": user.app_token,
                     @"user_token": user.user_token}
         parameter:nil
             start:onStart
             error:^(AFHTTPRequestOperation *operation, NSError *error){
                 onError(error);
             } success:^(AFHTTPRequestOperation *operation, id response){
                 onSuccess();
             }];
}

- (void)changePasswordWithUser: (User *)user
                   OldPassword: (NSString *) oldPassword
                   NewPassword: (NSString *) newPassword
                       onStart: (void(^)()) onStart
                     onSuccess: (void(^)()) onSuccess
                       onError: (void(^)(NSError *error)) onError{
    NSString *url = [[self getUrl] stringByAppendingString:@"/user/changepass/"];
    
    [self doPost:url
          header:@{@"app_token": user.app_token,
                   @"user_token": user.user_token}
       parameter:@{@"passwd": oldPassword,
                   @"passwdn": newPassword}
           start:onStart
           error:^(AFHTTPRequestOperation *operation, NSError *error){
               if ([operation.response statusCode] == 401) {
                   onError(nil);
               }else{
                   onError(error);
               }
           } success:^(AFHTTPRequestOperation *operation, id response){
               onSuccess();
           }];
}

@end
