// Igor Morais

#import "User.h"
#import "Requester.h"

@interface UserRequester : Requester

- (void) login: (User *) user
       onStart: (Start) onStart
       onError: (Error) onError
     onSuccess: (Success) onSuccess;

- (void) createAccount: (User *) user
               onStart: (Start) onStart
               onError: (Error) onError
             onSuccess: (Success) onSuccess;

/*- (void) getSummary: (User *) user
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;*/

- (void) getSummary: (User *) user
        idHousehold: (NSString *) idHousehold
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

- (void) getSummary: (User *) user
        idHousehold: (NSString *) idHousehold
              month: (NSInteger) month
               year: (NSInteger) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

- (void) getSummary: (User *) user
        idHousehold: (NSString *) idHousehold
               year: (int) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

- (void) updateUser: (User *) user
          onSuccess: (void(^)(User* user)) success
             onFail: (void(^) (NSError *error)) fail;
@end
