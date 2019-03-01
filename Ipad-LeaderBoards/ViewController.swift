//
//  ViewController.swift
//  Ipad-LeaderBoards
//
//  Created by octavianus on 21/11/18.
//  Copyright © 2018 octavianus. All rights reserved.
//

import UIKit
import Dispatch

class ViewController: UIViewController {

    var trophieGroups: [TrophyGroup] = []
    var ranking: [String: Int] = [:]
    lazy var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
    
    @IBOutlet weak var leaderBoardTable: UITableView!
    let groupAPI = AirTableHelper(apiKey: "keyW9iw7rCrEtnyWK", base: "appbaT5pnYxoUdQDm", table: "main")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchGroup()
        self.leaderBoardTable.dataSource = self

       
        
    }

    
    private func fetchGroup(){
        //  let groupAPI = AirTableHelper<Attendance>(apiKey: "keyW9iw7rCrEtnyWK", base: "appItCIQzbQYgSjEs", table: "Table 1")
        groupAPI.listGroup(param: ["sort" : ["fields":"point","direction":"desc"] ], table: nil) { [weak self](trophieGroups, err) in
            
            if err != nil{
                self?.handleError()
                return
            }
            
            
            if (self?.trophieGroups.isEmpty)! {
                self?.trophieGroups = trophieGroups
                self?.trophieGroups.sort { $0.point > $1.point }
                
                var rank = trophieGroups.count - 1
                
                self?.trophieGroups.map({ (group) in
                    self?.ranking[group.groupName!] = rank
                    rank -= 1
                })
                
                DispatchQueue.main.async {
                    self?.leaderBoardTable.reloadData()
                    self?.timer.fire()
                }
            }else{
                let sectionNumber = 0
                
                var sortedGroup = trophieGroups
                sortedGroup.sort{ $0.point > $1.point }
                
                
                self?.trophieGroups = sortedGroup
                
                print("============================================")
                for (index,nextGroup) in sortedGroup.enumerated(){
                    print("next group: \(nextGroup.id)")
                    print("current group: \(trophieGroups[index].id)")
                    print("------------------------------------------------")
                }
                
            }
            
        }
        
    }
    
    @objc private func fetchData(){
        
        self.fetchGroup()
//        groupAPI.listPoint(param: nil, table: "feedback") { (points, err) in
//            print(points)
//        }
    }
    
    func handleError(){
        
    }

}

extension ViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trophieGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderBoardCell", for: indexPath) as! LeaderBoardCell
        cell.groupTrophy = self.trophieGroups[indexPath.row]
        return cell
    }
    
}

enum Direction: CaseIterable{
    case north
    case west
    case east
    case south
}

import CloudKit

let ck = CKRecord(recordType: "asd")
ck.value(forKey: "<#T##String#>")
