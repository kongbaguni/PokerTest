//
//  NewPlayerViewController.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/08.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import UIKit
import RealmSwift

class NewPlayerViewController: UITableViewController {
    @IBOutlet weak var nameTF:UITextField!
    @IBOutlet weak var introTF:UITextField!
    @IBOutlet weak var moneyTF:UITextField!
    
    @IBAction func onTouchupMakePlayer(_ sender:UIButton) {
        for tf in [nameTF, introTF, moneyTF] {
            if tf?.text == nil || tf?.text?.isEmpty == true {
                tf?.becomeFirstResponder()
                return
            }
        }
        
        self.view.endEditing(true)
        
        let player = PlayerModel()
        player.name = nameTF.text!
        player.introduce = introTF.text!
        player.money = NSString(string:moneyTF.text!).integerValue
        
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(player)
        try! realm.commitWrite()
        
        for tf in [nameTF, introTF, moneyTF] {
            tf?.text = nil
        }
        tabBarController?.selectedIndex = 1
    }
    
}
