//
//  FCLikeView.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/25.
//

import UIKit
import Then

protocol FCLikeViewDelegate: NSObjectProtocol {
    func didTapLikeUser(_ user: FCUserInfo)
}

class FCLikeView: UIView {
    var likes: [FCUserInfo]! {
        didSet {
            textView.attributedText = getAttributedText(likes: likes ?? [])
            textView.isScrollEnabled = likes.count > 50
        }
    }
    
    weak var delegate: FCLikeViewDelegate?
    
    let textView = FCBaseTextView(frame: .zero).then {
        $0.backgroundColor = .fc
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 4, left: 2, bottom: 4, right: 2)
        $0.linkTextAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.likeTextColor
        ]
    }
    
    func getAttributedText(likes: [FCUserInfo]) -> NSAttributedString {
        let attributed = NSMutableAttributedString()
        
        let attach = LikeViewImageAttachment().then {
            $0.image = UIImage.like
            $0.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        }
        
        attributed.append(NSAttributedString(attachment: attach))
        attributed.append(NSAttributedString(string: "  "))
        
        let namesAttr = likes.map { user -> NSMutableAttributedString in
            let attr = NSMutableAttributedString(string: user.name)
            
            let range = NSRange(0..<user.name.count)
            
            attr.addAttribute(
                NSAttributedStringKey.font,
                value: UIFont.systemFont(ofSize: 15),
                range: range
            )
            
            attr.addAttribute(
                NSAttributedStringKey.link,
                value: user.id,
                range: range
            )
            
            attr.addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: UIColor.red,
                range: range
            )
            
            return attr
        }
        
        namesAttr.forEach {
            attributed.append($0)
            attributed.append(NSAttributedString(string: "，"))
        }
        
        attributed.replaceCharacters(
            in: NSRange(attributed.length - 1..<attributed.length),
            with: ""
        )
        
        return attributed
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(textView)
        textView.delegate = self
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if likes.count > 50 {
            textView.attributedText = getAttributedText(likes: Array(likes![0..<50]))
        }
        
        let ret = textView.sizeThatFits(size)
        
        return CGSize(width: ret.width, height: ret.height + 10)
    }
    
    override func layoutSubviews() {
        textView.frame = CGRect(x: 0, y: 8, width: bounds.width, height: bounds.height - 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            super.draw(rect)
            return
        }
        
        ctx.beginPath()
        
        let bound = CGRect(x: 0, y: 6, width: bounds.width, height: bounds.height)
        
        ctx.addRect(bound)
        
        ctx.move(to: CGPoint(x: 10, y: 6))
        ctx.addLine(to: CGPoint(x: 15, y: 0))
        ctx.addLine(to: CGPoint(x: 20, y: 6))
        
        UIColor.fc.setFill()
        
        ctx.fillPath()
    }
}

extension FCLikeView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        let userId = URL.absoluteString
        
        if let user = likes.first(where: {$0.id == userId}) {
            delegate?.didTapLikeUser(user)
        }
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {

        return false
    }
}

class LikeViewImageAttachment: NSTextAttachment {
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        
        var bound = super.attachmentBounds(for: textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        
        bound = bound.offsetBy(dx: 0, dy: -2)
        
        return bound
    }
}
