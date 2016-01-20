#import "SurveyRequester.h"
#import "Constants.h"
#import "StatusCode.h"
#import "SumaryLocation.h"

@implementation SurveyRequester

- (void)createSurvey:(SurveyMap *)survey
          andOnStart:(void (^)())onStart
        andOnSuccess:(void (^)(bool))onSuccess
          andOnError:(void (^)(NSError *))onError{
    
    User *user = [User getInstance];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:user.idUser forKey:@"user_id"];
    [params setValue:survey.latitude forKey:@"lat"];
    [params setValue:survey.longitude forKey:@"lon"];
    [params setValue:user.app_token forKey:@"app_token"];
    [params setValue:user.client forKey:@"client"];
    [params setValue:user.platform forKey:@"platform"];
    [params setValue:user.user_token forKey:@"token"];
    [params setObject:survey.travelLocation forKey:@"travelLocation"];

    if ([survey.isSymptom isEqualToString:@"Y"]) {
        [params setValue:@"N" forKey:@"no_symptom"];
    } else {
        [params setValue:@"Y" forKey:@"no_symptom"];
    }
    
    
    if (![user.idHousehold isEqualToString:@""] && user.idHousehold  != nil) {
        [params setValue:user.idHousehold forKey:@"household_id"];
    }
    
    [params addEntriesFromDictionary:survey.symptoms];
    
    [self doPost:[NSString stringWithFormat:@"%@/survey/create", Url]
          header:@{@"app_token": user.app_token}
       parameter:params
           start:onStart
   error:^(AFHTTPRequestOperation *operation, NSError *error){
       onError(error);
    }success:^(AFHTTPRequestOperation *operation, id responseObject){
        onSuccess([responseObject[@"exantematica"] integerValue] != 0);
    }];
}

- (void) getSummary: (User *) user
           location: (NSString *) location
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/surveys/summary?", Url];
    
    [self doGet: url
         header: @{ @"user_token": user.user_token }
      parameter: @{ @"q=": location }
          start: onStart
     
          error: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(error);
          }
     
        success: ^(AFHTTPRequestOperation * request, id response) {
            
            if ([request.response statusCode] == Ok) {
                
                if ([response[@"error"] boolValue]) {
                    
                    onError(nil);
                    
                } else {
                    
                    NSDictionary * jsonMap = response[@"data"];
                    
                    SumaryLocation * sumaryLocation = [[SumaryLocation alloc] init];
                    
                    sumaryLocation.diarreica = [jsonMap[@"diarreica"] intValue];
                    sumaryLocation.exantematica = [jsonMap[@"exantematica"] intValue];
                    sumaryLocation.respiratoria = [jsonMap[@"respiratoria"] intValue];
                    sumaryLocation.state = jsonMap[@"state"];
                    sumaryLocation.city = jsonMap[@"diarreica"];
                    sumaryLocation.formattedAddress = jsonMap[@"diarreica"];
                    sumaryLocation.totalSurvey = [jsonMap[@"total_surveys"] intValue];
                    sumaryLocation.totalNoSymptom = [jsonMap[@"total_no_symptoms"] intValue];
                    sumaryLocation.totalSymptom = [jsonMap[@"total_symptoms"] intValue];
                    
                    onSuccess(sumaryLocation);
                }
                
            } else {
                
                onError(nil);
            }
        }
     ];
}

- (void) getSummary: (User *) user
           latitude: (double) latitude
          longitude: (double) longitude
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/surveys/summary?", Url];
    
    [self doGet: url
         header: @{ @"user_token": user.user_token }
      parameter: @{ @"latitude": [NSNumber numberWithDouble: latitude],
                    @"longitude": [NSNumber numberWithDouble: longitude] }
     
          start: onStart
     
          error: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(error);
          }
     
        success: ^(AFHTTPRequestOperation * request, id response) {
            
            if ([request.response statusCode] == Ok) {
                
                if ([response[@"error"] boolValue]) {
                    
                    onError(nil);
                    
                } else {
                    
                    NSDictionary * jsonMap = response[@"data"];
                    
                    SumaryLocation * sumaryLocation = [[SumaryLocation alloc] init];
                    
                    sumaryLocation.diarreica = [jsonMap[@"diarreica"] intValue];
                    sumaryLocation.exantematica = [jsonMap[@"exantematica"] intValue];
                    sumaryLocation.respiratoria = [jsonMap[@"respiratoria"] intValue];
                    sumaryLocation.state = jsonMap[@"state"];
                    sumaryLocation.city = jsonMap[@"diarreica"];
                    sumaryLocation.formattedAddress = jsonMap[@"diarreica"];
                    sumaryLocation.totalSurvey = [jsonMap[@"total_surveys"] intValue];
                    sumaryLocation.totalNoSymptom = [jsonMap[@"total_no_symptoms"] intValue];
                    sumaryLocation.totalSymptom = [jsonMap[@"total_symptoms"] intValue];
                    
                    onSuccess(sumaryLocation);
                }
                
            } else {
                
                onError(nil);
            }
        }
     ];
}

@end
