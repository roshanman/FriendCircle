//
//  Date+Extension.swift
//  FriendCircle
//
//  Created by zhangxiuming on 2017/09/23.
//

import Foundation

extension Date {
    var formatedPublish: String {
        let now = Date()
        
        let interval = now.timeIntervalSince(self)
        
        let hour = Int(interval / 3600)
        
        switch hour {
        case 0:
            return "刚刚"
        case 1...23:
            return "\(hour)小时前"
        default:
            if year != now.year {
                return "\(now.year - year)年前"
            }
            
            if month != now.month {
                return "\(now.month - month)月前"
            }
            
            return "\(now.day - day)天前"
        }
    }
}


extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}
