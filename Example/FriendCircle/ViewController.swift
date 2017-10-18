//
//  ViewController.swift
//  FriendCircle
//
//  Created by morenotepad@163.com on 09/23/2017.
//  Copyright (c) 2017 morenotepad@163.com. All rights reserved.
//

import UIKit
import FriendCircle
import ImageViewer
import Kingfisher

// extension UIImageView: DisplaceableView { }

let user1 = FCUserInfo(
    name: "张休明",
    avatar: "https://avatars0.githubusercontent.com/u/10202577?v=4&s=460",
    id: "1234"
)

let user2 = FCUserInfo(
    name: "张休明2",
    avatar: "https://avatars0.githubusercontent.com/u/10202577?v=4&s=460",
    id: "12345"
)

let user3 = FCUserInfo(
    name: "张休明3",
    avatar: "https://avatars0.githubusercontent.com/u/10202577?v=4&s=460",
    id: "123456"
)

let model0 = FCModel(
    id: "1",
    user: user1,
    date: Date().addingTimeInterval(-24*3600*60),
    text: "这是一个测试数据0",
    palyload: .image(repeatElement("http://p1.pstatp.com/list/640x360/3c75000033f5ad3b9475", count: 6).map{$0}),
    like: [user1, user2, user3],
    reply: [
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "1"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回测试回复", id: "2"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "3"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回复复测试回复", id: "4"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "5"),
        FCReplyItem(from: user2, to: nil, text: "测试回复回复", id: "6")
    ]
)!

let model1 = FCModel(
    id: "2",
    user: user2,
    date: Date().addingTimeInterval(-24*3600*900),
    text: repeatElement("这是一个测试数据1", count: 4).joined(),
    palyload: .image(repeatElement("http://mat1.gtimg.com/fashion/.000ly/a/sunlisunli330.jpg", count: 3).map{$0}),
    like: [],
    reply: []
)!

let model2 = FCModel(
    id: "3",
    user: user1,
    date: Date().addingTimeInterval(-24*3600*10),
    text: repeatElement("这是一个测试数据2", count: 4).joined(),
    palyload: .video("http://v1-tt.ixigua.com/591f661b4b433a7ce02fbc6e9d67313d/59cdd7e0/video/m/2208d56de136f72443c9e728154a950ca20114eb6800009ea076040708/", "https://avatars0.githubusercontent.com/u/10202577?v=4&s=460"),
    like: [user1, user2, user3],
    reply: [
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "1"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回测试回复", id: "2"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "3"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回复复测试回复", id: "4"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "5"),
        FCReplyItem(from: user2, to: nil, text: "测试回复回复", id: "6")
    ]
)!

let model3 = FCModel(
    id: "4",
    user: user2,
    date: Date(),
    text: repeatElement("这是一个测试数据3", count: 4).joined(),
    palyload: .image(repeatElement("http://mat1.gtimg.com/fashion/images/index/2017/08/25/mrix2.jpg", count: 4).map{$0}),
    like: [user1, user2, user3],
    reply: [
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "1"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回测试回复", id: "2"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "3"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回复复测试回复", id: "4"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "5"),
        FCReplyItem(from: user2, to: nil, text: "测试回复回复", id: "6")
    ]
)!

let model4 = FCModel(
    id: "5",
    user: user1,
    date: Date(),
    text: "这是一个测试数据4",
    palyload: .image(repeatElement("http://p1.pstatp.com/list/640x360/3c75000033f5ad3b9475", count: 3).map{$0}),
    like: [user1, user2, user3],
    reply: [
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "1"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回测试回复", id: "2"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "3"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回复复测试回复", id: "4"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "5"),
        FCReplyItem(from: user2, to: nil, text: "测试回复回复", id: "6")
    ]
)!

let model5 = FCModel(
    id: "6",
    user: user2,
    date: Date(),
    text: repeatElement("这是一个测试数据5", count: 4).joined(),
    palyload: .video("http://v1-tt.ixigua.com/591f661b4b433a7ce02fbc6e9d67313d/59cdd7e0/video/m/2208d56de136f72443c9e728154a950ca20114eb6800009ea076040708/", "https://avatars0.githubusercontent.com/u/10202577?v=4&s=460"),
    like: [user1, user2, user3],
    reply: [
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "1"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回测试回复", id: "2"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "3"),
        FCReplyItem(from: user2, to: user3, text: "测试回复测试回复复测试回复", id: "4"),
        FCReplyItem(from: user1, to: user2, text: "测试回复2", id: "5"),
        FCReplyItem(from: user2, to: nil, text: "测试回复回复", id: "6")
    ]
)!

struct LongTapParam {
    let fcView: FCView
    let index: Int
    let item: FCReplyItem
    let tapView: UIView
}

class ViewController: UIViewController {
    let fcView = FCView(frame: .zero, user: user1)
    
    var previewCurrentIndex = 0
    
    var longTapParam: LongTapParam?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(fcView)
        
        fcView.fcDelegate = self
        fcView.items = [model0, model1, model2, model3, model4, model5]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fcView.frame = view.bounds
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard let param = longTapParam else {
            return false
        }
        
        if action.description.contains("copy") {
            return true
        }
        
        if action.description.contains("delete") {
            if param.item.from != user1 {
                return false
            }
            
            return true
        }
        
