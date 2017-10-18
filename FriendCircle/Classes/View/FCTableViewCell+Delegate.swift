//
//  FCTableViewCell+Delegate.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/27.
//

import Foundation

extension FCTableViewCell {
    var tableView: FCTableView? {
        if #available(iOS 11.0, *) {
            return next as? FCTableView
        }
        
        return next?.next as? FCTableView
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
    
    var fcView: FCView? {
        return tableView?.superview as? FCView
    }
}

extension FCTableViewCell: FCLikeViewDelegate {
    func didTapLikeUser(_ user: FCUserInfo) {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(
            fcView,
            didTapUser: user,
            at: indexPath.row
        )
    }
}

extension FCTableViewCell: FCToolbarViewDelegate {
    func didTapMoreButton(_ toolbar: FCToolbarView) {
        toolbar.showOpBar()
    }
    
    func didTapLikeButton(_ toolbar: FCToolbarView) {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(
            fcView,
            didTapLikeButtonAt: indexPath.row
        )
    }
    
    func didTapCommentButton(_ toolbar: FCToolbarView) {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(
            fcView,
            didTapCommentButtonAt: indexPath.row
        )
    }
    
    func didTapDeleteButton(_ toolbar: FCToolbarView) {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(
            fcView,
            didTapDeleteButtonAt: indexPath.row
        )
    }
}

extension FCTableViewCell: FCReplyViewDelegate {
    func didLongTapReplyItem(_ item: FCReplyItem, at view: UIView) {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(
            fcView,
            didLongTap: item,
            at: indexPath.row,
            in: view
        )
    }
    
    func didTapReplyUser(_ user: FCUserInfo) {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(
            fcView,
            didTapUser: user,
            at: indexPath.row
        )
    }
    
    func didTapReplyItem(_ item: FCReplyItem) {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(
            fcView,
            didTapReply: item,
            at: indexPath.row
        )
    }
}


extension FCTableViewCell: FCPalyloadViewDelegate {
    func didTapImage(index: Int) {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(
            fcView,
            didTapImage: index,
            at: indexPath.row
        )
    }
    
    func didTapVideo() {
        guard let fcView = fcView, let indexPath = indexPath else {
            return
        }
        
        fcView.fcDelegate?.fcView(fcView, didTapVideoAt: indexPath.row)
    }
}
