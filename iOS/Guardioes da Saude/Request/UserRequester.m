// Igor Morais

#import "Constants.h"
#import "StatusCode.h"
#import "Sumary.h"
#import "SumaryCalendar.h"
#import "SumaryGraph.h"
#import "UserRequester.h"

@implementation UserRequester

- (void) login: (User *) user
       onStart: (Start) onStart
       onError: (Error) onError
     onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/user/login", Url];
    
    NSDictionary * paramMap = @{ @"email": user.email,
                                 @"password": user.password };
    
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
                     user.picture = paramMap[@"picture"];
                     user.idUser =  paramMap[@"id"];
                     user.race = paramMap[@"race"];
                     user.dob = paramMap[@"dob"];
                     user.user_token = response[@"token"];
                     user.hashtag = paramMap[@"hashtags"];
                     user.household = paramMap[@"household"];
                     user.survey = paramMap[@"surveys"];
                     
                     onSuccess(user);
                 }
             
             } else {
                 
                 onError(nil);
             }
         }
    ];
}

- (void) createAccount: (User *) user
               onStart: (Start) onStart
               onError: (Error) onError
             onSuccess: (Success) onSuccess {
}

- (void) getSummary: (User *) user
        idHousehold: (NSString *)idHousehold
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url;
    
    if ([idHousehold isEqualToString:@""] || [idHousehold isEqualToString:user.idUser]) {
        url = [NSString stringWithFormat: @"%@/user/survey/summary", Url];
    } else {
        url = [NSString stringWithFormat: @"%@/household/survey/summary?household_id=%@", Url, idHousehold];
    }
    
    [self doGet: url
         header: @{ @"user_token": user.user_token }
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
        url = [NSString stringWithFormat: @"%@/user/calendar/month?", Url];
    } else {
        url = [NSString stringWithFormat: @"%@/household/calendar/month?household_id=%@", Url, idHousehold];
    }
    
    NSDictionary * paramMap = @{ @"month": [NSNumber numberWithInteger: month],
                                 @"year": [NSNumber numberWithInteger: year] };
    
    [self doGet: url
         header: @{ @"user_token": user.user_token }
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

- (void) getSummary: (User *) user
        idHousehold: (NSString *) idHousehold
               year: (int) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url;
    
    if ([idHousehold isEqualToString:@""] || [idHousehold isEqualToString:user.idUser]) {
        url = [NSString stringWithFormat: @"%@/user/calendar/year?", Url];
    } else {
        url = [NSString stringWithFormat: @"%@/household/calendar/year?household_id=%@", Url, idHousehold];
    }
    
    [self doGet: url
         header: @{ @"user_token": user.user_token }
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
    [params setValue:user.picture forKey:@"picture"];
    [params setValue:user.idUser forKey:@"id"];
    
    if (user.password) {
        [params setValue:user.password forKey:@"password"];
    }
    
    
    [self doPost:@"http://api.guardioesdasaude.org/user/update"
          header:@{@"user_token": user.user_token, @"app_token": user.app_token}
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
        sysUser.picture = user.picture;
        
        //Call back success
        success(user);
    }];
}

-(void) getSymptonsOnStart: (void(^)()) onStart
                andSuccess: (void(^)()) onSuccess
                andOnError: (void(^)(NSError *)) onError{
    User *user = [User getInstance];
    
    [self doGet:[Url stringByAppendingString:@"/symptoms"]
         header:@{@"app_token": user.app_token,
                  @"user_token": user.user_token}
      parameter:nil
          start:onStart
          error:^(AFHTTPRequestOperation *operation, NSError *error){
            onError(error);
          }
        success:^(AFHTTPRequestOperation * request, id response){
            user.symptoms = response[@"data"];
            onSuccess();
        }];
}

-(void) lookupWithUsertoken: (NSString *) userToken
                    OnStart: (void(^)()) onStart
               andOnSuccess: (void(^)()) onSuccess
                 andOnError: (void(^)(NSError *)) onError{
    User * user = [User getInstance];
    
    [self doGet:[Url stringByAppendingString:@"/user/lookup/"]
         header:@{@"app_token": user.app_token,
                  @"user_token": userToken}
      parameter:nil
          start:onStart
          error:^(AFHTTPRequestOperation *operation, NSError *error){
              onError(error);
          }
        success:^(AFHTTPRequestOperation *operation, id responseObject){
            if ([responseObject[@"error"] boolValue] == 1) {
                user.user_token = nil;
            } else {
                NSDictionary *response = responseObject[@"data"];
                
                user.nick = response[@"nick"];
                user.email = response[@"email"];
                user.gender = response[@"gender"];
                user.picture = response[@"picture"];
                user.idUser =  response[@"id"];
                user.race = response[@"race"];
                user.dob = response[@"dob"];
                user.user_token = response[@"token"];
                user.hashtag = response[@"hashtags"];
                user.household = response[@"household"];
                user.survey = response[@"surveys"];
                
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                NSString *userKey = user.user_token;
                
                [preferences setValue:userKey forKey:@"userTokenKey"];
                BOOL didSave = [preferences synchronize];
                
                if (!didSave) {
                    user.user_token = nil;
                }
                
                onSuccess();
            }
        }];
}

@end
