//
//  BaseSheet.swift
//  sjbmallbyswift
//
//  Created by gwq on 2018/12/27.
//  Copyright © 2018 zw. All rights reserved.
//

import UIKit

class AYAlert: UIView {
    var sheetHeight:CGFloat = 0
    var bottomV:UIView = UIView()
    var startRect:CGRect?
    var midRect:CGRect?
    
    lazy var titleLbl:UILabel = {
        let lbl = CreateLbl(x: SP(15), y: 0, width: SCREEMW - SP(56+30), height: SP(44), font: Font(SP(15)), color: RGBCOLOR_HEX(0xaaaaaa), text: "", align: .center)
        return lbl
    }()
    lazy var messageLbl:UILabel = {
        let lbl = CreateLbl(x: SP(15), y: 0, width: SCREEMW - SP(56+30), height: SP(97), font: Font(SP(17)), color: BlackColor, text: "", align: .center)
        lbl.numberOfLines = 0
        return lbl
    }()
    lazy var btnV:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.bottomV.height - SP(59), width: self.bottomV.width, height: SP(59)))
        return view
    }()
    
    
    var clickBlock:(Int)->() = {(index) in
        
    }
    
    func sheetHeight(title:String,message:String) -> CGFloat{
        var height:CGFloat = 0;
        if title == ""{
            if message == ""{
                height = SP(200)
            }else {
                let size = message.getSizeWith(font: self.messageLbl.font, maxSize: CGSize(width: self.messageLbl.width, height: 2000))
                if size.height > SP(141) - 10{
                    height = SP(59) + size.height + 10
                }else{
                    height = SP(200)
                }
                
            }
        } else {
            if message == ""{
                height = SP(200)
            }else {
                let size = message.getSizeWith(font: self.messageLbl.font, maxSize: CGSize(width: self.messageLbl.width, height: 2000))
                if size.height > SP(97) - 10{
                    height = SP(103) + size.height + 10
                }else{
                    height = SP(200)
                }
            }
        }
        
        if height > SCREEMH - SP(56) {
            height = SCREEMH - SP(56)
        }
        return height
    }
    
    func layoutBottomView(title:String,message:String){
        if title == ""{
            if message != ""{
                self.messageLbl.y = 0
                self.messageLbl.height = self.sheetHeight - SP(59)
                self.bottomV.addSubview(self.messageLbl)
            }
        } else {
            self.bottomV.addSubview(self.titleLbl)
            if message != ""{
                self.messageLbl.y = self.titleLbl.maxY
                self.messageLbl.height = self.sheetHeight - SP(59) - SP(44)
                self.bottomV.addSubview(self.messageLbl)
            }
        }
        self.bottomV.addSubview(self.btnV)
    }
    
    
    
    func layoutButtonsView(cancle:String,okBtn:String){
        var btnArray:Array<String> = []
        
        if cancle != "" {
            btnArray.append(cancle)
        }
        btnArray.append(okBtn)
        
        if btnArray.count == 1 {
            let btn = GreenBt(frame: CGRect.init(x: SP(20), y: 0, width: self.btnV.width - SP(40), height: SP(44)), title: btnArray.first!)
            btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
            btn.tag = 0
            self.btnV.addSubview(btn)
        }else if btnArray.count == 2 {
            let width:CGFloat = (self.btnV.width - SP(60))/2
            let leftBtn = CreateBtn(frame: CGRect(x: SP(20), y: 0, width: width, height: SP(44)), font: Font(SP(17)), title: btnArray.first!, target: self, action: #selector(btnAction(btn:)))
            leftBtn.setBackgroundImage(UIImage(named: "btbg_normal"), for: .normal)
            leftBtn.setBackgroundImage(UIImage(named: "btbg_pressed"), for: .highlighted)
            leftBtn.layer.masksToBounds = true
            leftBtn.layer.cornerRadius = SP(22)
            leftBtn.layer.borderColor = GreenColor.cgColor
            leftBtn.layer.borderWidth = SP(1)
            leftBtn.setTitleColor(GreenColor, for: .normal)
            leftBtn.tag = 0
            self.btnV.addSubview(leftBtn)
            
            let rightBtn = GreenBt(frame: CGRect.init(x: SP(40)+width, y: 0, width: width, height: SP(44)), title: btnArray.last!)
            rightBtn.titleLabel?.font = Font(SP(17))
            rightBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
            rightBtn.tag = 1
            self.btnV.addSubview(rightBtn)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backV = UIView(frame: self.bounds)
        backV.backgroundColor = RGBACOLOR_HEX(0x333333, alpha: 0.5)
        backV.alpha = 0.3
        self.addSubview(backV)
    }
    
    @objc func btnAction(btn:UIButton){
        self.dismiss()
        self.clickBlock(btn.tag)
    }

    //弹出alert
    static func show(title:String = "",message:String = "",cancle:String = "",okBtn:String = "确定",clickAction:@escaping (Int)->()){
        
        let alert = AYAlert(frame: UIScreen.main.bounds)
        alert.clickBlock = clickAction
        alert.sheetHeight = alert.sheetHeight(title: title, message: message)
        
        alert.startRect = CGRect(x: SP(28), y: (SCREEMH - alert.sheetHeight)/2, width: SCREEMW - SP(56), height: alert.sheetHeight)
        alert.midRect = CGRect(x: SP(28), y: (SCREEMH - alert.sheetHeight)/2, width: SCREEMW - SP(56), height: alert.sheetHeight)
        
        alert.bottomV = UIView.init(frame: alert.startRect!)
        alert.bottomV.backgroundColor = .white
        alert.bottomV.layer.cornerRadius = 5
        alert.bottomV.clipsToBounds = true
        alert.addSubview(alert.bottomV)
        
        alert.layoutBottomView(title: title, message: message)
        alert.layoutButtonsView(cancle: cancle, okBtn: okBtn)
        
        alert.titleLbl.text = title
        alert.messageLbl.text = message
        
        alert.frame = UIScreen.main.bounds
        let window = UIApplication.shared.keyWindow!
        window.addSubview(alert)
        alert.show()
    }
    
    func show(){
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.25
        popAnimation.values = [NSValue.init(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1.0)),
                               NSValue.init(caTransform3D: CATransform3DMakeScale(1.02, 1.02, 1.0)),
                               NSValue.init(caTransform3D: CATransform3DMakeScale(0.98, 0.98, 1.0)),
                               NSValue.init(caTransform3D:CATransform3DIdentity)]
        popAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0]
        popAnimation.timingFunctions = [CAMediaTimingFunction.init(name: .easeInEaseOut),
                                        CAMediaTimingFunction.init(name: .easeInEaseOut),
                                        CAMediaTimingFunction.init(name: .easeInEaseOut)]
        self.bottomV.layer.add(popAnimation, forKey: nil)
    }
    
    func dismiss(){
        self.removeFromSuperview()
    }
    
    deinit {
        print("释放AYAlert")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
