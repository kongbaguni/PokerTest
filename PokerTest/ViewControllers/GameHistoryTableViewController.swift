//
//  GameHistoryTableViewController.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/11.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import UIKit
import RealmSwift
class GameHistoryTableViewController: UITableViewController {
    var gameResult:GameModel.CardValue? = nil {
        didSet {
            setTitle()
        }
    }
    
    var playerId:String = "" {
        didSet {
            setTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .onGamePlayFinishNotification, object: nil, queue: nil) { [weak self] (_) in
            guard let tableView = self?.tableView else {
                return
            }
            tableView.reloadData()
            tableView.scrollToBottom(animated: true)
        }
    }
    
    func setTitle() {
        if let result = gameResult {
            title = GameModel.getCardValueString(card: result)
            return
        }
        title = player?.name
    }
            
    private var player:PlayerModel? {
        return try! Realm().object(ofType: PlayerModel.self, forPrimaryKey: playerId)
    }
    
    var data:Results<GameModel>? {
        let list = try! Realm().objects(GameModel.self)
        if let result = gameResult {
            return list.filter("gameResultRawValue = %@",result.rawValue)
        }
        return player?.games.filter("id != %@","")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var isScrollToBottom:Bool = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isScrollToBottom == false {
            tableView.scrollToBottom(animated: false)
            isScrollToBottom = true
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameHistoryTableViewCell
        let id = data?[indexPath.row].id
        cell.gameId = id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
