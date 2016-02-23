// Igor Morais

#import "AFHTTPRequestOperationManager.h"

#import <Foundation/Foundation.h>

extern NSString * const kMsgConnectionError;
extern NSString * const kMsgApiError;

@interface Requester : NSObject

typedef void (^ Start) ();
typedef void (^ Error) (id);
typedef void (^ Success) (id);

- (void) doGet: (NSString *) url
        header: (NSDictionary *) headerMap
     parameter: (id) parameter
         start: (void (^)()) onStart
         error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
       success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess;

- (void) doGet: (NSString *) url
        header: (NSDictionary *) headerMap
     parameter: (id) parameter
    serializer: (AFHTTPResponseSerializer *) serializer
         start: (void (^)()) onStart
         error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
       success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess;

- (void) doPost: (NSString *) url
         header: (NSDictionary *) headerMap
      parameter: (id) parameter
          start: (void (^)()) onStart
          error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
        success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess;

- (void) doPost: (NSString *) url
         header: (NSDictionary *) headerMap
      parameter: (id) parameter
     serializer: (AFHTTPResponseSerializer *) serializer
          start: (void (^)()) onStart
          error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
        success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess;

+ (bool) isConnected;

@end
