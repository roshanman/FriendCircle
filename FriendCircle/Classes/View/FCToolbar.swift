//
//  FCToolbar.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/25.
//

import UIKit
import Then

protocol FCToolbarViewDelegate: NSObjectProtocol {
    func didTapCommentButton(_ toolbar: FCToolbarView)
    func didTapLikeButton(_ toolbar: FCToolbarView)
    func didTapDeleteButton(_ toolbar: FCToolbarView)
    func didTapMoreButton(_ toolbar: FCToolbarView)
}

extension FCToolbarView {
    var fcTableViewCell: FCTableViewCell! {
        var r = next
        
        while r != nil {
            if r is FCTableViewCell { return r as? FCTableViewCell }
            r = r?.next
        }
        
        return nil
    }
    
    var fcView: FCView! {
        var r = next
        
        while r != nil {
            if r is FCView { return r as? FCView }
            r = r?.next
        }
        
        return nil
    }
}

class FCToolbarView: UIView {
    static let moreButtonTag    = 9801
    static let likeButtonTag    = 9802
    static let commentButtonTag = 9803
    
    static let standardHeight = CGFloat(30)
    
    weak var delegate: FCToolbarViewDelegate?
    
    var showDeleteButton = true {
        didSet {
            deleteButton.isHidden = !showDeleteButton
        }
    }
    
    var publishDate = Date() {
        didSet {
            dateLabel.text = publishDate.formatedPublish
        }
    }
    
    let dateLabel = UILabel(frame: .zero).then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .darkGray
    }
    
    let deleteButton = UIButton(frame: .zero).then {
        $0.setTitle("删除", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    let moreButton = UIButton(frame: .zero).then {
        $0.setImage(.moreOp, for: .normal)
        $0.tag = FCToolbarView.moreButtonTag
    }
    
    var showingOpbar: Bool {
        return subviews.contains{$0 is FCOperationToolbar}
    }
    
    var operationBar: FCOperationToolbar? {
        return subviews.filter{$0 is FCOperationToolbar}.map{$0 as! FCOperationToolbar}.first
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        addSubview(moreButton)
        addSubview(deleteButton)
        
        moreButton.addTarget(
            self,
            action: #selector(moreButtonTap),
            for: .touchUpInside
        )
        
        deleteButton.addTarget(
            self,
            action: #selector(deleteButtonTap),
            for: .touchUpInside
        )
    }
    
    @objc func deleteButtonTap() {
        delegate?.didTapDeleteButton(self)
    }
    
    @objc func moreButtonTap() {
        guard let _ = operationBar else {
            delegate?.didTapMoreButton(self)
            
            return
        }

        hideOpbarAnimated()
    }
    
    func hideOpbarAnimated() {
        guard let tool = operationBar else {
            return
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                tool.frame = CGRect(
                    x: self.moreButton.frame.minX,
                    y: 0,
                    width: 0,
                    height: self.bounds.height
                )
            },
            completion: { _ in
                tool.removeFromSuperview()
            }
        )
    }
    
    func showOpBar() {
        guard let me = fcView?.me, let model = fcTableViewCell.model else {
            return
        }
        
        let likeText = model.like.contains(me) ? "取消" : "赞"
        
        let toolbar = FCOperationToolbar(frame:
            CGRect(
                x: moreButton.frame.minX - 1,
                y: 0,
                width: 1,
                height: bounds.height
            )
        )
        
        toolbar.likeButton.setTitle(likeText, for: .normal)
        
        addSubview(toolbar)
        
        UIView.animate(withDuration: 0.3) {
            toolbar.frame = CGRect(
                x: self.moreButton.frame.minX - 140,
                y: 0,
                width: 140,
                height: self.bounds.height
            )
        }
    }

    func removeOpbar() {
        operationBar?.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(
            x: 0,
            y: (bounds.height - dateLabel.bounds.height) / 2,
            width: dateLabel.bounds.width + 2,
            height: dateLabel.bounds.height
        )
        
        deleteButton.sizeToFit()
        deleteButton.frame = CGRect(
            x: dateLabel.frame.maxX + 4,
            y: 0,
            width: deleteButton.bounds.width + 10,
            height: bounds.height
        )
        
        moreButton.frame = CGRect(
            x: bounds.width - bounds.height,
            y: 0,
            width: bounds.height,
            height: bounds.height
        )
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: FCToolbarView.standardHeight)
    }
    
    deinit {
        debugPrint(type(of: self), #function)
    }
}

class FCOperationToolbar: UIView {
    let likeButton = UIButton(frame: .zero).then {
        $0.setTitle("赞", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.setImage(UIImage.likeWhite, for: .normal)
        $0.tag = FCToolbarView.likeButtonTag
    }
    
    let commentButton = UIButton(frame: .zero).then {
        $0.setTitle("评论", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.setImage(UIImage.commentWhite, for: .normal)
        $0.tag = FCToolbarView.commentButtonTag
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 4
        backgroundColor = .moreBackgroundColor
        
        addSubview(likeButton)
        addSubview(commentButton)
        
        commentButton.addTarget(
            self,
            action: #selector(commentButtonTap),
            for: .touchUpInside
        )
        
        likeButton.addTarget(
            self,
            action: #selector(likeButtonTap),
            for: .touchUpInside
        )
    }
    
    @objc func commentButtonTap() {
        guard let tb = superview as? FCToolbarView else {
            return
        }
        
        tb.delegate?.didTapCommentButton(tb)
        tb.hideOpbarAnimated()
    }
    
    @objc func likeButtonTap() {
        guard let tb = superview as? FCToolbarView else {
            return
        }
        
        tb.delegate?.didTapLikeButton(tb)
        tb.hideOpbarAnimated()
    }
    
    override func layoutSubviews() {
        likeButton.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width / 2 - 2,
            height: bounds.height
        )
        
        commentButton.frame = CGRect(
            x: likeButton.frame.maxX,
            y: 0,
            width: bounds.width / 2,
            height: bounds.height
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
