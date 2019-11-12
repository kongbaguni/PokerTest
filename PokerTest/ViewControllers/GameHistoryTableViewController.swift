//
//  GameHistoryTableViewController.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/11.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import UIKit
import RealmSwift
class GameHistoryTableViewController: UITableViewController {
    var playerId:String = ""
    
    private var player:PlayerModel? {
        return try! Realm().object(ofType: PlayerModel.self, forPrimaryKey: playerId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player?.games.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameHistoryTableViewCell
        let id = player?.games[indexPath.row].id
        cell.gameId = id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
