// Igor Morais

#import "User.h"
#import "Requester.h"

@interface UserRequester : Requester

typedef enum {
    GdsGoogle,
    GdsFacebook,
    GdsTwitter
} SocialNetwork;

- (void) login: (User *) user
       onStart: (Start) onStart
       onError: (Error) onError
     onSuccess: (Success) onSuccess;

- (void) createAccountWithUser: (User *) user
                    andOnStart: (void(^)()) onStart
                  andOnSuccess: (void(^)(User *user)) onSuccess
                    andOnError: (void(^)(NSError *)) onError ;

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

-(void) getSymptonsOnStart: (void(^)()) onStart
                andSuccess: (void(^)()) onSuccess
                andOnError: (void(^)(NSError *)) onError;

-(void) lookupWithUsertoken: (NSString *) userToken
                    OnStart: (void(^)()) onStart
               andOnSuccess: (void(^)()) onSuccess
                 andOnError: (void(^)(NSError *)) onError;

- (void) checkSocialLoginWithToken:(NSString *)socialToken
                         andSocial:(SocialNetwork)socialType
                          andStart:(void (^)())onStart
                      andOnSuccess:(void (^)(User *))onSuccess
                          andError:(void (^)(NSError *))onError;

- (void) forgotPasswordWithEmail: (NSString *)email
                      andOnStart:(void(^)())onStart
                    andOnSuccess:(void(^)())onSuccess
                      andOnError:(void(^)(NSError *))onError;

- (void) reportBugWithTitle:(NSString *) title
                    andText:(NSString *) text
                 andOnStart:(void(^)())onStart
               andOnSuccess:(void(^)())onSuccess
                 andOnError:(void(^)(NSError *))onError;
 @end
