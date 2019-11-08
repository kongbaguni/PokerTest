//
//  PlayerModel.swift
//  SwiftUITest
//
//  Created by Changyul Seo on 2019/11/06.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import Foundation
import RealmSwift

class PlayerModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var introduce = ""
    @objc dynamic var level = 0
    @objc dynamic var money = 0
    let games = List<GameModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
        
    func initGame() {
        let game = GameModel()
        game.playerId = id
        games.append(game)
    }
    
    func betting(money:Int) {
        guard let game = games.last else {
            return
        }
        game.bettingMoney = money
    }
    
    func play() {
        guard let game = games.last else {
            return
        }
        
        let cards = Dealer.shared.popCard(cardNumber: 5)
        game.insertCartd(cards: cards)
    }
    
    func gameClear() {
        games.removeAll()
        level = 0
    }
    
    var lastGameBettingMoney:Int {
        return games.last?.bettingMoney ?? 0
    }
    
    var moneyString:String {
        return NumberFormatter.localizedString(from: NSNumber(integerLiteral: money), number: .currency)
    }
}


class DealerModel : PlayerModel {
    
}
