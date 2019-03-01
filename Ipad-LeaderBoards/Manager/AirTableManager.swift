//
//  AirTableManager.swift
//  Ipad-LeaderBoards
//
//  Created by octavianus on 21/11/18.
//  Copyright © 2018 octavianus. All rights reserved.
//

import Foundation


public enum AirTableAPI{
    case list(body:Parameters?,headers: HTTPHeaders?,base:String,table:String)
    case retrieve(body:Parameters?,headers: HTTPHeaders?,object:String,base:String,table:String)
    case create(body:Parameters?,headers: HTTPHeaders?,base:String,table:String)
    case update(body:Parameters?,headers: HTTPHeaders?,object:String,base:String,table:String)
    case delete(body:Parameters?,headers: HTTPHeaders?,object:String,base:String,table:String)
}

extension AirTableAPI:EndPointType{
    var baseURL: URL{
        
        guard let url = URL(string: "https://api.airtable.com/v0") else { fatalError("Base url could not be defined")}
        return url
    }
    
    var path: String{
        switch self{
        case .list(_,_,let base,let table),
             .create(_,_,let base,let table):
            return "\(base)/\(table)"
        case .retrieve(_,_,let object,let base,let table),
             .delete(_,_,let object,let base,let table),
             .update(_,_,let object,let base,let table):
            return "\(base)/\(table)/\(object)"
        }
        
    }
    
    var httpMethod: HTTPMethod{
        switch self{
        case .list:
            return .get
        case .retrieve:
            return .get
        case .create:
            return .post
        case .update:
            return .patch
        case .delete:
            return .delete
            
        }
    }
    
    var task: HTTPTask{
        switch self{
        case .list(let body,_,_,_),
             .retrieve(let body,_,_,_,_),
             .create(let body,_,_,_),
             .update(let body,_,_,_,_),
             .delete(let body,_,_,_,_):
            
            return .requestParametersAndHeaders(bodyParameters: body, urlParameters: nil, headers: self.headers)
        }
        
    }
    
    var headers: HTTPHeaders?{
        switch self{
        case .list(_,let headers,_,_),
             .retrieve(_,let headers,_,_,_),
             .create(_,let headers,_,_),
             .update(_,let headers,_,_,_),
             .delete(_,let headers,_,_,_):
            return headers
        }
    }
}
