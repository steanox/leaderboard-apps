//
//  TrophyGroup.swift
//  Ipad-LeaderBoards
//
//  Created by octavianus on 21/11/18.
//  Copyright © 2018 octavianus. All rights reserved.
//

import Foundation


class TrophyGroup{
    var id: String!
    var createdTime:String!
    var groupName: String!
    var point: Int!
    var previousPoint: Int!
    
    var dict: [String: Any]!{
        didSet{
            if
            let id = dict!["id"] as? String,
            let date = dict!["createdTime"] as? String
            {
                
                self.id = id
                self.createdTime = date
            }else{
                self.id = "0"
                self.createdTime = "-"
            }
            
            if let data = dict!["fields"] as? [String: Any]{
                if
                    let groupName = data["group"] as? String,
                    let point = data["point"] as? Int
                {
                    self.groupName = groupName
                    self.point = point
                }else{
                    self.groupName = "-"
                    self.point = 0
                }
            }
            

        }
    }
    
}


