//
//  AYToast.swift
//  YouQiZhan
//
//  Created by zw on 2019/4/19.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit

let toastDispalyDuration: CGFloat = 1.5 ///默认停留时间
let toastBackgroundColor = UIColor.black //背景颜色

class AYToast: NSObject {
    
    var contentView: UIButton
    var duration: CGFloat = toastDispalyDuration
    
    init(text: String) {
        let rect = text.boundingRect(with: CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude), options:[NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width + 40, height: rect.size.height + 20))
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.text = text
        textLabel.numberOfLines = 0
        
        contentView = UIButton(frame: CGRect(x: 0, y: 0, width: textLabel.frame.size.width, height: textLabel.frame.size.height))
        contentView.layer.cornerRadius = contentView.frame.size.height / 2
        contentView.backgroundColor = toastBackgroundColor
        contentView.addSubview(textLabel)
        contentView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        
        super.init()

        contentView.addTarget(self, action: #selector(toastTaped), for: .touchDown)
    }
    
    @objc func toastTaped() {
        self.hideAnimation()
    }
    
    deinit {
        print("释放AYToast")
    }
    
    func deviceOrientationDidChanged(notify: Notification) {
        self.hideAnimation()
    }
    
    
    func setDuration(duration: CGFloat) {
        self.duration = duration
    }
    
    func showAnimation() {
        UIView.beginAnimations("show", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        UIView.setAnimationDuration(0.3)
        contentView.alpha = 1.0
        UIView.commitAnimations()
    }
    
    @objc func hideAnimation() {
        UIView.beginAnimations("hide", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(dismissToast))
        UIView.setAnimationDuration(0.3)
        contentView.alpha = 0.0
        UIView.commitAnimations()
    }
    
    @objc func dismissToast() {
        contentView.removeFromSuperview()
    }
    
    func show() {
        let window: UIWindow = UIApplication.shared.windows.last!
        contentView.center = window.center
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }
    
    func showFromTopOffset(top: CGFloat) {
        let window: UIWindow = UIApplication.shared.windows.last!
        contentView.center = CGPoint(x: window.center.x, y: top + contentView.frame.size.height/2)
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }
    
    func showFromBottomOffset(bottom: CGFloat) {
        let window: UIWindow = UIApplication.shared.windows.last!
        contentView.center = CGPoint(x: window.center.x, y: window.frame.size.height - (bottom + contentView.frame.size.height/2))
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }
    
    
    
    // MARK: 中间显示
    class func showCenter(_ text: String, duration: CGFloat = toastDispalyDuration) {
        let toast: AYToast = AYToast(text: text)
        toast.setDuration(duration: duration)
        toast.show()
    }
    
    // MARK: 上方显示
    class func showTop(_ text: String, topOffset: CGFloat = 100.0, duration: CGFloat = toastDispalyDuration) {
        let toast = AYToast(text: text)
        toast.setDuration(duration: duration)
        toast.showFromTopOffset(top: topOffset)
    }
    
    // MARK: 下方显示
    class func showBottom(_ text: String, bottomOffset: CGFloat = 100.0, duration: CGFloat = toastDispalyDuration) {
        let toast = AYToast(text: text)
        toast.setDuration(duration: duration)
        toast.showFromBottomOffset(bottom: bottomOffset)
    }
}
