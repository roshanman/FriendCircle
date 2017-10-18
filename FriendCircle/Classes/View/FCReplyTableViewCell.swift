//
//  FCReplyTableViewCell.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/25.
//

import UIKit

protocol FCReplyTableViewCellDelegate: NSObjectProtocol {
    func replyViewCell(_ cell: FCReplyTableViewCell, didTap user: FCUserInfo)
    func replyViewCell(_ cell: FCReplyTableViewCell, didLongTapAt item: FCReplyItem)
}

class FCReplyTableViewCell: UITableViewCell {
    static let ReuseIdentifier = "FCReplyTableViewCell_ReuseIdentifier"
    
    public weak var delegate: FCReplyTableViewCellDelegate?
    
    var item: FCReplyItem! {
        didSet {
            textView.attributedText = item.attributedText
        }
    }
    
    let textView = FCBaseTextView(frame: .zero).then {
        $0.backgroundColor = .fc
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        $0.linkTextAttributes = [
            NSForegroundColorAttributeName: UIColor.likeTextColor
        ]
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: FCReplyTableViewCell.ReuseIdentifier)
        
        contentView.addSubview(textView)
        textView.delegate = self
        backgroundColor = .fc
        contentView.backgroundColor = .fc
        
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(showOpMenu(sender:))
        )
        
        addGestureRecognizer(longPress)
    }
    
    @objc func showOpMenu(sender: UIGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        
        delegate?.replyViewCell(self, didLongTapAt: item)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FCReplyTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        if URL.absoluteString == item.from.id {
            delegate?.replyViewCell(self, didTap: item.from)
        } else if let to = item.to {
            delegate?.replyViewCell(self, didTap: to)
        }
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        
        return false
    }
}
