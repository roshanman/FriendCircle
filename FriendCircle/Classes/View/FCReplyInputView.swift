//
//  FCReplyInputView.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/28.
//

import UIKit
import Then
import KMPlaceholderTextView

protocol FCReplyInputViewDelegate: NSObjectProtocol {
    func replySendButtonTap(replyText: String, to item: FCReplyItem?, at index: Int)
}

public class FCReplyInputView: UIView {
    let defaultHeight: CGFloat = 45
    
    var item: FCReplyItem? {
        didSet {
            if item == nil {
                sendButton.setTitle("评论", for: .normal)
                textView.placeholder = "评论"
            } else {
                sendButton.setTitle("回复", for: .normal)
                textView.placeholder = "回复\(item!.from.name)"
            }
        }
    }
    var index = 0
    
    weak var delegate: FCReplyInputViewDelegate?
    
    let textView = KMPlaceholderTextView(frame: .zero).then {
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 0.2
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    let sendButton = UIButton(frame: .zero).then {
        $0.setTitle("回复", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        addSubview(sendButton)
        
        textView.delegate = self
        
        sendButton.addTarget(
            self,
            action: #selector(sendButtonTap),
            for: .touchUpInside
        )
    }
    
    @objc func sendButtonTap() {
        guard let text = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return
        }
        
        delegate?.replySendButtonTap(replyText: text, to: item, at: index)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        textView.frame = CGRect(
            x: 12, y: 6,
            width: bounds.width - 12 - 4 - 50 - 4,
            height: bounds.height - 12
        )
        
        sendButton.frame = CGRect(
            x: textView.frame.maxX + 4,
            y: bounds.height - defaultHeight,
            width: 50,
            height: defaultHeight
        )
    }
}

extension FCReplyInputView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let textViewHeight = min(100, max(textView.sizeThatFits(
            CGSize(width: bounds.width - 70 , height: 200)
        ).height, 33))

        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.frame = CGRect(
                    x: 0,
                    y: self.frame.minY - (textViewHeight - self.textView.bounds.height),
                    width: self.bounds.width,
                    height: textViewHeight + 12
                )
            },
            completion: nil
        )
    }
}
