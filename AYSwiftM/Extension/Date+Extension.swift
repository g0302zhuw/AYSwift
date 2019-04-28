//
//  Date+Extension.swift
//  sjbsdybyswift
//
//  Created by zw on 2018/12/25.
//  Copyright © 2018 zw. All rights reserved.
//

import Foundation


extension Date{
    
    func yyyy_MM_dd(mark:String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy" + mark + "MM" + mark + "dd"
        return dateformatter.string(from: self)
    }
    
    func MM_dd(mark:String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM" + mark + "dd"
        return dateformatter.string(from: self)
    }
    
    func yy_MM_(mark1:String , mark2:String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy" + mark1 + "MM" + mark2
        return dateformatter.string(from: self)
    }
    
    func getZeroTime() -> Int {
        let calendar = Calendar.current
        var comps = calendar.dateComponents([Calendar.Component.year,
                                             Calendar.Component.month,
                                             Calendar.Component.day,
                                             Calendar.Component.hour,
                                             Calendar.Component.minute], from:self)
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let gregorian = Calendar.init(identifier: .gregorian)
        let dd:Date = gregorian.date(from: comps)!
        return Int(dd.timeIntervalSince1970)
    }
}

func getDateString(time:Int,formate:String) -> String {
    let date:Date = NSDate.init(timeIntervalSince1970: TimeInterval(time/1000)) as Date
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = formate
    return dateformatter.string(from: date)
}
