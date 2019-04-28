//
//  SJB_PickerView.swift
//  YouQiZhan
//
//  Created by zw on 2019/3/18.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit

typealias SJB_PickerBlock = (_ index:Int) -> Void


class AYPicker: UIView , UIPickerViewDelegate ,UIPickerViewDataSource{
    var block:SJB_PickerBlock?
    var animationView:UIView!
    var picker:UIPickerView!
    
    var pickerArray = [String]()
    
    //静态方法调用
    static func show(array:Array<String>, index:Int = 0, block:@escaping SJB_PickerBlock){
        let view = AYPicker(frame: CGRect(x: 0, y: 0, width: SCREEMW, height: SCREEMH), array: array ,index: index)
        view.block = block
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView.subviews[1].backgroundColor = LineColor
        pickerView.subviews[2].backgroundColor = LineColor
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    

    init(frame: CGRect ,array:Array<String> ,index:Int) {
        super.init(frame: frame)
        
        pickerArray = array
        
        let back = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        back.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        back.alpha = 0.8
        back.addTarget(self, action: #selector(closeSelf), for: .touchUpInside)
        self.addSubview(back)

        
        animationView = AddWhiteBack(x: 0, y: frame.size.height, width: frame.size.width, height: 240 + (IS_XSeries ? 34 : 0), view: self)
   
        picker = UIPickerView(frame: CGRect(x: 0, y: 40, width: animationView.width, height: 200))
        picker.delegate = self
        picker.dataSource = self
        animationView.addSubview(picker)
        
        let closeBt = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        closeBt.tag = 0
        closeBt.setTitle("取消", for: .normal)
        closeBt.setTitleColor(GreenColor, for: .normal)
        closeBt.addTarget(self, action: #selector(btClick(bt:)), for: .touchUpInside)
        animationView.addSubview(closeBt)

        let okBt = UIButton(frame: CGRect(x: frame.size.width - 70, y: 0, width: 70, height: 40))
        okBt.tag = 1
        okBt.setTitle("确定", for: .normal)
        okBt.setTitleColor(GreenColor, for: .normal)
        okBt.addTarget(self, action: #selector(btClick(bt:)), for: .touchUpInside)
        animationView.addSubview(okBt)
        
        if index != 0 {
            self.picker.selectRow(index, inComponent: 0, animated: true)
        }

        UIView.animate(withDuration: 0.25, animations: {
            self.animationView.y = self.frame.size.height - self.animationView.height
        }) { (finished) in
        }
    }
    
    @objc func btClick(bt:UIButton){
        if bt.tag == 1 {
            if self.block != nil {
                let row = self.picker.selectedRow(inComponent: 0)
                self.block!(row)
            }
        }
        self.closeSelf()
    }
    
    @objc func closeSelf(){
        UIView.animate(withDuration: 0.25, animations: {
            self.animationView.y = self.frame.size.height
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
