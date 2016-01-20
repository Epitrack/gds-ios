#import "Requester.h"
#import "User.h"
#import "SurveyMap.h"

@interface SurveyRequester : Requester

- (void) createSurvey:(SurveyMap *) survey
           andOnStart:(void(^)()) onStart
         andOnSuccess:(void(^)(bool)) onSuccess
           andOnError:(void(^)(NSError *)) onError;

- (void) getSummary: (User *) user
           location: (NSString *) location
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

- (void) getSummary: (User *) user
           latitude: (double) latitude
          longitude: (double) longitude
            onStart: (void(^)()) onStart
            onError: (void(^)(NSError *)) onError
          onSuccess: (void(^)(NSDictionary *)) onSuccess;

- (void) getSurveyByLatitude:(double) latitude
                andLongitude:(double) longitude
                     onStart:(void(^)())onStart
                   onSuccess:(void(^)(NSArray *)) onSuccess
                     onError:(void(^)(NSError *)) onError;

@end
