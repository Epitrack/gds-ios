// Igor Morais

#import "Requester.h"
#import "User.h"

NSString * const kMsgConnectionError = @"constant.check_connection";
NSString * const kMsgApiError = @"constant.comunication_error";

@implementation Requester

- (void) doGet: (NSString *) url
        header: (NSDictionary *) headerMap
     parameter: (id) parameter
         start: (void (^)()) onStart
         error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
       success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess {
    
    onStart();
    
    AFHTTPRequestOperationManager * manager = [self configRequestOperationManager];
    
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.securityPolicy setValidatesDomainName:NO];
    
    for (NSString * key in headerMap) {
        
        [manager.requestSerializer setValue: [headerMap objectForKey: key]
                         forHTTPHeaderField: key];
    }
    
    [manager GET: url
      parameters: parameter
         success: ^(AFHTTPRequestOperation * request, id response) {
             
             onSuccess(request, response);
         }
     
         failure: ^(AFHTTPRequestOperation * request, NSError * error) {
             
             onError(request, error);
         }
    ];
}

- (void) doGet: (NSString *) url
        header: (NSDictionary *) headerMap
     parameter: (id) parameter
    serializer: (AFHTTPResponseSerializer *) serializer
         start: (void (^)()) onStart
         error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
       success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess {
    
    onStart();
    
    AFHTTPRequestOperationManager * manager = [self configRequestOperationManager];
    
    manager.responseSerializer = serializer;
    
    for (NSString * key in headerMap) {
        
        [manager.requestSerializer setValue: [headerMap objectForKey: key]
                         forHTTPHeaderField: key];
    }
    
    [manager GET: url
      parameters: parameter
         success: ^(AFHTTPRequestOperation * request, id response) {
             
             onSuccess(request, response);
         }
     
         failure: ^(AFHTTPRequestOperation * request, NSError * error) {
             
             onError(request, error);
         }
     ];
}

- (void) doPost: (NSString *) url
         header: (NSDictionary *) headerMap
      parameter: (id) parameter
          start: (void (^)()) onStart
          error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
        success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess {
    
    onStart();
    
    AFHTTPRequestOperationManager * manager = [self configRequestOperationManager];
    
    for (NSString * key in headerMap) {
        
        [manager.requestSerializer setValue: [headerMap objectForKey: key]
                         forHTTPHeaderField: key];
    }
    
    [manager POST: url
       parameters: parameter
          success: ^(AFHTTPRequestOperation * request, id response) {
              
              onSuccess(request, response);
          }
     
          failure: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(request, error);
          }
     ];
}

- (void) doPost: (NSString *) url
         header: (NSDictionary *) headerMap
      parameter: (id) parameter
     serializer: (AFHTTPResponseSerializer *) serializer
          start: (void (^)()) onStart
          error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
        success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess {
    
    onStart();
    
    AFHTTPRequestOperationManager * manager = [self configRequestOperationManager];
    
    manager.responseSerializer = serializer;
    
    for (NSString * key in headerMap) {
        
        [manager.requestSerializer setValue: [headerMap objectForKey: key]
                         forHTTPHeaderField: key];
    }
    
    [manager POST: url
       parameters: parameter
          success: ^(AFHTTPRequestOperation * request, id response) {
              
              onSuccess(request, response);
          }
     
          failure: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(request, error);
          }
     ];
}

- (void) doDelete: (NSString *) url
           header: (NSDictionary *) headerMap
        parameter: (id) parameter
            start: (void (^)()) onStart
            error: (void (^)(AFHTTPRequestOperation * request, NSError * error)) onError
          success: (void (^)(AFHTTPRequestOperation * request, id response)) onSuccess {
    
    onStart();
    
    AFHTTPRequestOperationManager * manager = [self configRequestOperationManager];
    
    for (NSString * key in headerMap) {
        
        [manager.requestSerializer setValue: [headerMap objectForKey: key]
                         forHTTPHeaderField: key];
    }
    
    [manager DELETE: url
       parameters: parameter
          success: ^(AFHTTPRequestOperation * request, id response) {
              
              onSuccess(request, response);
          }
     
          failure: ^(AFHTTPRequestOperation * request, NSError * error) {
              
              onError(request, error);
          }
     ];
}

+ (bool) isConnected{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (AFHTTPRequestOperationManager *) configRequestOperationManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.securityPolicy setValidatesDomainName:NO];
    
    return manager;
}

- (NSString *) getUrl{
    
    if ([User getInstance].isTest) {
        return @"http://dev.guardioesdasaude.org";
    }else{
        return @"https://api.guardioesdasaude.org";
    }
}

@end
