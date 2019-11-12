//
//  Dealer.swift
//  SwiftUITest
//
//  Created by Changyul Seo on 2019/11/07.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Dealer {
    static let shared = Dealer()   
    var dealer:DealerModel? {
        return try! Realm().objects(DealerModel.self).first
    }
    
    var isUseJoker:Bool = false {
        willSet {
            if newValue != isUseJoker {
                dack.removeAll()
                insertCard()
            }
        }
    }
    
    init() {
        if dealer == nil {
            let model = DealerModel()
            model.name = "딜러"
            model.introduce = "게임 진행자"
            model.money = 99999999999
            let realm = try! Realm()
            realm.beginWrite()
            realm.add(model)
            try! realm.commitWrite()
        }
    }
    
    enum CardType:String {
        case spade = "S"
        case heart = "H"
        case diamond = "D"
        case club = "C"
        case joker = "J"
    }
    
    struct Card {
        let type:CardType
        let index:Int
        /** 카드가 가지는 값*/
        var value:Int {
            if type == .joker {
                return 10
            }
            switch index {
            case 1,11,12,13:
                return 10
            default:
                return index
            }
        }
        var typeValue:String {
            return type.rawValue
        }
        /** 카드를 문자열로 표현*/
        var stringValue:String {
            var result = type.rawValue
            switch index {
            case 1:
                result += "A"
            case 11:
                result += "J"
            case 12:
                result += "Q"
            case 13:
                result += "K"
            default:
                result += "\(index)"
            }
            return result
        }
        
        var model:CardModel {
            let model = CardModel()
            model.setData(card: self)
            return model
        }
        
        var image:UIImage? {
            switch type {
            case .joker:
                return #imageLiteral(resourceName: "joker")
            case .club:
                switch index {
                case 1: return #imageLiteral(resourceName: "AC")
                case 2: return #imageLiteral(resourceName: "2C")
                case 3: return #imageLiteral(resourceName: "3C")
                case 4: return #imageLiteral(resourceName: "4C")
                case 5: return #imageLiteral(resourceName: "5C")
                case 6: return #imageLiteral(resourceName: "6C")
                case 7: return #imageLiteral(resourceName: "7C")
                case 8: return #imageLiteral(resourceName: "8C")
                case 9: return #imageLiteral(resourceName: "9C")
                case 10: return #imageLiteral(resourceName: "10C")
                case 11: return #imageLiteral(resourceName: "JC")
                case 12: return #imageLiteral(resourceName: "QC")
                case 13: return #imageLiteral(resourceName: "KC")
                default:return nil
                }
            case .heart:
                switch index {
                case 1: return #imageLiteral(resourceName: "AH")
                case 2: return #imageLiteral(resourceName: "2H")
                case 3: return #imageLiteral(resourceName: "3H")
                case 4: return #imageLiteral(resourceName: "4H")
                case 5: return #imageLiteral(resourceName: "5H")
                case 6: return #imageLiteral(resourceName: "6H")
                case 7: return #imageLiteral(resourceName: "7H")
                case 8: return #imageLiteral(resourceName: "8H")
                case 9: return #imageLiteral(resourceName: "9H")
                case 10: return #imageLiteral(resourceName: "10H")
                case 11: return #imageLiteral(resourceName: "JH")
                case 12: return #imageLiteral(resourceName: "QH")
                case 13: return #imageLiteral(resourceName: "KH")
                default: return nil
                }
            case .diamond:
                switch index {
                case 1: return #imageLiteral(resourceName: "AD")
                case 2: return #imageLiteral(resourceName: "2D")
                case 3: return #imageLiteral(resourceName: "3D")
                case 4: return #imageLiteral(resourceName: "4D")
                case 5: return #imageLiteral(resourceName: "5D")
                case 6: return #imageLiteral(resourceName: "6D")
                case 7: return #imageLiteral(resourceName: "7D")
                case 8: return #imageLiteral(resourceName: "8D")
                case 9: return #imageLiteral(resourceName: "9D")
                case 10: return #imageLiteral(resourceName: "10D")
                case 11: return #imageLiteral(resourceName: "JD")
                case 12: return #imageLiteral(resourceName: "QD")
                case 13: return #imageLiteral(resourceName: "KD")
                default: return nil
                }
            case .spade:
                switch index {
                case 1: return #imageLiteral(resourceName: "AS")
                case 2: return #imageLiteral(resourceName: "2S")
                case 3: return #imageLiteral(resourceName: "3S")
                case 4: return #imageLiteral(resourceName: "4S")
                case 5: return #imageLiteral(resourceName: "5S")
                case 6: return #imageLiteral(resourceName: "6S")
                case 7: return #imageLiteral(resourceName: "7S")
                case 8: return #imageLiteral(resourceName: "8S")
                case 9: return #imageLiteral(resourceName: "9S")
                case 10: return #imageLiteral(resourceName: "10S")
                case 11: return #imageLiteral(resourceName: "JS")
                case 12: return #imageLiteral(resourceName: "QS")
                case 13: return #imageLiteral(resourceName: "KS")
                default: return nil
                }
            }
        }
    }
    
    private let jokerCards:[Card] = [
        Card(type: .joker, index: 0),
        Card(type: .joker, index: 0),
        Card(type: .joker, index: 0),
        Card(type: .joker, index: 0),
    ]
    
    private let cards:[Card] = [
        Card(type: .club, index: 1),
        Card(type: .club, index: 2),
        Card(type: .club, index: 3),
        Card(type: .club, index: 4),
        Card(type: .club, index: 5),
        Card(type: .club, index: 6),
        Card(type: .club, index: 7),
        Card(type: .club, index: 8),
        Card(type: .club, index: 9),
        Card(type: .club, index: 10),
        Card(type: .club, index: 11),
        Card(type: .club, index: 12),
        Card(type: .club, index: 13),
        Card(type: .heart, index: 1),
        Card(type: .heart, index: 2),
        Card(type: .heart, index: 3),
        Card(type: .heart, index: 4),
        Card(type: .heart, index: 5),
        Card(type: .heart, index: 6),
        Card(type: .heart, index: 7),
        Card(type: .heart, index: 8),
        Card(type: .heart, index: 9),
        Card(type: .heart, index: 10),
        Card(type: .heart, index: 11),
        Card(type: .heart, index: 12),
        Card(type: .heart, index: 13),
        Card(type: .diamond, index: 1),
        Card(type: .diamond, index: 2),
        Card(type: .diamond, index: 3),
        Card(type: .diamond, index: 4),
        Card(type: .diamond, index: 5),
        Card(type: .diamond, index: 6),
        Card(type: .diamond, index: 7),
        Card(type: .diamond, index: 8),
        Card(type: .diamond, index: 9),
        Card(type: .diamond, index: 10),
        Card(type: .diamond, index: 11),
        Card(type: .diamond, index: 12),
        Card(type: .diamond, index: 13),
        Card(type: .spade, index: 1),
        Card(type: .spade, index: 2),
        Card(type: .spade, index: 3),
        Card(type: .spade, index: 4),
        Card(type: .spade, index: 5),
        Card(type: .spade, index: 6),
        Card(type: .spade, index: 7),
        Card(type: .spade, index: 8),
        Card(type: .spade, index: 9),
        Card(type: .spade, index: 10),
        Card(type: .spade, index: 11),
        Card(type: .spade, index: 12),
        Card(type: .spade, index: 13),
    ]
    
    private var dack:[Card] = []
    
    private func insertCard() {
        var cards = self.cards
        if isUseJoker {
            for joker in jokerCards {
                cards.append(joker)
            }
        }
        while cards.count > 0 {
            cards.shuffle()
            if let card = cards.last {
                dack.append(card)
                cards.removeLast()
            }
        }
    }
    
    /** 카드 뽑는다.*/
    func popCard(cardNumber:Int)->[Card] {
        if dack.count < cardNumber {
            dack.removeAll()
            insertCard()
        }
        
        var result:[Card] = []
        for _ in 0..<cardNumber {
            result.append(dack.first!)
            dack.removeFirst()
        }
        var out = ""
        for c in result {
            out += c.stringValue + " "
        }        
        return result
    }
}
