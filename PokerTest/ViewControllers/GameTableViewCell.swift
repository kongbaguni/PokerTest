//
//  GameTableViewCell.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/08.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GameTableViewCell : UITableViewCell {
    @IBOutlet weak var dack:CardDackView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var bettingLabel:UILabel!
    var playerId:String = ""
    
    var player:PlayerModel? {
        return try! Realm().object(ofType: PlayerModel.self, forPrimaryKey: playerId)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.text = player?.name
        let m = player?.games.last?.bettingMoneyStringValue ?? "0"
        bettingLabel.text = """
        betting: \(m)
        money: \(player?.moneyString ?? "0")
        """
        dack.playerId = playerId
        if dack.fliped {
            dack.flip()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.dack.flip()
            let realm = try! Realm()
            if
                let dealar = realm.objects(DealerModel.self).first,
                let player = realm.object(ofType: PlayerModel.self, forPrimaryKey: self.playerId),
                let bettingMoney = self.dack.game?.bettingMoney
            {
            
                try! Realm().write {
                    
                    if self.isWin {
                        player.money += bettingMoney
                        dealar.money -= bettingMoney
                        
                    } else {
                        player.money -= bettingMoney
                        dealar.money += bettingMoney
                    }
                }
            }
        }
    }
    
    var isWin:Bool {
        if let dr = Dealer.shared.dealer?.games.last?.gameResultValue,
            let mr = dack.game?.gameResultValue  {
            if dr.rawValue < mr.rawValue {
                return true
            }
        }
        return false
    }
}
