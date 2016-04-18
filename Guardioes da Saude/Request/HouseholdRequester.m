#import "HouseholdRequester.h"
#import "StatusCode.h"
#import "Constants.h"
#import "Sumary.h"
#import "SumaryCalendar.h"
#import "SumaryGraph.h"

@implementation HouseholdRequester

- (void) getSummary: (User *) user
          household: (Household *) household
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/household/survey/summary?", [self getUrl]];
    
    [self doGet: url
         header: @{ @"user_token": user.user_token }
      parameter: @{ @"household_id": household.idHousehold }
          start: onStart
     
          error: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(error);
          }
     
        success: ^(AFHTTPRequestOperation * request, id response) {
            
            if ([request.response statusCode] == Ok) {
                
                NSDictionary * paramMap = response[@"data"];
                
                Sumary * sumary = [[Sumary alloc] init];
                
                sumary.noSymptom = [paramMap[@"no_smptom"] intValue];
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
          household: (Household *) household
              month: (int) month
               year: (int) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/household/calendar/month?", [self getUrl]];
    
    NSDictionary * paramMap = @{ @"month": [NSNumber numberWithInt: month],
                                 @"year": [NSNumber numberWithInt: year],
                                 @"household_id": household.idHousehold };
    
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
                        
                        SumaryCalendar * sumaryCalendar = [sumaryCalendarMap objectForKey: sumaryMap[@"day"]];
                        
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
                            sumaryCalendar.year = [sumaryMap[@"day"] intValue];
                            
                            if ([sumaryMap[@"no_symptom"] isEqualToString: @"N"]) {
                                sumaryCalendar.symptomAmount = [key[@"count"] intValue];
                                
                            } else {
                                sumaryCalendar.noSymptomAmount = [key[@"count"] intValue];
                            }
                            
                            [sumaryCalendarMap setValue: sumaryCalendar forKey: sumaryMap[@"day"]];
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
          household: (Household *) household
               year: (int) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/household/calendar/year?", [self getUrl]];
    
    [self doGet: url
         header: @{ @"user_token": user.user_token }
      parameter: @{ @"year": [NSNumber numberWithInt: year],
                    @"household_id": household.idHousehold }
     
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

- (void) getHouseholdsByUser: (User *) user
                        onSuccess: (void (^)(NSMutableArray *households)) success
                           onFail: (void (^)(NSError * erro)) failure{
    NSString *idUSer = user.idUser;
    NSString *url = [NSString stringWithFormat: @"%@/user/household/%@", [self getUrl], idUSer];
    
    AFHTTPRequestOperationManager *manager;
    manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:user.app_token forHTTPHeaderField:@"app_token"];
    [manager.requestSerializer setValue:user.user_token forHTTPHeaderField:@"user_token"];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSMutableArray *houseHolds = [[NSMutableArray alloc] init];
             NSDictionary *households = responseObject[@"data"];
             
             
             for(NSDictionary *dicHousehold in households){
                 NSString *picture = dicHousehold[@"picture"];
                 NSString *avatar;
                 if (picture.length > 2) {
                     avatar = @"img_profile01.png";
                 } else if (picture.length == 1) {
                     avatar = [NSString stringWithFormat: @"img_profile0%@.png", picture];
                 } else if (picture.length == 2) {
                     avatar = [NSString stringWithFormat: @"img_profile%@.png", picture];
                 }
                 
                 
                 Household *household = [[Household alloc] initWithNick:dicHousehold[@"nick"]
                                                               andEmail:dicHousehold[@"email"]
                                                                 andDob:dicHousehold[@"dob"]
                                                              andGender:dicHousehold[@"gender"]
                                                                andRace:dicHousehold[@"race"]
                                                              andIdUser:dicHousehold[@"user"][@"id"]
                                                             andPicture:avatar
                                                           andIdPicture: picture
                                                         andIdHousehold:dicHousehold[@"id"]
                                                        andRelationship:dicHousehold[@"relationship"]];
                 [houseHolds addObject:household];
             }
             
             success(houseHolds);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
}

- (void) updateHousehold: (Household *) household
          onSuccess: (void(^)(void)) success
             onFail: (void(^) (NSError *error)) fail{
    User *user = [User getInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:household.nick forKey:@"nick"];
    [params setValue:user.client forKey:@"client"];
    [params setValue:household.dob forKey:@"dob"];
    [params setValue:household.gender forKey:@"gender"];
    [params setValue:user.app_token forKey:@"app_token"];
    [params setValue:household.race forKey:@"race"];
    [params setValue:user.platform forKey:@"platform"];
    [params setValue:household.picture forKey:@"picture"];
    [params setValue:household.idHousehold forKey:@"id"];
    [params setValue:household.relationship forKey:@"relationship"];
    
    if (![household.email isEqualToString:@""]) {
        [params setValue:household.email forKey:@"email"];
    }
    
    [self doPost:[[self getUrl] stringByAppendingString:@"/household/update"]
          header:@{@"user_token": user.user_token,
                   @"app_token": user.app_token}
       parameter:params
           start:^(void){
               
           }error:^(AFHTTPRequestOperation *request, NSError *error){
               fail(error);
           }success:^(AFHTTPRequestOperation *request, id response){
               success();
           }];
}

- (void) createHousehold: (Household *) household
               onSuccess: (void(^)(void)) success
                  onFail: (void(^) (NSError *error)) fail{
    User *user = [User getInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:household.nick forKey:@"nick"];
    [params setValue:user.client forKey:@"client"];
    [params setValue:household.dob forKey:@"dob"];
    [params setValue:household.gender forKey:@"gender"];
    [params setValue:household.race forKey:@"race"];
    [params setValue:user.platform forKey:@"platform"];
    [params setValue:household.picture forKey:@"picture"];
    [params setValue:household.relationship forKey:@"relationship"];
    [params setValue:user.idUser forKey:@"user"];
    
    if (![household.email isEqualToString:@""]) {
        [params setValue:household.email forKey:@"email"];
    }
    
    [self doPost:[[self getUrl] stringByAppendingString:@"/household/create"]
          header:@{@"user_token": user.user_token,
                   @"app_token": user.app_token}
       parameter:params
           start:^(void){
               
           }error:^(AFHTTPRequestOperation *request, NSError *error){
               fail(error);
           }success:^(AFHTTPRequestOperation *request, id response){
               success();
           }];
}

- (void) deleteHouseholdWithId:(NSString *)idHousehold
                   andOnStart:(void (^)())onStart
                 andOnSuccess:(void (^)())onSuccess
                   andOnError:(void (^)(NSError *))onError{
    User *user = [User getInstance];
    NSString *url = [NSString stringWithFormat: @"%@/household/delete/%@?client=api", [self getUrl], idHousehold];
    [self doGet:url
         header:@{@"user_token": user.user_token,
                  @"app_token": user.app_token}
      parameter:@{}
          start:onStart
          error:^(AFHTTPRequestOperation *operation, NSError *error){
              onError(error);
          }
        success:^(AFHTTPRequestOperation *operation, id response){
            onSuccess();
        }];
}

@end
