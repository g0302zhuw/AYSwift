//
//  SJB_ActionSheet.swift
//  YouQiZhan
//
//  Created by zw on 2019/3/21.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit

class AYActionSheet: UIView {
    
    typealias AYActionSheetBlock = (_ index:Int) -> Void
    
    var animationView:UIView!
    var block : AYActionSheetBlock?
    
    init(frame: CGRect , array:Array<String>) {
        super.init(frame: frame)
        
        let backV = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        backV.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        backV.alpha = 0.8
        backV.addTarget(self, action: #selector(closeSelf), for: .touchUpInside)
        self.addSubview(backV)
        
        animationView = UIView(frame: CGRect(x: 0, y: frame.size.height, width: frame.size.width, height: CGFloat(array.count) * 60 + (IS_XSeries ? 34 : 0)))
        animationView.backgroundColor = UIColor.white
        self.addSubview(animationView)
        
        for i in 0...array.count - 1 {
            let bt = UIButton(frame: CGRect(x: 0, y: 60 * CGFloat(i), width: animationView.width, height: 60))
            bt.setBackgroundImage(UIImage(named: "btbg_normal"), for: .normal)
            bt.setBackgroundImage(UIImage(named: "btbg_pressed"), for: .highlighted)
            bt.setTitle(array[i], for: .normal)
            bt.setTitleColor(BlackColor, for: .normal)
            bt.titleLabel?.font = Font(20)
            bt.addTarget(self, action: #selector(selectClick(bt:)), for: .touchUpInside)
            bt.tag = i
            animationView.addSubview(bt)
            
            if i > 0 {
                AddLine(frame: CGRect(x: 0, y: 0, width: bt.width, height: LineValue), view: bt)
            }
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.animationView.y = self.height - self.animationView.height
        }) { (completed) in
        }
    }
    
    @objc func selectClick(bt:UIButton){
        if self.block != nil {
            self.block!(bt.tag)
        }
        self.closeSelf()
    }
    
    @objc func closeSelf(){
        UIView.animate(withDuration: 0.25, animations: {
            self.animationView.y = self.height
        }) { (completed) in
            self.removeFromSuperview()
        }
    }
    
    static func show(_ array:Array<String>, block:@escaping AYActionSheetBlock){
        let view = AYActionSheet(frame: CGRect(x: 0, y: 0, width: SCREEMW, height: SCREEMH), array: array)
        view.block = block
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    deinit {
        print("释放AYActionSheet")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