        return false
    }
    
    override func copy(_ sender: Any?) {
        guard let param = longTapParam else {
            return
        }
        
        UIPasteboard.general.string = param.item.text
    }
    
    override func delete(_ sender: Any?) {
        guard let param = longTapParam else {
            return
        }

        fcView.removeReply(item: param.item, at: param.index)
    }
}

extension ViewController: FCViewDelegate {
    func fcView(_ fcView: FCView, didLongTap item: FCReplyItem, at index: Int, in view: UIView) {
        
        if !becomeFirstResponder() {
            debugPrint("不能成为第一响应者")
            return
        }
        
        longTapParam = LongTapParam(
            fcView: fcView,
            index: index,
            item: item,
            tapView: view
        )
        
        let menu = UIMenuController.shared
        menu.setTargetRect(view.bounds, in: view)
        
        menu.update()
        menu.setMenuVisible(true, animated: true)
    }
    
    func fcView(_ fcView: FCView, didReply text: String, to item: FCReplyItem?, at index: Int) {
        
        let replyItem = FCReplyItem(
            from: user1,
            to: item?.from,
            text: text,
            id: "xxxxxxxxx"
        )
        
        fcView.addReply(item: replyItem, at: index)
        fcView.hideReplyKeyboard()
    }

    func fcView(_ fcView: FCView, didTapImage imageIndex: Int, at index: Int) {
        debugPrint(#function)
        
        previewCurrentIndex = index
        showGalleryImageViewer(index: imageIndex)
    }
    
    func fcView(_ fcView: FCView, didTapVideoAt index: Int) {
        debugPrint(#function)
        
        previewCurrentIndex = index
        
        showGalleryImageViewer(index: 0)
    }
    
    func fcView(_ fcView: FCView, didTapReply item: FCReplyItem, at index: Int) {
        debugPrint(#function)
        
        if item.from == user1 {
            let alert = UIAlertController(title: nil, message: "确定删除该评论吗?", preferredStyle: .alert)
            let a0 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let a1 = UIAlertAction(title: "确定", style: .destructive) { _ in
                fcView.removeReply(item: item, at: index)
            }
            
            alert.addAction(a0)
            alert.addAction(a1)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        fcView.showReplyKeyboard(with: item, at: index)
    }
    
    func fcView(_ fcView: FCView, didTapCommentButtonAt index: Int) {
        debugPrint(#function)
        
        fcView.showReplyKeyboard(with: nil, at: index)
    }
    
    func fcView(_ fcView: FCView, didTapLikeButtonAt index: Int) {
        debugPrint(#function)
        
        let model = fcView.items[index]
        
        if model.like.contains(user1) {
            fcView.removeLike(user: user1, at: index)
        } else {
            fcView.addLike(user: user1, at: index)
        }
    }
    
    func fcView(_ fcView: FCView, didTapUser: FCUserInfo, at index: Int) {
        debugPrint(#function)
    }
    
    func fcView(_ fcView: FCView, didTapDeleteButtonAt index: Int) {
        debugPrint(#function)
        
        let alert = UIAlertController(title: nil, message: "确定删除该朋友圈吗?", preferredStyle: .alert)
        let a0 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let a1 = UIAlertAction(title: "确定", style: .destructive) { _ in
            fcView.removeItem(at: index)
        }
        
        alert.addAction(a0)
        alert.addAction(a1)
        
        present(alert, animated: true, completion: nil)
    }
}


// Demo
extension ViewController {
    
    func showGalleryImageViewer(index: Int) {
        
        let galleryViewController = GalleryViewController(startIndex: index, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())
        
        galleryViewController.launchedCompletion = { print("LAUNCHED") }
        galleryViewController.closedCompletion = { print("CLOSED") }
        galleryViewController.swipedToDismissCompletion = { print("SWIPE-DISMISSED") }
        
        self.presentImageGallery(galleryViewController)
    }
    
    func galleryConfiguration() -> GalleryConfiguration {
        
        return [
            
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            
            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),
            
            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            
            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffectStyle.light),
            
            GalleryConfigurationItem.videoControlsColor(.white),
            
            GalleryConfigurationItem.maximumZoomScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),
            
            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),
            
            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),
            
            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),
            
            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),
            
            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),
            
            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50)
        ]
    }
}

extension UIImageView: DisplaceableView {
    
}

extension ViewController: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        let ivs = fcView.displayPlayloadImageViews(index: previewCurrentIndex)
        
        if index < ivs.count {
            return ivs[index]
        }
        
        return nil
    }
}

extension ViewController: GalleryItemsDataSource {
    
    func itemCount() -> Int {
        return fcView.items[previewCurrentIndex].palyload?.imagesURL?.count ?? 1
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        if let videoURL = fcView.items[previewCurrentIndex].palyload?.videoURL {
            return GalleryItem.video(
                fetchPreviewImageBlock: {
                    $0(UIImage())
                },
                videoURL: URL(string: videoURL)!
            )
        }
        
        let imageURL = fcView.items[previewCurrentIndex].palyload!.imagesURL[index]
        
        return GalleryItem.image {
            let image = ImageCache.default.retrieveImageInDiskCache(forKey: imageURL)
            
            $0(image ?? UIImage())
        }
    }
}

extension ViewController: GalleryItemsDelegate {
    
    func removeGalleryItem(at index: Int) {
        
        print("remove item at \(index)")
    }
}
