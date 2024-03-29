//
//  CardDackView.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/08.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import UIKit
import RealmSwift

class CardDackView : UIView {
    var isNeedDisplayPlayerName:Bool = false
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var imageView1:UIImageView!
    @IBOutlet weak var imageView2:UIImageView!
    @IBOutlet weak var imageView3:UIImageView!
    @IBOutlet weak var imageView4:UIImageView!
    @IBOutlet weak var imageView5:UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
      //  fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CardDackView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setDefaultImage()
        valueLabel.text = nil
        valueLabel.font = UIFont(name: "Pacifico", size: 15)
        dateLabel.font = UIFont(name: "Pacifico", size: 10)
    }
    
    var gameId:String? = nil
    
    var playerId:String = ""
    
    var isDealer:Bool = false
    
    var game:GameModel? {
        if let gameId = gameId {
            if let game = try! Realm().object(ofType: GameModel.self, forPrimaryKey: gameId) {
                return game
            }
        }
        if isDealer {
            return try! Realm().objects(DealerModel.self).first?.games.last
        }
        let player = try! Realm().object(ofType: PlayerModel.self, forPrimaryKey: playerId)
        return player?.games.last
    }
    
    
    private func setDefaultImage() {
        imageView1?.image = #imageLiteral(resourceName: "blue_back")
        imageView2?.image = #imageLiteral(resourceName: "blue_back")
        imageView3?.image = #imageLiteral(resourceName: "blue_back")
        imageView4?.image = #imageLiteral(resourceName: "blue_back")
        imageView5?.image = #imageLiteral(resourceName: "blue_back")
    }
    
    
    func refresh() {
        guard let game = game else {
            setDefaultImage()
            return
        }
        let images = game.cardsImageValues
        imageView1.image = images[0]
        imageView2.image = images[1]
        imageView3.image = images[2]
        imageView4.image = images[3]
        imageView5.image = images[4]
        if isNeedDisplayPlayerName {
            valueLabel.text = " \(game.player?.name ?? Dealer.shared.dealer!.name) : \(game.cardsPoint)"
        } else {
            valueLabel.text = " \(game.gameResultValueString) \(game.cardsPoint)"
        }
        dateLabel.text = DateFormatter.localizedString(from: game.regDT, dateStyle: .full, timeStyle: .short)
        }
            

}
