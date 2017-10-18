//
//  FCContentView.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/23.
//

import UIKit

public protocol FCViewDelegate: NSObjectProtocol {
    func fcView(_ fcView: FCView, didTapReply item: FCReplyItem, at index: Int)
    func fcView(_ fcView: FCView, didTapCommentButtonAt index: Int)
    func fcView(_ fcView: FCView, didTapLikeButtonAt index: Int)
    func fcView(_ fcView: FCView, didTapUser: FCUserInfo, at index: Int)
    func fcView(_ fcView: FCView, didTapDeleteButtonAt index: Int)
    func fcView(_ fcView: FCView, didTapImage imageIndex: Int, at index: Int)
    func fcView(_ fcView: FCView, didTapVideoAt index: Int)
    func fcView(_ fcView: FCView, didReply text: String, to item: FCReplyItem?, at index: Int)
    func fcView(_ fcView: FCView, didLongTap item: FCReplyItem, at index: Int, `in` view: UIView)
}

open class FCView: UIView {
    public var items = [FCModel]()
    public var fcDelegate: FCViewDelegate?
    
    public func displayPlayloadImageViews(index: Int) -> [UIImageView] {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FCTableViewCell
        
        return cell?.palyLoadView.placeImageViews() ?? []
    }
    
    let me: FCUserInfo
    
    public init(frame: CGRect, user: FCUserInfo) {
        me = user
        
        super.init(frame: frame)
        
        addSubview(tableView)
        addSubview(keyboard)
        
        tableView.register(
            FCTableViewCell.self,
            forCellReuseIdentifier: FCTableViewCell.ReuseIdentifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        keyboard.delegate = self
        bindKeyboardNotification()
    }
    
    public let tableView = FCTableView(frame: .zero)
    
    open func addLike(user: FCUserInfo, at index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FCTableViewCell
        
        cell?.addLike(user: user)

        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    open func removeLike(user: FCUserInfo, at index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FCTableViewCell
        
        cell?.removeLike(user: user)

        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    open func addReply(item: FCReplyItem, at index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FCTableViewCell
        
        cell?.addReply(item: item)

        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    open func removeReply(item: FCReplyItem, at index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FCTableViewCell
        
        cell?.removeReply(item: item)

        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    open func removeItem(at index: Int) {
        guard index < items.count else {
            return
        }
        
        items.remove(at: index)
        
        tableView.deleteRows(
            at: [IndexPath(row: index, section: 0)],
            with: .automatic
        )
    }
    
    open func addItem(_ item: FCModel) {
        items.append(item)
        
        tableView.insertRows(
            at: [IndexPath(row: items.count, section: 0)],
            with: .none
        )
    }
    
    let keyboard = FCReplyInputView(frame: .zero).then {
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 0.2
        $0.backgroundColor = UIColor.groupTableViewBackground
    }
    var tableViewOldContentOffset: CGPoint?
    var currentReplyView: UIView?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        tableView.frame = bounds
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let v = super.hitTest(point, with: event) else {
            return nil
        }
        
        if ![[keyboard], keyboard.subviews].flatMap({$0}).contains(v) {
            keyboard.textView.resignFirstResponder()
        }
        
        return v
    }
}

extension FCView: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FCTableViewCell.ReuseIdentifier, for: indexPath) as! FCTableViewCell
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return items[indexPath.row].sizeThatFits(
            CGSize(width: UIScreen.main.bounds.width, height: 1000000)
        ).height
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        debugPrint(#function, indexPath)
        
        guard let cell = cell as? FCTableViewCell else {
            return
        }
        
        cell.model = items[indexPath.row]
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension FCView: FCReplyInputViewDelegate {
    func replySendButtonTap(replyText: String, to item: FCReplyItem?, at index: Int) {
        fcDelegate?.fcView(self, didReply: replyText, to: item, at: index)
    }
}
