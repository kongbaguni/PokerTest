//
//  PlayerListTableViewController.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/08.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerListTableViewController: UITableViewController {
    var players:Results<PlayerModel> {
        return try! Realm().objects(PlayerModel.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .onGamePlayFinishNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = players[indexPath.row]
        let money =  NumberFormatter.localizedString(from: NSNumber(value: player.money), number: .currency)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text =
        """
        소지금 : \(money) 원
        \(player.introduce)
        """
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players[indexPath.row]
        let vc = UIAlertController(
            title: nil,
            message: player.name ,
            preferredStyle: .actionSheet)
        vc.addAction(UIAlertAction(title: "삭제", style: .default) { _ in
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(player)
            try! realm.commitWrite()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        vc.addAction(UIAlertAction(title: "+ 100만원", style: .default) { _ in
            let realm = try! Realm()
            realm.beginWrite()
            player.money += 1000000
            try! realm.commitWrite()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        vc.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}
