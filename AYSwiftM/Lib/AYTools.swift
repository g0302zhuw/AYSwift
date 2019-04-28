//
//  UIFunction.swift
//  sjbmallbyswift
//
//  Created by zw on 2018/11/1.
//  Copyright © 2018 zw. All rights reserved.
//

import UIKit


//------------------------刘海屏------------------------
let IS_XSeries = isFullScreen()
let TOPHEIGHT = IS_XSeries ? CGFloat(88) : CGFloat(64)
let KContentH = SCREEMH - TOPHEIGHT


//------------------------颜色------------------------
let GreenColor      = RGBCOLOR_HEX(0x1CC466)
let BlackColor      = RGBCOLOR_HEX(0x333333)
let DarkColor       = RGBCOLOR_HEX(0x666666)
let GrayColor       = RGBCOLOR_HEX(0xaaaaaa)
let BlueColor       = RGBCOLOR_HEX(0x2E8EFF)
let RedColor        = RGBCOLOR_HEX(0xF35856)
let ContentColor    = RGBCOLOR_HEX(0x93a4b5)
let MoneyColor      = RGBCOLOR_HEX(0xff9900)
let BackGroundColor = RGBCOLOR_HEX(0xF0F3F9)
let LineColor       = RGBCOLOR_HEX(0xd9d9d9)



func RGBColor(r :CGFloat ,g:CGFloat,b:CGFloat,a:CGFloat) ->UIColor{
    return UIColor.init(red: r / 255.0, green:g / 255.0 , blue:b / 255.0, alpha: 1)
}

public func RGBCOLOR_HEX(_ h:Int) ->UIColor {
    return RGBColor(r: CGFloat(((h)>>16) & 0xFF), g:   CGFloat(((h)>>8) & 0xFF), b:  CGFloat((h) & 0xFF), a: 1.0)
}

public func RGBACOLOR_HEX(_ h:Int , alpha:CGFloat) ->UIColor {
    return RGBColor(r: CGFloat(((h)>>16) & 0xFF), g:   CGFloat(((h)>>8) & 0xFF), b:  CGFloat((h) & 0xFF),a: alpha)
}


//------------------------尺寸比例------------------------
let SCREEMW = UIScreen.main.bounds.size.width
let SCREEMH = UIScreen.main.bounds.size.height
let SCALE = UIScreen.main.bounds.size.width / 375
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
let LineValue = 1 / UIScreen.main.scale

public func SP(_ width:CGFloat)->CGFloat{
    return width * SCALE
}

public func SP(_ width:Int)->CGFloat{
    return CGFloat(width) * SCALE
}

//------------------------字体------------------------
public func Font(_ size:CGFloat) ->UIFont{
    return UIFont.systemFont(ofSize: size)
}
public func BFont(_ size:CGFloat) ->UIFont{
    return UIFont.boldSystemFont(ofSize: size)
}



//添加线
public func AddLine(frame:CGRect ,view:UIView){
    let line = UIView(frame: frame)
    line.backgroundColor = LineColor
    view.addSubview(line)
}

//添加箭头
public func AddArrow(x:CGFloat, y:CGFloat, width:CGFloat,height:CGFloat ,view:UIView){
    let arrow = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
    arrow.image = UIImage(named: "ico_goto")
    view.addSubview(arrow)
}


//创建Lbl
public func CreateLbl(x:CGFloat, y:CGFloat, width:CGFloat,height:CGFloat, font:UIFont, color:UIColor, text:String ,align:NSTextAlignment) -> UILabel {
    let lbl = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
    lbl.font = font
    lbl.textColor = color
    lbl.text = text
    lbl.textAlignment = align
    return lbl
}

//添加标签
public func AddLbl(x:CGFloat, y:CGFloat, width:CGFloat,height:CGFloat, font:UIFont, color:UIColor, text:String ,align:NSTextAlignment, view:UIView) -> UILabel{
    let lbl = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
    lbl.font = font
    lbl.textColor = color
    lbl.text = text
    lbl.textAlignment = align
    view.addSubview(lbl)
    return lbl
}

//常规的标题标签
public func AddNoteLbl(y:CGFloat,text:String ,view:UIView) -> UILabel{
    return AddLbl(x: SP(16), y: y, width: 300, height: SP(52), font: Font(SP(17)), color: BlackColor, text: text, align: .left, view: view)
}


