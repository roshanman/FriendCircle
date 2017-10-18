//
//  FCModel.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/23.
//

import UIKit

public struct FCUserInfo: Equatable {
    
    public let name: String
    public let avatar: String
    public let id: String
    
    public init(name: String, avatar: String, id: String) {
        self.name = name
        self.avatar = avatar
        self.id = id
    }
    
    public static func ==(lhs: FCUserInfo, rhs: FCUserInfo) -> Bool {
        return lhs.id == rhs.id
    }
}

public enum FCPalyloadContent {
    case image([String])
    case video(String, String)
    
    public var imagesURL: [String]! {
        if case .image(let urls) = self {
            return urls
        }
        
        return nil
    }
    
    public var videoURL: String! {
        if case .video(let url, _) = self {
            return url
        }
        
        return nil
    }
    
    public var videoPlaceHolder: String! {
        if case .video(_, let ph) = self {
            return ph
        }
        
        return nil
    }
}

/// 当to没有赋值的时候表示评论该朋友圈否则表示回复评论
public class FCReplyItem: Equatable {
    public let from: FCUserInfo
    public let to: FCUserInfo?
    public let text: String
    public let id: String
    
    lazy var attributedText: NSAttributedString = {
        let attributed = NSMutableAttributedString()
        
        if let to = self.to {
            func attr1() -> NSAttributedString {
                let attr = NSMutableAttributedString(string: self.from.name)
                
                let range = NSRange(0..<self.from.name.characters.count)
                
                attr.addAttribute(
                    NSLinkAttributeName,
                    value: self.from.id,
                    range: range
                )
                
                attr.addAttribute(
                    NSFontAttributeName,
                    value: UIFont.systemFont(ofSize: 14),
                    range: range
                )
                
                return attr
            }
            
            func attr2() -> NSAttributedString {
                let attr = NSMutableAttributedString(string: "回复")
                let range = NSRange(0..<2)
                attr.addAttribute(
                    NSFontAttributeName,
                    value: UIFont.systemFont(ofSize: 14),
                    range: range
                )
                
                return attr
            }
            
            func attr3() -> NSAttributedString {
                let attr = NSMutableAttributedString(string: to.name)
                
                let range = NSRange(0..<to.name.characters.count)
                
                attr.addAttribute(
                    NSLinkAttributeName,
                    value: to.id,
                    range: range
                )
                
                attr.addAttribute(
                    NSFontAttributeName,
                    value: UIFont.systemFont(ofSize: 14),
                    range: range
                )
                
                return attr
            }
            
            attributed.append(attr1())
            attributed.append(attr2())
            attributed.append(attr3())
        } else {
            let attr = NSMutableAttributedString(string: self.from.name)
            
            let range = NSRange(0..<self.from.name.characters.count)
            
            attr.addAttribute(
                NSLinkAttributeName,
                value: self.from.id,
                range: range
            )
            
            attr.addAttribute(
                NSFontAttributeName,
                value: UIFont.systemFont(ofSize: 14),
                range: range
            )
            
            attributed.append(attr)
        }
        
        let attr = NSMutableAttributedString(string: ": \(self.text)")
        let range = NSRange(0..<": \(self.text)".characters.count)
        attr.addAttribute(
            NSFontAttributeName,
            value: UIFont.systemFont(ofSize: 14),
            range: range
        )
        
        attributed.append(attr)
        
        return attributed
    }()
    
    // Width:Height
    private var cache = [CGFloat: CGFloat]()
    
    public init(from: FCUserInfo, to: FCUserInfo?, text: String, id: String) {
        self.from = from
        self.to = to
        self.text = text
        self.id = id
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        guard size.width > 0 else {
            return .zero
        }
        
        if let height = cache[size.width] {
            return CGSize(width: size.width, height: height)
        }
        
        func caclHeight() -> CGFloat {
            let textView = UITextView(frame: .zero).then {
                $0.backgroundColor = .fc
                $0.isEditable = false
                $0.textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                $0.linkTextAttributes = [
                    NSForegroundColorAttributeName: UIColor.likeTextColor
                ]
            }
            
            textView.attributedText = attributedText
            
            return textView.sizeThatFits(CGSize(width: size.width, height: 100000)).height
        }
        
        let height = caclHeight()
        
        cache.updateValue(height, forKey: size.width)
        
        return CGSize(width: size.width, height: height)
    }
    
