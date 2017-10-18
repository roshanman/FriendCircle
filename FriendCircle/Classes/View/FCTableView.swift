//
//  FCTableView.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/23.
//

import UIKit

open class FCTableView: UITableView {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard let v = super.hitTest(point, with: event) else {
            return nil
        }
        
        switch v.tag {
        case FCToolbarView.commentButtonTag,
             FCToolbarView.likeButtonTag:
            break
        case FCToolbarView.moreButtonTag:
            if (v.superview as! FCToolbarView).showingOpbar {
                break
            }
            
            fallthrough
        default:
            visibleCells
                .map{$0 as? FCTableViewCell}
                .forEach{$0?.toolbarView.removeOpbar()}
        }
        
        return v
    }
}
