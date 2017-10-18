//
//  FCPlayLoadView.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/25.
//

import UIKit
import Kingfisher

protocol FCPalyloadViewDelegate: NSObjectProtocol {
    func didTapImage(index: Int)
    func didTapVideo()
}

class FCPalyLoadView: UIView {
    fileprivate let imageContentView = FCImagePalyloadView(frame: .zero)
    fileprivate let videoContentView = FCVideoPalyloadView(frame: .zero)
    
    weak var delegate: FCPalyloadViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageContentView)
        addSubview(videoContentView)
    }
    
    func placeImageViews() -> [UIImageView] {
        guard let pl = palyload else {
            return []
        }
        
        if case .image = pl {
            return imageContentView.imageViews.map{$0.imageView!}
        }
        
        if case .video = pl {
            return [videoContentView.button.imageView!]
        }
        
        return []
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var palyload: FCPalyloadContent! {
        didSet {
            guard let pl = palyload else { return }
            
            switch pl {
            case .image(let urls):
                videoContentView.isHidden = true
                imageContentView.isHidden = false
                imageContentView.urls = urls
            case .video(let url, let place):
                videoContentView.isHidden = false
                imageContentView.isHidden = true
                videoContentView.url = url
                videoContentView.placeHolder = place
            }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let pl = palyload else { return .zero }
        
        switch pl {
        case .image(_):
            return imageContentView.sizeThatFits(size)
        case .video(_, _):
            return videoContentView.sizeThatFits(size)
        }
    }

    override func layoutSubviews() {
        videoContentView.frame = bounds
        imageContentView.frame = bounds
    }
    
    deinit {
        debugPrint(type(of: self), #function)
    }
}

fileprivate class FCImagePalyloadView: UIView {
    
    lazy var imageViews: [UIButton] = {
        let imageViews = [0,1,2,3,4,5].map{_ in FCImageButton(frame: .zero)}
        
        imageViews.forEach{
            self.addSubview($0)
            
            $0.addTarget(
                self,
                action: #selector(imageTapEvent(_:)),
                for: .touchUpInside
            )
        }

        return imageViews
    }()
    
    let moreLabel = UILabel().then {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.3)
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 40)
        $0.textAlignment = .center
    }
    
    var urls = [String]() {
        didSet {
            
            defer {
                setNeedsLayout()
            }
            
            if urls.count > 6 {
                imageViews.forEach{$0.isHidden = false}
                moreLabel.isHidden = false
                moreLabel.text = "+\(urls.count - 6)"
            } else {
                Array(imageViews[0..<urls.count]).forEach{$0.isHidden = false}
                
                if urls.count < 6 {
                    Array(imageViews[urls.count...5]).forEach{$0.isHidden = true}
                }
                
                moreLabel.isHidden = true
            }
            
            func setImage() {
                zip(urls, imageViews).forEach {
                    let button = $0.1
                    
                    if let url = URL(string: $0.0) {
                        $0.1.imageView?.kf.setImage(
                            with: url,
                            placeholder: nil,
                            options: nil,
                            progressBlock: nil,
                            completionHandler: { (image, _, _, _) in
                                if let image = image {
                                    DispatchQueue.main.async {
                                        button.setImage(image, for: .normal)
                                        button.imageView?.contentMode = .scaleAspectFill
                                    }
                                }
                            }
                        )
                    }
                }
            }
            
            DispatchQueue.main.async { setImage() }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageViews.forEach{addSubview($0)}
        addSubview(moreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imageTapEvent(_ sender: UIButton) {
        guard let index = imageViews.index(of: sender) else {
            return
        }
        
        (superview as? FCPalyLoadView)?.delegate?.didTapImage(index: index)
    }
    
    override func layoutSubviews() {
        let width = (bounds.width - 8) / 3
        let height = CGFloat(120)
        
        if urls.count == 4 {
            for (i, iv) in imageViews[0...3].enumerated() {
                let x: CGFloat = CGFloat(i % 2) * (width + 4)
                let y: CGFloat = CGFloat(i / 2) * (height + 4)
                
                iv.frame = CGRect(x: x, y: y, width: width, height: height)
            }
            
            return
        }
        
        for (i, iv) in imageViews.enumerated() {
            let x: CGFloat = CGFloat(i % 3) * (width + 4)
            let y: CGFloat = CGFloat(i / 3) * (height + 4)
            
            iv.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        moreLabel.frame = imageViews.last!.frame
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height = CGFloat(120)
        
        var colum = CGFloat(min(6, urls.count) / 3 + (min(6, urls.count) % 3 == 0 ? 0 : 1))

        if imageViews.count == 4 {
            colum = 2
        }

        return CGSize(
            width: size.width,
            height: colum * height + (colum - 1) * 4
        )
    }
    
    deinit {
        debugPrint(type(of: self), #function)
    }
}

fileprivate class FCVideoPalyloadView: UIView {
    var url = ""
    var placeHolder = "" {
        didSet {
            func setImage() {
                guard let url = URL(string: placeHolder) else {
                    return
                }
                
                button.imageView?.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: nil,
                    progressBlock: nil,
                    completionHandler: { (image, _, _, _) in
                        if let image = image {
                            DispatchQueue.main.async {
                                self.button.setImage(image, for: .normal)
                                self.button.imageView?.contentMode = .scaleAspectFill
                            }
                        }
                    }
                )
            }
            
            DispatchQueue.main.async { setImage() }
        }
    }
    
    let button = FCVideoPalyLoadButton(frame: .zero).then {
        $0.setImage(UIImage(), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        button.addTarget(
            self,
            action: #selector(buttonTapEvent),
            for: .touchUpInside
        )
    }
    
    @objc func buttonTapEvent() {
        (superview as? FCPalyLoadView)?.delegate?.didTapVideo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height = CGFloat(150)
        
        return CGSize(
            width: size.width,
            height: height
        )
    }
    
    override func layoutSubviews() {
        button.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width / 3,
            height: bounds.height
        )
    }
    
    deinit {
        debugPrint(type(of: self), #function)
    }
}

fileprivate class FCHTMLPalyloadView: UIView {
    let url: String
    
    init(pageURL: String) {
        url = pageURL
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(type(of: self), #function)
    }
}

fileprivate class FCImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = bounds
    }
}

fileprivate class FCVideoPalyLoadButton: UIButton {
    let playButton = UIButton(frame: .zero).then {
        $0.setImage(UIImage.videoPlay, for: .normal)
        $0.backgroundColor = UIColor(white: 0, alpha: 0.2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playButton)
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        playButton.addTarget(target, action: action, for: controlEvents)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = bounds
        playButton.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