    public static func ==(lhs: FCReplyItem, rhs: FCReplyItem) -> Bool {
        return lhs.id == rhs.id
    }
}

open class FCModel: Equatable {
    open let id: String
    open let userInfo: FCUserInfo
    open let publishDate: Date
    open let text: String?
    open let palyload: FCPalyloadContent?
    open var like: [FCUserInfo] { didSet {
            cachedLikeHeight.removeAll()
        }
    }
    open var reply: [FCReplyItem] { didSet {
            cachedReplyHeight.removeAll()
        }
    }
    
    var cachedTextHeight      = [CGFloat: CGFloat]()
    var cachedLikeHeight      = [CGFloat: CGFloat]()
    var cachedPalyloadHeight  = [CGFloat: CGFloat]()
    var cachedReplyHeight     = [CGFloat: CGFloat]()
    
    public init?(id: String,
         user: FCUserInfo,
         date: Date,
         text: String?,
         palyload: FCPalyloadContent? = nil,
         like: [FCUserInfo] = [],
         reply: [FCReplyItem] = []) {
        
        if text == nil && palyload == nil {
            return nil
        }
        
        self.id = id
        self.userInfo = user
        self.publishDate = date
        self.like = like
        self.text = text
        self.palyload = palyload
        self.reply = reply
    }
    
    open func addLikeUser(_ user: FCUserInfo) {
        if !like.contains(user) {
            like.append(user)
        }
    }
    
    open func removeLikeUser(_ user: FCUserInfo) {
        like = like.filter{$0 != user}
    }
    
    open func addReplyItem(_ item: FCReplyItem) {
        if !reply.contains(item) {
            reply.append(item)
        }
    }
    
    open func removeReplyItem(_ item: FCReplyItem) {
        reply = reply.filter{$0 != item}
    }
    
    open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard size.width > 0 else {
            return .zero
        }

        var height = CGFloat(30)
        
        if let _ = text {
            height += (getTextHeight(width: size.width) + 8)
        }
        
        if let _ = palyload {
            height += (getPalyloadHeight(width: size.width) + 8)
        }
        
        height += (FCToolbarView.standardHeight + 8)
        
        if !like.isEmpty {
            height += getLikeHeight(width: size.width)
        }
        
        if !reply.isEmpty {
            height += getReplyHeight(width: size.width)
        }
        
        // Margin bottom
        height += 10

        return CGSize(width: size.width, height: height)
    }

    private func getTextHeight(width: CGFloat) -> CGFloat {
        if let height = cachedTextHeight[width] {
            return height
        }
        
        let textLabel = UILabel(frame: .zero).then {
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.text = text
        }
        
        let size = textLabel.sizeThatFits(
            CGSize(width: width - 82, height: 100000)
        )
        
        cachedTextHeight[width] = size.height
        
        return size.height
    }
    
    private func getLikeHeight(width: CGFloat) -> CGFloat {
        if let height = cachedLikeHeight[width] {
            return height
        }
        
        let likeView = FCLikeView(frame: .zero).then {
            $0.likes = like
        }
        
        let size = likeView.sizeThatFits(
            CGSize(width: width - 82, height: 100000)
        )
        
        cachedLikeHeight[width] = size.height
        
        return size.height
    }
    
    private func getReplyHeight(width: CGFloat) -> CGFloat {
        if let height = cachedReplyHeight[width] {
            return height
        }
        
        let replyView = FCReplyView(frame: .zero).then {
            $0.replys = reply
        }
        
        let size = replyView.sizeThatFits(
            CGSize(width: width - 82, height: 100000)
        )
        
        cachedReplyHeight[width] = size.height
        
        return size.height
    }
    
    private func getPalyloadHeight(width: CGFloat) -> CGFloat {
        if let height = cachedPalyloadHeight[width] {
            return height
        }
        
        let palyLoadView = FCPalyLoadView(frame: .zero).then {
            $0.palyload = palyload
        }
        
        let size = palyLoadView.sizeThatFits(
            CGSize(width: width - 82, height: 100000)
        )
        
        cachedPalyloadHeight[width] = size.height
        
        return size.height
    }
    
    public static func ==(lhs: FCModel, rhs: FCModel) -> Bool {
        return lhs.id == rhs.id
    }
}
