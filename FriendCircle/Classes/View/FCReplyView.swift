//
//  FCReplyView.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/25.
//

import UIKit

protocol FCReplyViewDelegate: NSObjectProtocol {
    func didTapReplyItem(_ item: FCReplyItem)
    func didTapReplyUser(_ user: FCUserInfo)
    func didLongTapReplyItem(_ item: FCReplyItem, at view: UIView)
}

class FCReplyView: UIView {
    var replys: [FCReplyItem] = [] {
        didSet {
            tableView.isScrollEnabled = replys.count > 20
        }
    }
    let tableView = UITableView(frame: .zero, style: .plain)
    
    weak var delegate: FCReplyViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .fc
        addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .fc
        tableView.separatorStyle = .none
        
        tableView.register(
            FCReplyTableViewCell.self,
            forCellReuseIdentifier: FCReplyTableViewCell.ReuseIdentifier
        )
    }
    
    override func layoutSubviews() {
        tableView.frame = CGRect(
            x: 0, y: 0, width: bounds.width, height: bounds.height - 4
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if replys.count <= 20 {
            return CGSize(
                width: size.width,
                height: replys.reduce(CGFloat(0)) { let item = $1
                    return $0 + item.sizeThatFits(size).height
                } + 4
            )
        }

        return CGSize(
            width: size.width,
            height: Array(replys[0..<20]).reduce(CGFloat(0)) { let item = $1
                return $0 + item.sizeThatFits(size).height
            } + 4
        )
    }
}

extension FCReplyView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FCReplyTableViewCell.ReuseIdentifier, for: indexPath) as! FCReplyTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return replys[indexPath.row].sizeThatFits(
            CGSize(width: bounds.width, height: 100000)
        ).height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
        delegate?.didTapReplyItem(replys[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? FCReplyTableViewCell else {
            return
        }
        
        DispatchQueue.main.async {
            cell.delegate = self
            cell.item = self.replys[indexPath.row]
        }
    }
}


extension FCReplyView: FCReplyTableViewCellDelegate {
    func replyViewCell(_ cell: FCReplyTableViewCell, didLongTapAt item: FCReplyItem) {
        delegate?.didLongTapReplyItem(item, at: cell)
    }
    
    func replyViewCell(_ cell: FCReplyTableViewCell, didTap user: FCUserInfo) {
        delegate?.didTapReplyUser(user)
    }
}
