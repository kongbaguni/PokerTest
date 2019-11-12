//
//  UITableView+utill.swift
//  PokerTest
//
//  Created by Changyul Seo on 2019/11/12.
//  Copyright © 2019 Changyul Seo. All rights reserved.
//

import UIKit
extension UITableView {
    func scrollToBottom(animated:Bool){
        if self.numberOfSections > 0 {
            let lastSection = self.numberOfSections - 1
            if self.numberOfRows(inSection: lastSection) > 0 {
                let lastRowInLastSection = self.numberOfRows(inSection: lastSection) - 1
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: lastRowInLastSection, section: lastSection)
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
}
