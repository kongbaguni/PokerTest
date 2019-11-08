//
//  GameModel.swift
//  SwiftUITest
//
//  Created by Changyul Seo on 2019/11/07.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import Foundation
import RealmSwift

class GameModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var playerId = ""
    @objc dynamic var regDT = Date()
    @objc dynamic var bettingMoney = 0
    private var cards = List<CardModel>()
    
    func insertCartd(cards: [Dealer.Card]) {
        for c in cards {
            let model = c.model
            self.cards.append(model)
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["playerId"]
    }
    
    var cardsStringValue:String {
        var result = ""
        for card in cards {
            if result.isEmpty == false {
                result += ","
            }
            result += card.cardValue?.stringValue ?? ""
        }
        return result
    }
    
    var cardsImageValues:[UIImage] {
        var result:[UIImage] = []
        for card in cards {
            if let img = card.cardValue?.image {
                result.append(img)
            }
        }
        return result
    }

    /** 카드 족보*/
    enum CardValue:String {
        case highcard = "Highcard"
        case onePair = "One Pair"
        case twoPairs = "Two pair"
        case threeOfaKind = "Three of a kind"
        case straight = "Straight"
        case flush = "Flush"
        case fullHouse = "Full house"
        case fourOfaKind = "Four of a kind"
        case straightFlush = "Straight flush"
        case fiveOfaKind = "Five of a kind"
    }
    
    /** 족보판정*/
    var gameResultValue:CardValue {
        var tcards:[Dealer.Card] = []
        for card in cards {
            if let c = card.cardValue {
                tcards.append(c)
            }
        }
        if tcards.count == 5 {
            let a = tcards.sorted { (a, b) -> Bool in
                return a.index > b.index
            }
            
            var check:[Int] = []
            var types = Set<String>()
            for c in a {
                check.append(c.index)
                types.insert(c.type.rawValue)
            }
            
            if types.count == 5 {
                return .fiveOfaKind
            }
            
            var isStraight = false
            if (check[0] - check[1] == 1)
                && (check[1] - check[2] == 1)
                && (check[2] - check[3] == 1)
                && (check[3] - check[4] == 1) {
                isStraight = true
            }
            let isFlush = types.count == 1
            
            if isStraight && isFlush {
                return .straightFlush
            }
            
        }
        return .highcard
    }
    
    
    var bettingMoneyStringValue : String {
         return NumberFormatter.localizedString(from: NSNumber(integerLiteral: bettingMoney), number: .currency)
    }
}

