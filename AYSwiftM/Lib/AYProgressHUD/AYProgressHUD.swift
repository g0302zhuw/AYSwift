//
//  AYProgressHUD.swift
//  AYSwiftM
//
//  Created by zw on 2019/4/23.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit

class AYProgressHUD: UIView {
    
    static func show(_ title:String = "加载中..."){
        AYProgressHUD.dimMiss()
        
        let view = AYProgressHUD(frame: CGRect(x: 0, y: 0, width: SCREEMW, height: SCREEMH) ,title: title)
        view.tag = 654321
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    static func dimMiss(){
        let hudView = UIApplication.shared.keyWindow?.viewWithTag(654321)
        if hudView != nil {
            let hudView = hudView as!AYProgressHUD
            hudView.removeAnimation()
            hudView.removeFromSuperview()
        }
    }
    

    var circleLayer = CAShapeLayer()
    var backgroundView = UIView()
    var titleLbl : UILabel!
    
    init(frame: CGRect , title: String) {
        super.init(frame: frame)
        
        let backV = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.addSubview(backV)
        
        backgroundView.size = CGSize(width:100 ,height:100)
        backgroundView.center = backV.center
        backgroundView.backgroundColor = .black
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 6
        backV.addSubview(backgroundView)

        circleLayer.bounds = CGRect(x: 30, y: 10, width: 40, height: 40)
        circleLayer.position = CGPoint(x: 50 , y: 40)
        circleLayer.path = UIBezierPath.init(ovalIn: CGRect(x: 30, y: 10, width: 40, height: 40)).cgPath
        circleLayer.strokeColor = UIColor.white.cgColor //划线
        circleLayer.lineWidth = 2
        circleLayer.strokeEnd = 0.85 //绘制结束位置
        circleLayer.lineCap = .round //绘制的线开始和结束位置的线头样式
        backgroundView.layer.addSublayer(circleLayer)

        titleLbl = AddLbl(x: 10, y: 70, width: 80, height: 25, font: BFont(15), color: .white, text: title, align: .center, view: backgroundView)
        backgroundView.addSubview(titleLbl)
        
        backgroundView.alpha = 0.0

        UIView.beginAnimations("show", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        UIView.setAnimationDuration(0.25)
        backgroundView.alpha = 1.0
        UIView.commitAnimations()
        
        self.addAnimation()
    }
    
    //移除动画
    func removeAnimation(){
        circleLayer.removeAnimation(forKey: "AYProgressHUD_ROLE")
    }
    
    //添加动画
    func addAnimation(){
        let roleAnimtation = CABasicAnimation(keyPath: "transform.rotation.z")
        roleAnimtation.repeatCount = Float.greatestFiniteMagnitude
        roleAnimtation.duration = 1
        roleAnimtation.fromValue = 0
        roleAnimtation.toValue = .pi * 2.0
        roleAnimtation.isRemovedOnCompletion = false
        circleLayer.add(roleAnimtation, forKey: "AYProgressHUD_ROLE")
    }
    
    deinit {
        print("释放AYProgressHUD")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
