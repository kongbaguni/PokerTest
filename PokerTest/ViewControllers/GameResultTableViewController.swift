//
//  GameResultTableViewController.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/11.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GameResultTableViewController: UITableViewController {
    var values:[GameModel.CardValue] {
        return [
            .highcard,
            .onePair,
            .twoPairs,
            .threeOfaKind,
            .straight,
            .flush,
            .fullHouse,
            .fourOfaKind,
            .straightFlush,
            .fiveOfaKind
        ]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return values.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realm = try! Realm()
        let games = realm.objects(GameModel.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            let value = values[indexPath.row]
            cell.textLabel?.text = GameModel.getCardValueString(card: value)
            let count = games.filter("gameResultRawValue = %@",value.rawValue).count
            cell.detailTextLabel?.text = "\(count)"
            
        } else {
            cell.textLabel?.text = "total"
            cell.detailTextLabel?.text = "\(games.count)"
        }
                
        return cell
    }
}
