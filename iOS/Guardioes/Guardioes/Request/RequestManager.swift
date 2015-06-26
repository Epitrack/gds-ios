import Alamofire
import OCMapper

class RequestManager {
    
    func request(method: Alamofire.Method,
                 url: URLStringConvertible,
                 onError: (NSError) -> Void,
                 onSuccess: (String) -> Void) {
                    
        Alamofire.request(method, url, encoding: .JSON)
                 .validate()
                 .responseJSON { (request, response, json, error) in
                    
            if let json: AnyObject = json {
                onSuccess(json as! String)
            
            } else if let error = error {
                onError(error)
            }
        }
    }
    
    func request(method: Alamofire.Method,
                 url: URLStringConvertible,
                 parameterMap: [String : AnyObject],
                 onError: (NSError) -> Void,
                 onSuccess: (String) -> Void) {
                    
        Alamofire.request(method, url, parameters: parameterMap, encoding: .JSON)
                 .validate()
                 .responseJSON { (request, response, json, error) in
                    
            if let json: AnyObject = json {
                onSuccess(json as! String)
                        
            } else if let error = error {
                onError(error)
            }
        }
    }
    
    func request(method: Alamofire.Method,
                 url: URLStringConvertible,
                 parameterMap: [String : AnyObject],
                 encoding: ParameterEncoding,
                 onError: (NSError) -> Void,
                 onSuccess: (String) -> Void) {
                    
        Alamofire.request(method, url, parameters: parameterMap, encoding: encoding)
                 .validate()
                 .responseJSON { (request, response, json, error) in
                    
            if let json: AnyObject = json {
                onSuccess(json as! String)
            
            } else if let error = error {
                onError(error)
            }
        }
    }
    
    func request <Type: NSObject> (method: Alamofire.Method,
                                   url: URLStringConvertible,
                                   type: Type.Type,
                                   onError: (NSError) -> Void,
                                   onSuccess: (Type) -> Void) {
                                    
        Alamofire.request(method, url, encoding: .JSON)
                 .validate()
                 .responseJSON { (request, response, json, error) in
                    
            if let json: AnyObject = json {
                
                let entity = ObjectMapper.sharedInstance()
                                         .objectFromSource(json, toInstanceOfClass: type) as! Type
                
                onSuccess(entity)
                        
            } else if let error = error {
                onError(error)
            }
        }
    }
    
    func request <Type: NSObject> (method: Alamofire.Method,
                                   url: URLStringConvertible,
                                   parameterMap: [String : AnyObject],
                                   type: Type.Type,
                                   onError: (NSError) -> Void,
                                   onSuccess: (Type) -> Void) {
                                    
        Alamofire.request(method, url, parameters: parameterMap, encoding: .JSON)
                 .validate()
                 .responseJSON { (request, response, json, error) in
                    
            if let json: AnyObject = json {
                
                let entity = ObjectMapper.sharedInstance()
                                         .objectFromSource(json, toInstanceOfClass: type) as! Type
                
                onSuccess(entity)
                        
            } else if let error = error {
                onError(error)
            }
        }
    }
    
    func request <Type: NSObject> (method: Alamofire.Method,
                                   url: URLStringConvertible,
                                   parameterMap: [String : AnyObject],
                                   encoding: ParameterEncoding,
                                   type: Type.Type,
                                   onError: (NSError) -> Void,
                                   onSuccess: (Type) -> Void) {
                                    
        Alamofire.request(method, url, parameters: parameterMap, encoding: encoding)
                 .validate()
                 .responseJSON { (request, response, json, error) in
                    
            if let json: AnyObject = json {
                
                let entity = ObjectMapper.sharedInstance()
                                         .objectFromSource(json, toInstanceOfClass: type) as! Type
                
                onSuccess(entity)
                        
            } else if let error = error {
                onError(error)
            }
        }
    }
}
