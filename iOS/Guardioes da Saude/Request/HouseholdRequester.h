#import "Requester.h"
#import "Household.h"
#import "User.h"

@interface HouseholdRequester : Requester

- (void) getSummary: (User *) user
          household: (Household *) household
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

- (void) getSummary: (User *) user
          household: (Household *) household
              month: (int) month
               year: (int) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

- (void) getSummary: (User *) user
          household: (Household *) household
               year: (int) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

@end
