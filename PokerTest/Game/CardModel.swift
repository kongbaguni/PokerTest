//
//  CardModel.swift
//  SwiftUITest
//
//  Created by Changyul Seo on 2019/11/07.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import Foundation
import RealmSwift

class CardModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var type:String = ""
    @objc dynamic var index:Int = 0
    @objc dynamic var value:Int = 0
    
    func setData(card:Dealer.Card) {
        type = card.type.rawValue
        index = card.index
        value = card.value
    }
    
    var cardValue:Dealer.Card? {
        if let type = Dealer.CardType(rawValue: type) {
            return Dealer.Card(type: type, index: index)
        }
        return nil
    }
}
