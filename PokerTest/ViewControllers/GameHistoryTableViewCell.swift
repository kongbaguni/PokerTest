//
//  GameHistoryTableViewCell.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/11.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import UIKit

class GameHistoryTableViewCell : UITableViewCell {
    var gameId:String? = nil
    
    @IBOutlet weak var dack:CardDackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dack?.gameId = gameId
        dack?.refresh()
    }
}
