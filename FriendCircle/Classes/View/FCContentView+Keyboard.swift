//
//  FCContentView+Keyboard.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/30.
//

import Foundation
import UIKit


extension FCView {
    func bindKeyboardNotification() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(_:)),
            name: NSNotification.Name.UIKeyboardDidShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide(_:)),
            name: NSNotification.Name.UIKeyboardDidHide,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
    }
    
    @objc func keyboardWillChangeFrame(_ noti: NSNotification) {
        guard keyboard.textView.isFirstResponder else {
            return
        }
        
        guard let userinfo = noti.userInfo else {
            return
        }
        
        guard let nsValue = userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let _ = (userinfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue
        let duration = (userinfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3

        var keyboardRec = nsValue.cgRectValue
        keyboardRec = self.convert(keyboardRec, from: nil)
        
        func offsetReplyView() {
            guard let v = currentReplyView else {
                return
            }
            
            let keybarodPositionY = UIScreen.main.bounds.height - keyboardRec.size.height
            let window = UIApplication.shared.delegate!.window!
            
            let absFrame = v.convert(v.bounds, to: window!)
            
            let offset = absFrame.maxY - keybarodPositionY
            
            if tableView.contentOffset.y + offset <= 0 {
                return
            }
            
            let newContentOffset = CGPoint(
                x: tableView.contentOffset.x,
                y: tableView.contentOffset.y + offset
            )
            
            tableView.contentOffset = newContentOffset
            
            debugPrint(offset, absFrame)
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [ ],
            animations: ({
                self.keyboard.frame = CGRect(
                    x: 0,
                    y: self.bounds.height - keyboardRec.height - self.keyboard.bounds.height,
                    width: self.keyboard.bounds.width,
                    height: self.keyboard.bounds.height
                )
                
                offsetReplyView()
            }),
            completion: nil
        )
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification) {
        
    }
    
    @objc func keyboardDidShow(_ noti: NSNotification) {
        
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
        
        let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3
        
        UIView.animate(
            withDuration: duration,
            animations: ({
                self.keyboard.frame = CGRect(
                    x: 0,
                    y: self.bounds.height,
                    width: self.bounds.width,
                    height: self.keyboard.defaultHeight
                )
            }),
            completion: nil
        )
        
        debugPrint(#function)
    }
    
    @objc func keyboardDidHide(_ noti: NSNotification) {
        tableViewOldContentOffset = nil
        currentReplyView = nil
        
        debugPrint(#function)
    }
    
    open func showReplyKeyboard(with item: FCReplyItem?, at index: Int) {
        
        func getCurrentReplyView() -> UIView? {
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FCTableViewCell else {
                return nil
            }
            
            if let item = item {
                return cell.replyView.tableView.visibleCells.map{$0 as! FCReplyTableViewCell}.filter{$0.item == item}.first
            }
            
            if !cell.palyLoadView.isHidden {
                return cell.palyLoadView
            }
            
            return cell.contentLabel
        }
        
        currentReplyView = getCurrentReplyView()
        keyboard.textView.text = ""
        keyboard.item = item
        keyboard.index = index
        tableViewOldContentOffset = tableView.contentOffset
        keyboard.frame = CGRect(
            x: 0,
            y: bounds.height - keyboard.defaultHeight,
            width: bounds.width,
            height: keyboard.defaultHeight
        )
        keyboard.textView.becomeFirstResponder()
    }
    
    public func hideReplyKeyboard() {
        keyboard.textView.resignFirstResponder()
    }
}
