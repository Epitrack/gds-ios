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
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

@end
