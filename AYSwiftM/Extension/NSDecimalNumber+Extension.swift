//
//  NSDecimalNumber+Extension.swift
//  SDY
//
//  Created by zw on 2019/1/15.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit

class NSDecimalNumber_Extension: NSDecimalNumber {

}



precedencegroup MyPrecedence {
    associativity: left
    assignment: false
    higherThan:MultiplicationPrecedence
}

infix operator ->/: MyPrecedence  //声明操作符 高精度除法^^

func ->/(left: Int, right: Int) -> NSDecimalNumber {
        return NSDecimalNumber.init(value: left).dividing(by: NSDecimalNumber.init(value: right))
}

func ->/(left: Double, right: Int) -> NSDecimalNumber {
    return NSDecimalNumber.init(value: left).dividing(by: NSDecimalNumber.init(value: right))
}

func ->/(left: String, right: Int) -> NSDecimalNumber {
    return NSDecimalNumber.init(string: left).dividing(by: NSDecimalNumber.init(value: right))
}


