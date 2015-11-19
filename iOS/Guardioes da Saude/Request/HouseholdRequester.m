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
    
    NSString * url = [NSString stringWithFormat: @"%@/household/survey/summary?", Url];
    
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
    
    NSString * url = [NSString stringWithFormat: @"%@/household/calendar/month?", Url];
    
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
    
    NSString * url = [NSString stringWithFormat: @"%@/household/calendar/year?", Url];
    
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

@end
