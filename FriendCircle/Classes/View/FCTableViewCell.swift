//
//  FCTableViewCell.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/23.
//

import UIKit
import Kingfisher
import Then

open class FCTableViewCell: UITableViewCell {

    static let ReuseIdentifier = "FCTableViewCell_ReuseIdentifier"
    
    let avatarImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
    }
    let nameLabel = UILabel(frame: .zero).then {
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    let contentLabel = UILabel(frame: .zero).then {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    let toolbarView = FCToolbarView(frame: .zero)
    let palyLoadView = FCPalyLoadView(frame: .zero)
    let likeView = FCLikeView(frame: .zero)
    let replyView = FCReplyView(frame: .zero)
    
    public var model: FCModel! {
        didSet {
            _ = URL(string: model.userInfo.avatar).map {
                avatarImageView.kf.setImage(
                    with: $0,
                    placeholder: UIImage.defaultAvatar,
                    options: nil,
                    progressBlock: nil,
                    completionHandler: nil
                )
            }
            
            nameLabel.text          = model.userInfo.name
            contentLabel.text       = model.text
            toolbarView.publishDate = model.publishDate
            
            if let me = fcView?.me, me == model.userInfo {
                toolbarView.showDeleteButton = true
            } else {
                toolbarView.showDeleteButton = false
            }
            
            if let text = model.text, text.isEmpty {
                contentLabel.isHidden = true
            } else {
                contentLabel.isHidden = false
            }
            
            if let palyload = model.palyload {
                palyLoadView.palyload = palyload
                palyLoadView.isHidden = false
            } else {
                palyLoadView.isHidden = true
            }
            
            if model.like.isEmpty {
                likeView.isHidden = true
            } else {
                likeView.likes = model.like
                likeView.isHidden = false
            }
            
            if model.reply.isEmpty {
                replyView.replys = []
                replyView.isHidden = true
                replyView.tableView.reloadData()
            } else {
                replyView.replys = model.reply
                replyView.isHidden = true
                
                DispatchQueue.main.async {
                    self.replyView.isHidden = false
                    self.replyView.tableView.reloadData()
                }
            }
        }
    }
    
    func addLike(user: FCUserInfo) {
        model.like.append(user)
        
        likeView.likes = model.like
        likeView.isHidden = false
        likeView.setNeedsDisplay()
    }
    
    func removeLike(user: FCUserInfo) {
        model.like = model.like.filter{$0 != user}
        likeView.likes = model.like

        if model.like.isEmpty {
            likeView.isHidden = true
        }
    }
    
    func addReply(item: FCReplyItem) {
        model.reply.append(item)
        
        replyView.replys = model.reply
        replyView.isHidden = false

        replyView.tableView.insertRows(
            at: [IndexPath(row: model.reply.count - 1, section: 0)],
            with: .automatic
        )
    }
    
    func removeReply(item: FCReplyItem) {
        guard let index = model.reply.index(of: item) else {
            return
        }
        
        model.reply = model.reply.filter{$0 != item}
        replyView.replys = model.reply
        
        if model.reply.isEmpty {
            replyView.isHidden = true
        }
        
        replyView.tableView.deleteRows(
            at: [IndexPath(row: index, section: 0)],
            with: .none
        )
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        palyLoadView.delegate = self
        likeView.delegate = self
        toolbarView.delegate = self
        replyView.delegate = self
        
        [contentLabel, palyLoadView, likeView, replyView, avatarImageView, nameLabel, toolbarView]
            .forEach { contentView.addSubview($0) }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        _ = model.sizeThatFits(bounds.size)

        avatarImageView.frame = CGRect(x: 12, y: 10, width: 50, height: 50)
        
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(
            x: avatarImageView.frame.maxX + 8,
            y: avatarImageView.frame.minY,
            width: nameLabel.bounds.width,
            height: nameLabel.bounds.height
        )
        
        let retainWidth = bounds.width - 12 - nameLabel.frame.minX
        let fullWidth   = bounds.size.width
        
        if let _ = model.text {
            contentLabel.frame = CGRect(
                x: nameLabel.frame.minX,
                y: nameLabel.frame.maxY + 8,
                width: retainWidth,
                height: model.cachedTextHeight[fullWidth]!
            )
        }
        
        if let _ = model.palyload {
            func getPlayloadPositionY() -> CGFloat {
                if model.text == nil {
                    return nameLabel.frame.maxY + 8
                }
                
                return contentLabel.frame.maxY + 8
            }
            
            palyLoadView.frame = CGRect(
                x: nameLabel.frame.minX,
                y: getPlayloadPositionY(),
                width: retainWidth,
                height: model.cachedPalyloadHeight[fullWidth]!
            )
        }
        
        func getToolbarFrameYPosition() -> CGFloat {
            if let _ = model.palyload {
                return palyLoadView.frame.maxY + 8
            }
            
            return contentLabel.frame.maxY + 8
        }
        
        toolbarView.frame = CGRect(
            x: nameLabel.frame.minX,
            y: getToolbarFrameYPosition(),
            width: retainWidth,
            height: FCToolbarView.standardHeight
        )
        
        if !model.like.isEmpty {
            likeView.frame = CGRect(
                x: nameLabel.frame.minX,
                y: toolbarView.frame.maxY,
                width: retainWidth,
                height: model.cachedLikeHeight[fullWidth]!
            )
        }
        
        func getReplyViewFrameYPosition() -> CGFloat {
            if !model.like.isEmpty {
                return likeView.frame.maxY
            } else {
                return toolbarView.frame.maxY
            }
        }
        
        if !model.reply.isEmpty {
            replyView.frame = CGRect(
                x: nameLabel.frame.minX,
                y: getReplyViewFrameYPosition(),
                width: retainWidth,
                height: model.cachedReplyHeight[fullWidth]!
            )
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
}

