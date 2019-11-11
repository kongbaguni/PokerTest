//
//  GameTableViewController.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/08.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GameTableViewController: UITableViewController {
    @IBOutlet weak var dealerBettingLabel:UILabel!
    @IBOutlet weak var dealerDack:CardDackView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDealerData()
    }
    
    func loadDealerData() {
        dealerBettingLabel.text = Dealer.shared.dealer?.moneyString ?? "0"
                
        dealerDack.isDealer = true
    }
    
    var players:Results<PlayerModel> {
        return try! Realm().objects(PlayerModel.self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath) as! GameTableViewCell
        cell.playerId = players[indexPath.row].id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBAction func onTouchupNewGame(_ sender: UIButton) {
        guard let d = Dealer.shared.dealer else {
            return
        }
        let realm = try! Realm()
        realm.beginWrite()
        d.initGame()
        d.play()
        
        for player in players {
            player.initGame()
            player.betting(money: 100)
            player.play()
        }
        try! realm.commitWrite()
        
        loadDealerData()
        tableView.reloadData()
        if dealerDack.fliped {
            dealerDack.flip()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.dealerDack.flip()
        }
    }
    
}
