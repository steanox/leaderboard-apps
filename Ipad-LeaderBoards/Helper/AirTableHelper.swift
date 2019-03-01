//
//  AirTableHelper.swift
//  Ipad-LeaderBoards
//
//  Created by octavianus on 21/11/18.
//  Copyright © 2018 octavianus. All rights reserved.
//

import Foundation


class AirTableHelper{
    
    private let headers: HTTPHeaders?
    private let base: String
    private let table: String
    private let router =  Router<AirTableAPI>()
    
    
    init(apiKey: String,base: String,table: String) {
        self.headers = ["Authorization" : "Bearer \(apiKey)"]
        self.base = base
        self.table = table
    }
    
    public func listGroup(param: Parameters? = nil,table: String? = nil,completion: (([TrophyGroup],Error?)->Void)?){
        router.request(
            .list(body: param,
                  headers: self.headers,
                  base: self.base,
                  table: (table == nil) ? self.table : table!))
        {  (data, res, err) in
            
            do{
                

                 guard let schemas = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else{ return }
                
                let records = schemas["records"] as! [[String: Any]]
                var results: [TrophyGroup] = []
                
                for record in records{
                    var t = TrophyGroup()
                    t.dict = record
                    results.append(t)
                }
                
                completion!(results,nil)
                
                
            }catch{
                print(error)
            }
        }
        
    }
    
    public func listPoint(param: Parameters? = nil,table: String? = nil,completion: ((String,Error?)->Void)?){
        router.request(
            .list(body: param,
                  headers: self.headers,
                  base: self.base,
                  table: (table == nil) ? self.table : table!))
        {  (data, res, err) in
            
            do{
                
                
                guard let schemas = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else{ return }
                print(schemas)
                
            }catch{
                print(error)
            }
        }
        
    }
    
}



