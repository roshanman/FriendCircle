//
//  Image+Extension.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/26.
//

import Foundation

fileprivate let bundle = Bundle(for: FCLikeView.self)
fileprivate let bundleURL = bundle.url(forResource: "FriendCircle", withExtension: "bundle")!
fileprivate let resourceBundle = Bundle(url: bundleURL)!

extension UIImage {
    static let like = UIImage(named: "FCLike", in: resourceBundle, compatibleWith: nil)!
    static let moreOp = UIImage(named: "FCOperateMore", in: resourceBundle, compatibleWith: nil)!
    
    static let likeWhite = UIImage(named: "FCLikeWhite", in: resourceBundle, compatibleWith: nil)!
    static let commentWhite = UIImage(named: "FCCommentWhite", in: resourceBundle, compatibleWith: nil)!
    
    static let videoPlay = UIImage(named: "VideoPlay", in: resourceBundle, compatibleWith: nil)!
}
