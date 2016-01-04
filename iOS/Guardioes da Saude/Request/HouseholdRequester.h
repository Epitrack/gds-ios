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

- (void) getHouseholdsByUser: (User *) user
                   onSuccess: (void (^)(NSMutableArray *households)) success
                      onFail: (void (^)(NSError * erro)) failure;

- (void) updateHousehold: (Household *) household
               onSuccess: (void(^)(void)) success
                  onFail: (void(^) (NSError *error)) fail;

- (void) createHousehold: (Household *) household
               onSuccess: (void(^)(void)) success
                  onFail: (void(^) (NSError *error)) fail;

@end
