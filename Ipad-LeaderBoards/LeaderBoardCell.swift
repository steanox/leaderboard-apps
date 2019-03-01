//
//  LeaderBoardCell.swift
//  Ipad-LeaderBoards
//
//  Created by octavianus on 21/11/18.
//  Copyright © 2018 octavianus. All rights reserved.
//

import UIKit


class LeaderBoardCell: UITableViewCell{
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var rankingView: UIView!
    @IBOutlet weak var changesView: UIView!
    @IBOutlet weak var pointLabel: UILabel!
    
    var groupTrophy: TrophyGroup?{
        didSet{
            groupNameLabel.text = groupTrophy?.groupName
            
        }
       
    }
    
    
    
}
