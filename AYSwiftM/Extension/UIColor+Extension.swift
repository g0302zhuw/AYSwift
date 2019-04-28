//
//  UIColor+Extension.swift
//  YouQiZhan
//
//  Created by zw on 2019/3/28.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit

extension UIColor {

    //通过颜色创建图片
    func toImage(_ size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
