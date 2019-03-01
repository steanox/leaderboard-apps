//
//  NetworkManager.swift
//  Ipad-LeaderBoards
//
//  Created by octavianus on 21/11/18.
//  Copyright © 2018 octavianus. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String:Any]
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()


//Enum
public enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum HTTPTask{
    case request
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, headers: HTTPHeaders?)
}

public enum NetworkError: String, Error{
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Encoding was failed"
    case missingURL = "URL is missing"
}


//Protocols
protocol EndPointType{
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public protocol ParameterEncoder{
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}


//Encoder Class
public struct URLParameterEncoder: ParameterEncoder{
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) , !parameters.isEmpty{
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters{
                
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
                
            }
            
            urlRequest.url =  urlComponents.url
            
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

public struct JSONParameterEncoder: ParameterEncoder{
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
            urlRequest.httpBody = jsonData
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil{
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }catch{
            throw NetworkError.encodingFailed
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Router Class
class Router<EndPoint: EndPointType>: NetworkRouter{
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion){
        let session = URLSession.shared
        
        do{
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { (data, res, err) in
                if err != nil {
                    print(err.debugDescription)
                }
                completion(data,res,err)
            })
        }catch{
            completion(nil,nil,error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest{
        
        var request =  URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                  cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                  timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do{
            switch route.task{
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            case.requestParametersAndHeaders(let bodyParameters, let urlParameters, let headers):
                self.addAdditionalHeaders(headers, request: &request)
                try  self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
            
            return request
        }catch{
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws{
        do{
            if let bodyParameters = bodyParameters{
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
                
            }
            
            if let urlParameters = urlParameters{
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        }catch{
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest){
        guard let headers = additionalHeaders else { return }
        
        for (key,value) in headers{
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
