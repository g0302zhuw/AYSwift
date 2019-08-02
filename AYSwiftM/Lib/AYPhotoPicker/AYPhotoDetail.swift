//
//  AYPhotoDetail.swift
//  AYSwiftM
//
//  Created by zw on 2019/4/28.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit
import Photos

class AYPhotoDetail: UIViewController,UIGestureRecognizerDelegate {
    var nowIndex:Int!

    weak var picker:AYPhotoPicker?
    
    var colletView:UICollectionView!
    
    var selectButton = UIButton()
    
    var transAnimationManager = AYPhotoTransAnimation()
    
    lazy var topV:UIView! = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEMW, height: TOPHEIGHT))
        view.alpha = 0.5
        view.backgroundColor = .darkGray
        
        let backButton = UIButton(frame: CGRect(x: 0, y: view.height - 44, width: 80, height: 44))
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        view.addSubview(backButton)
        
        return view
    }()

    lazy var bottomV:UIView! = {
        let view = UIView(frame: CGRect(x: 0, y: SCREEMH - 50 - (IS_XSeries ? 34 : 0), width: SCREEMW, height: 50 + (IS_XSeries ? 34 : 0)))
        view.alpha = 0.5
        view.backgroundColor = .darkGray
        
        let backButton = UIButton(frame: CGRect(x: view.width - 80, y: 0, width: 80, height: 50))
        backButton.setTitle("确定", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        view.addSubview(backButton)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .custom

        self.transitioningDelegate = self
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: SCREEMW, height: SCREEMH)
        flowlayout.minimumLineSpacing = 20
        flowlayout.minimumInteritemSpacing = 5
        flowlayout.scrollDirection = .horizontal
        
        colletView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEMW + 20, height: SCREEMH) ,collectionViewLayout: flowlayout)
        colletView.backgroundColor = .black
        colletView.delegate = self
        colletView.dataSource = self
        colletView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        colletView.isPagingEnabled = true
        colletView.register(AYPhotoDetailCell.self, forCellWithReuseIdentifier: "AYPhotoPickerDetailCell")
        self.view.addSubview(colletView)
        if #available(iOS 11.0, *){
            colletView.contentInsetAdjustmentBehavior = .never
        }
        
        self.view.addSubview(topV)
        selectButton.frame = CGRect(x: topV.width - 44, y: topV.height - 34, width: 24, height: 24)
        selectButton.setBackgroundImage(UIImage(named: "btn_xz_nor"), for: .normal)
        selectButton.setBackgroundImage(UIImage(named: "btn_xz_pre"), for: .selected)
        selectButton.addTarget(self, action: #selector(selectClick(bt:)), for: .touchUpInside)
        topV.addSubview(selectButton)
        selectButton.isSelected = picker!.selectArray.contains(nowIndex)
        
        self.view.addSubview(bottomV)
    }
    
    @objc func selectClick(bt:UIButton){
        if picker!.selectArray.contains(nowIndex) {
            picker!.selectArray.removeAll(where: {$0 == nowIndex})
            selectButton.isSelected = !selectButton.isSelected
        }else{
            if picker!.selectArray.count == picker!.maxCount { //最大选择数量限制
                AYToast.showBottom("最多选择\(picker!.maxCount)张图片")
                return
            }
            picker!.selectArray.append(nowIndex)
            selectButton.isSelected = !selectButton.isSelected
        }
    }
    
    @objc func okClick(){
        picker?.okClick()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func dismissSelf(){
        picker?.reloadSelect()
        self.dismiss(animated: true) {
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("AYPhotoDetail - viewDidLayoutSubviews")
        colletView.scrollToItem(at: IndexPath(row: nowIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    deinit {
        print("释放AYPhotoDetail")
    }
}


extension AYPhotoDetail:UICollectionViewDelegate,UICollectionViewDataSource,AYPhotoDetailCellDelegate,UIScrollViewDelegate,UIViewControllerTransitioningDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picker!.assets!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AYPhotoPickerDetailCell", for: indexPath) as! AYPhotoDetailCell
        cell.asset = picker!.assets![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func singleTap(_ cell:AYPhotoDetailCell){
        if self.topV.isHidden {
            self.topV.isHidden = false
            self.bottomV.isHidden = false

            UIView.beginAnimations("show", context: nil)
            UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
            UIView.setAnimationDuration(0.2)
            self.topV.alpha = 0.5
            self.bottomV.alpha = 0.5
            UIView.commitAnimations()
        }else{
            UIView.beginAnimations("hide", context: nil)
            UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(didHide))
            UIView.setAnimationDuration(0.2)
            self.topV.alpha = 0.0
            self.bottomV.alpha = 0.0
            UIView.commitAnimations()
        }
    }
    
    func dragState(_ state: dragAnimation, scale: CGFloat) {
        if state == .start {
            self.colletView.isScrollEnabled = false
            self.topV.isHidden = true
            self.bottomV.isHidden = true
        }else if state == .on {
            self.colletView.alpha = scale
        }else if state == .cancel {
            self.colletView.isScrollEnabled = true
            self.colletView.alpha = 1
        }else if state == .dismiss {
            self.dismissSelf()
        }
    }
    
    @objc func didHide(){
        self.topV.isHidden = true
        self.bottomV.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        print("当前索引" + newIndex.description)
        
        if newIndex != nowIndex{
            let cell = colletView.cellForItem(at: IndexPath(row: nowIndex, section: 0)) as? AYPhotoDetailCell
            if cell != nil{ //如果之前的cell未复位，则进行scorll复位
                cell!.scroll.setZoomScale(1, animated: false)
            }
            nowIndex = newIndex
        }
        
        selectButton.isSelected = picker!.selectArray.contains(nowIndex)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return transAnimationManager
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transAnimationManager.vc = self
        return transAnimationManager
    }
}
