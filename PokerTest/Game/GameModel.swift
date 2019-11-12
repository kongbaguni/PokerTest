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
    @objc dynamic var gameResultRawValue:Int = -1    
    private var cards = List<CardModel>()
    
    func insertCartd(cards: [Dealer.Card]) {
        gameResultRawValue = -1
        for c in cards {
            let model = c.model
            self.cards.append(model)
        }
        gameResultRawValue = gameResultValue.rawValue
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
    enum CardValue:Int {
        case highcard = 0
        case onePair = 1
        case twoPairs = 2
        case threeOfaKind = 3
        case straight = 4
        case flush = 5
        case fullHouse = 6
        case fourOfaKind = 7
        case straightFlush = 8
        case fiveOfaKind = 9
    }
    
    /** 족보판정*/
    var gameResultValue:CardValue {
        if let result = CardValue(rawValue: gameResultRawValue) {
            return result
        }
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
            var checks:[Int:Int] = [:]
            for i in 0...13 {
                checks[i] = 0
            }
                        
            var types = Set<String>()
            var indexes = Set<Int>()
            
            for c in a {
                check.append(c.index)
                checks[c.index]! += 1
                types.insert(c.type.rawValue)
                indexes.insert(c.index)
            }
            
            /** 4장이 같다 */
            var is4one = 0
            /** 3장이 같다 */
            var is3one = 0
            /** 2장이 같다**/
            var is2one = 0
            for item in checks {
                if item.value == 4 {
                    is4one += 1
                }
                if item.value == 3 {
                    is3one += 1
                }
                if item.value == 2 {
                    is2one += 1
                }
            }
            
            if types.count == 5 && is4one == 1 {
                return .fiveOfaKind
            }
            
            var isStraight = false
            if (check[0] - check[1] == 1)
                && (check[1] - check[2] == 1)
                && (check[2] - check[3] == 1)
                && (check[3] - check[4] == 1) {
                isStraight = true
            }
            
            let isFlush = types.count == 1 || types.count == 2 && checks[0] == 1
            
            if isStraight && isFlush {
                return .straightFlush
            }

            
            if is4one == 1 {
                return .fourOfaKind
            }
            if is3one == 1 && is2one == 1 {
                return .fullHouse
            }
            if isFlush {
                return .flush
            }
            if isStraight {
                return .straight
            }
            if is3one == 1{
                return .threeOfaKind
            }
            if is2one == 2 {
                return .twoPairs
            }
            if is2one == 1 {
                return .onePair
            }
            
        }
        return .highcard
    }
    
    var gameResultValueString:String {
        return GameModel.getCardValueString(card: gameResultValue)
    }
    
    var cardsPoint:Int {
        var result:Int = 0
        for card in cards {
            result += card.cardValue?.value ?? 0
        }
        return result
    }
    
    var bettingMoneyStringValue : String {
         return NumberFormatter.localizedString(from: NSNumber(integerLiteral: bettingMoney), number: .currency)
    }
    
    static func getCardValueString(card:CardValue)->String {
        switch card {
        case .onePair:
            return "one pair"
        case .twoPairs:
            return "two pairs"
        case .threeOfaKind:
            return "three of a kind"
        case .straight:
            return "straight"
        case .flush:
            return "flush"
        case .fullHouse:
            return "fullHouse"
        case .fourOfaKind:
            return "four of a kind"
        case .straightFlush:
            return "straigh flush"
        case .fiveOfaKind:
            return "five of a kind"
        default:
            return "highcard"
        }
    }
}

