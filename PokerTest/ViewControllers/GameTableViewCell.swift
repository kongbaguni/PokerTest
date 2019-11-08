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
        bettingLabel.text = m
        dack.playerId = playerId
        if dack.fliped {
            dack.flip()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.dack.flip()
        }
    }
    
}
