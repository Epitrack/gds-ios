#import "SurveyRequester.h"
#import "Constants.h"
#import "StatusCode.h"
#import "SumaryLocation.h"

@implementation SurveyRequester

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
