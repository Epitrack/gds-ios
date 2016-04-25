#import "SurveyRequester.h"
#import "Constants.h"
#import "StatusCode.h"
#import "SumaryLocation.h"

@implementation SurveyRequester

- (void)createSurvey:(SurveyMap *)survey
          andOnStart:(void (^)())onStart
        andOnSuccess:(void (^)(SurveyType))onSuccess
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
    
    if (survey.travelLocation && ![survey.travelLocation isEqualToString:@""]) {
        [params setObject:survey.travelLocation forKey:@"travelLocation"];
    }

    if ([survey.isSymptom isEqualToString:@"Y"]) {
        [params setValue:@"N" forKey:@"no_symptom"];
    } else {
        [params setValue:@"Y" forKey:@"no_symptom"];
    }
    
    
    if (survey.idHousehold && ![survey.idHousehold isEqualToString:@""]) {
        [params setValue:survey.idHousehold forKey:@"household_id"];
    }
    
    [params addEntriesFromDictionary:survey.symptoms];
    
    [self doPost:[NSString stringWithFormat:@"%@/survey/create", [self getUrl]]
          header:@{@"app_token": user.app_token}
       parameter:params
           start:onStart
   error:^(AFHTTPRequestOperation *operation, NSError *error){
       onError(error);
    }success:^(AFHTTPRequestOperation *operation, id responseObject){
        if ([responseObject[@"exantematica"] integerValue] != 0){
            onSuccess(EXANTEMATICA);
        } else if ([responseObject[@"diarreica"] integerValue] != 0) {
            onSuccess(DIARREICA);
        } else if ([responseObject[@"respiratoria"] integerValue] != 0) {
            onSuccess(RESPIRATORIA);
        } else{
            onSuccess(BAD_SYMPTOM);
        }
    }];
}

- (void) getSummary: (User *) user
           location: (NSString *) location
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/surveys/summary?", [self getUrl]];
    
    [self doGet: url
         header: @{ @"user_token": user.user_token,
                    @"app_token": user.app_token}
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
            onStart: (void(^)()) onStart
            onError: (void(^)(NSError *)) onError
          onSuccess: (void(^)(NSDictionary *)) onSuccess {
    
    NSString * url = [NSString stringWithFormat: @"%@/surveys/summary", [self getUrl]];
    
    [self doGet: url
         header: @{ @"app_token": user.app_token,
                    @"user_token": user.user_token }
      parameter: @{ @"lat": [NSNumber numberWithDouble: latitude],
                    @"lon": [NSNumber numberWithDouble: longitude] }
          start: onStart
          error: ^(AFHTTPRequestOperation * request, NSError * error) {
              onError(error);
          }
        success: ^(AFHTTPRequestOperation * request, id response) {
            if ([request.response statusCode] == Ok) {
                
                if ([response[@"error"] boolValue]) {
                    
                    onError(nil);
                    
                } else {
                    onSuccess(response);
                }
                
            } else {
                
                onError(nil);
            }
        }
     ];
}

- (void)getSurveyByLatitude:(double)latitude
               andLongitude:(double)longitude
                    onStart:(void (^)())onStart
                  onSuccess:(void (^)(NSArray *))onSuccess
                    onError:(void (^)(NSError *))onError{
    User *user = [User getInstance];
    
    [self doGet:[NSString stringWithFormat:@"%@/surveys/l", [self getUrl]]
          header:@{@"app_token": user.app_token,
                   @"user_token": user.user_token}
       parameter:@{@"lon": [NSString stringWithFormat:@"%f", longitude],
                   @"lat": [NSString stringWithFormat:@"%f", latitude]}
           start:onStart
           error:^(AFHTTPRequestOperation *operation, NSError *error){
               onError(error);
           }
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             NSMutableArray *surveysMap = [[NSMutableArray alloc] init];
             NSDictionary *surveys = responseObject[@"data"];
             
             for (NSDictionary *item in surveys) {
                 NSString *surveyLatitude = item[@"lat"];
                 NSString *surveyLongitude = item[@"lon"];
                 NSString *isSymptom = item[@"no_symptom"];
                 NSString *survey_id = item[@"id"];
                 
                 if (surveyLatitude != 0 || surveyLongitude != 0) {
                     SurveyMap *s = [[SurveyMap alloc] initWithLatitude:surveyLatitude andLongitude:surveyLongitude andSymptom:isSymptom];
                     s.survey_id = survey_id;
                     [surveysMap addObject:s];
                 }
             }
             
             onSuccess(surveysMap);
         }];
}
@end