//创建scrollView
public func CreateScroll(frame:CGRect) -> UIScrollView{
    let scroll = UIScrollView.init(frame: frame)
    scroll.backgroundColor = BackGroundColor
    scroll.showsHorizontalScrollIndicator = false
    scroll.showsVerticalScrollIndicator = false
    if #available(iOS 11, *) {
        scroll.contentInsetAdjustmentBehavior = .never
    }
    return scroll
}

//创建Table
public func CreateTable(frame:CGRect,target:Any,style:UITableView.Style = .plain)->UITableView{
    let table = UITableView(frame:frame, style:style)
    table.backgroundColor = BackGroundColor
    table.showsHorizontalScrollIndicator = false
    table.showsVerticalScrollIndicator = false
    table.dataSource = (target as! UITableViewDataSource)
    table.delegate = (target as! UITableViewDelegate)
    if #available(iOS 11, *) {
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table.contentInsetAdjustmentBehavior = .never
    }
    return table
}

//添加白色背景
public func AddWhiteBack(x:CGFloat, y:CGFloat, width:CGFloat,height:CGFloat, view:UIView) -> UIView {
    let v = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    v.backgroundColor = UIColor.white
    view.addSubview(v)
    return v
}

//创建图片
public func AddImgV(x:CGFloat, y:CGFloat, width:CGFloat,height:CGFloat ,name:String,view:UIView)->UIImageView{
    let imgV = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
    imgV.image = UIImage(named: name)
    view.addSubview(imgV)
    return imgV
}

//创建按钮
public func CreateBtn(frame:CGRect,font:UIFont,title:String,target:Any?,action:Selector)->UIButton{
    let bt = UIButton(frame: frame)
    bt.setTitle(title, for: UIControl.State.normal)
    bt.titleLabel?.font = font
    bt.addTarget(target, action: action, for: .touchUpInside)
    return bt
}

//空按钮
public func AddClearBtn(frame:CGRect,target:Any?,action:Selector,view:UIView){
    let bt = UIButton(frame: frame)
    bt.addTarget(target, action: action, for: .touchUpInside)
    view.addSubview(bt)
}

//绿色按钮
public func GreenBt(frame:CGRect ,title:String)->UIButton{
    let bt = UIButton(frame: frame)
    bt.setBackgroundImage(UIImage(named: "btn_green_nor"), for: .normal)
    bt.setBackgroundImage(UIImage(named: "btn_green_pre"), for: .highlighted)
    bt.setTitle(title, for: UIControl.State.normal)
    bt.titleLabel?.font = UIFont.systemFont(ofSize: 18 * SCALE)
    bt.layer.masksToBounds = true
    bt.layer.cornerRadius = frame.size.height / 2
    return bt
}

//创建textfield
public func AddTextField(frame:CGRect,placeholder:String,color:UIColor,font:UIFont,align:NSTextAlignment,view:UIView) -> UITextField{
    let txt = UITextField(frame: frame)
    txt.placeholder = placeholder
    txt.textColor = color
    txt.font = font
    txt.textAlignment = align
    view.addSubview(txt)
    return txt
}

//右边的输入框
public func AddRightField(frame:CGRect,placeholder:String,view:UIView) ->UITextField{
    return AddTextField(frame: frame, placeholder: placeholder, color: BlackColor, font: Font(SP(17)), align: .right, view: view)
}


//默认空视图
public func CreateNullView(frame:CGRect ,title:String ,name:String) ->UIView{
    let view = UIView(frame: frame)

    let roundV = UIView(frame: CGRect(x: 10, y: 10, width: frame.size.width - 20, height: frame.size.height - 20))
    roundV.backgroundColor = UIColor.white
    roundV.layer.masksToBounds = true
    roundV.layer.cornerRadius = 6
    view.addSubview(roundV)
    
    let imgV = AddImgV(x: (frame.size.width - 150) / 2, y: (frame.size.height - 200) / 2, width: 150, height: 150, name: name, view: roundV)
    
    let _ = AddLbl(x: 0, y: imgV.frame.maxY + 28, width: frame.size.width, height: 21, font: Font(15), color: ContentColor, text: title, align: .center, view: roundV)
    
    return view
}



public func isFullScreen()->Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            return true
        }
    }
    return false
}
