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

- (void) getSummary: (User *) user
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

- (void) getSummary: (User *) user
              month: (NSInteger) month
               year: (NSInteger) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

- (void) getSummary: (User *) user
               year: (int) year
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;
@end
