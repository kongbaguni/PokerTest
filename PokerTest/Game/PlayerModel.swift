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
    
    func betting() {
        var bettingMoney:Int {
            let MIN = 100
            let MAX = 1000
            let count = games.count
            if count < 6 {
                return MIN
            }
            var money = self.games[games.count - 2].bettingMoney

            let games = self.games.sorted(byKeyPath: "regDT", ascending: false)
            var ref = 0
            for i in 0...5 {
                if let status = GameModel.GameWinStatus(rawValue: games[i].gameWinStatusRawValue) {
                    switch status {
                    case .lose:
                        ref += 1
                    case .win:
                        ref -= 1
                    default:
                        break
                    }
                }
            }
            if ref > 0 {
                money += 100
            }
            else {
                money -= 100
            }
            if money < MIN {
                return MIN
            }
            if money > MAX {
                return MAX
            }
            return money
        }
        games.last?.bettingMoney = bettingMoney
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
