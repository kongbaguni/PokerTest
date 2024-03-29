//
//  GameTableViewController.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/08.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
extension Notification.Name {
    /** 한게임 끝나는 시점 알려주는 notification*/
    static var onGamePlayFinishNotification = Notification.Name("onGamePlayFinish_observer")
}

class GameTableViewController: UITableViewController {
    @IBOutlet weak var dealerBettingLabel:UILabel!
    @IBOutlet weak var dealerDack:CardDackView!
    @IBOutlet weak var autoPlaySwitch: UISwitch!
    @IBOutlet weak var jokerSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDealerData()
        dealerDack.refresh()
        title = "Porker"
    }
    
    func loadDealerData() {
        dealerBettingLabel.text = Dealer.shared.dealer?.moneyString ?? "0"
                
        dealerDack.isDealer = true
    }
    
    var players:Results<PlayerModel> {
        return try! Realm().objects(PlayerModel.self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath) as! GameTableViewCell
        cell.playerId = players[indexPath.row].id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    @IBAction func onTouchupNewGame(_ sender: UIButton) {
        play()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showGameHistory", sender: players[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameHistoryTableViewController {
            vc.playerId = sender as? String ?? ""
        }
    }
    
    @IBAction func onChangeSwitch(_ sender: UISwitch) {
        switch sender {
        case autoPlaySwitch:
            if sender.isOn {
                play()
            }
        case jokerSwitch:
            Dealer.shared.isUseJoker = sender.isOn
        default:
            break
        }
    }
    
    @IBAction func onTouchupResetBtn(_ sender: UIButton) {
        autoPlaySwitch.isOn = false
        let vc = UIAlertController(title: "delete", message: "delete all game", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(realm.objects(GameModel.self))
            try! realm.commitWrite()
            self.reloadData()
        }))
        vc.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    func play() {
        let isAuto = self.autoPlaySwitch.isOn

        DispatchQueue.global().async { [weak self] in
            guard let d = Dealer.shared.dealer else {
                return
            }
            guard let s = self else {
                return
            }
            
            let realm = try! Realm()
            realm.beginWrite()
            d.initGame()
            d.play()
            let dgame = d.games.last!

            for player in s.players {
                player.initGame()
                
                player.betting()
                player.play()
                
                let bettingMoney = player.games.last?.bettingMoney ?? 0
                let gameResult = player.games.last!.compareGameResult(game: dgame)
                switch gameResult {
                case .win:
                    player.money += bettingMoney
                    d.money -= bettingMoney
                case .draw:
                    break
                case .lose:
                    player.money -= bettingMoney
                    d.money += bettingMoney
                }
                player.games.last?.gameWinStatusRawValue = gameResult.rawValue
            }
            
            try! realm.commitWrite()
            DispatchQueue.main.async {
                s.reloadData()
                NotificationCenter.default.post(name: .onGamePlayFinishNotification, object: nil)
            }
            if isAuto {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
                    s.play()
                }
            }

        }
    }
    
    private func reloadData() {
        loadDealerData()
        tableView.reloadData()
        dealerDack.refresh()
    }
}

