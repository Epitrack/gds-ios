import Alamofire

class RequestManager {
    
    func a() {
        Alamofire.request(.GET, "http://httpbin.org/get")
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
        }
    }
//    
//    func request(method: Method, url: URLStringConvertible, parameterMap: [String : AnyObject]? = nil, encoding: ParameterEncoding = .URL) {
//        
//        Alamofire.request(method, url, parameters: parameterMap, encoding: encoding).validate().responseJSON(options: <#NSJSONReadingOptions#>, completionHandler: <#(NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void##(NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void#>)
//    }completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void)
    
    func request <T: NSObject> (method: Method, url: URLStringConvertible, parameterMap: [String : AnyObject]? = nil, encoding: ParameterEncoding = .URL
        , onError: (NSError), onSuccess: (T)) {
        
        Alamofire.request(method, url, parameters: parameterMap, encoding: encoding)
                 .validate()
                 .responseJSON { (request, response, json, error) in
                    
                    if let error = error {
                        
                        onError(error)
                        
                    } else {
                        
                    }
        }
    }
    
}
