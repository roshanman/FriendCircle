//
//  FCBaseTextView.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/26.
//

import UIKit

class FCBaseTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 只有在点击link的时候才响应事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let glyphIndex = layoutManager.glyphIndex(
            for: point,
            in: textContainer,
            fractionOfDistanceThroughGlyph: nil
        )
        
        let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        
        if characterIndex >= textStorage.length {
            return nil
        }
        
        if let _ = textStorage.attribute(.link, at: characterIndex, effectiveRange: nil) {
            return self
        }
        
        return nil
    }
}
