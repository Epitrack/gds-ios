#import "Requester.h"
#import "User.h"

@interface SurveyRequester : Requester

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
