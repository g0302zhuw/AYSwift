//
//  AYPhotoDetailCell.swift
//  AYSwiftM
//
//  Created by zw on 2019/4/30.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit
import Photos

protocol AYPhotoDetailCellDelegate:NSObjectProtocol {
    func singleTap(_ cell:AYPhotoDetailCell)
    func dragStart()
    func dragEnd(_ close:Bool)
}

class AYPhotoDetailCell:UICollectionViewCell{
    var imageView = UIImageView()
    var scroll = UIScrollView()
    weak var delegate:AYPhotoDetailCellDelegate?
    
    private var zoomStart = false //是否开始缩放
    private var startDrag = false//是否开始拖拽
    private var noResponse = false//是否需要对手势做出响应
    private var originFrame = CGRect.zero//原始位置
    private var distanceToCenter = CGSize.zero//触摸点距离视图中心点距离
    
    lazy var animationImageView = UIImageView() //用来播放下滑关闭页面动画的视图
    private var startOffsetOfScrollView = CGPoint.zero //记录播放下滑关闭页面动画时scrollview的偏移值
    private var frameOfOriginalOfImageView:CGRect! //记录播放下滑关闭页面动画时imageview在window上的坐标
    private var startScaleWidthInAnimationView:CGFloat = 1.0
    private var startScaleheightInAnimationView:CGFloat = 1.0
    private var animateImageViewIsStart = false
    private var lastPointX:CGFloat = 0 //上一次触摸点x值
    private var lastPointY:CGFloat = 0 //上一次触摸点y值
    private var totalOffsetY:CGFloat = 0
    private var totalOffsetX:CGFloat = 0


    var asset:PHAsset?{
        didSet{
            self.updateAsset(asset!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scroll.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        self.contentView.addSubview(scroll)
        scroll.maximumZoomScale = 2
        scroll.minimumZoomScale = 1
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = true
        scroll.contentSize = CGSize(width: scroll.bounds.size.width, height: scroll.bounds.size.height)
        if #available(iOS 11.0, *){
            scroll.contentInsetAdjustmentBehavior = .never
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: scroll.width, height: scroll.height)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        scroll.addSubview(imageView)
        
        
        //单击，双击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(tap:)))
        tap.numberOfTapsRequired = 2
        tap.numberOfTouchesRequired = 1
        scroll.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action:#selector(singleTap(tap:)))
        scroll.addGestureRecognizer(tap2)
        
        tap2.require(toFail: tap)
    }
    
    @objc func doubleTap(tap:UITapGestureRecognizer){
        if scroll.zoomScale != 1 {
            scroll.setZoomScale(1, animated: true)
        }else{
            scroll.setZoomScale(2, animated: true)
        }
    }
    
    @objc func singleTap(tap:UITapGestureRecognizer){
        if delegate != nil {
            delegate?.singleTap(self)
        }
    }
    
    override func layoutSubviews() {

    }
    
    func updateAsset(_ photo:PHAsset){
        let manager = PHImageManager.default()
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.version = .current
        
        manager.requestImage(for: photo, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (image, info) in
            if image != nil {
                self.imageView.image = image
                let imageHeight = SCREEMW * ((image?.size.height)!/(image?.size.width)!)
                self.imageView.frame = CGRect(x: 0, y: (self.scroll.bounds.size.height - imageHeight) / 2, width: SCREEMW, height: imageHeight)
            }
        }
    }

    override func prepareForReuse() {
        scroll.setZoomScale(1, animated: false)
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//scroll相关代理处理
extension AYPhotoDetailCell:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var imageViewOrign = self.imageView.frame.origin
        let width = self.imageView.frame.size.width
        let height = self.imageView.frame.size.height
        let scrollViewHeight = scrollView.bounds.size.height
        let scrollViewWidth = scrollView.bounds.size.width
        
        if (height > scrollViewHeight) {
            imageViewOrign.y = 0
        } else {
            imageViewOrign.y = (scrollViewHeight - height) / 2.0
        }
        if (width > scrollViewWidth) {
            imageViewOrign.x = 0
        } else {
            imageViewOrign.x = (scrollViewWidth - width) / 2.0
        }
        self.imageView.frame.origin = imageViewOrign
        
        print("scroll:" + scrollViewHeight.description)
        print("iamge: height " + height.description + "y " + imageViewOrign.y.description)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("开始缩放scroll")
        zoomStart = true
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("开始拖拽，记录此时的相关属性")
        let point = scrollView.panGestureRecognizer.location(in: self)
        startOffsetOfScrollView = scrollView.contentOffset
        frameOfOriginalOfImageView = self.imageView.convert(self.imageView.bounds, to: UIApplication.shared.keyWindow)
        startScaleWidthInAnimationView = (point.x - frameOfOriginalOfImageView.origin.x) / frameOfOriginalOfImageView.size.width
        startScaleheightInAnimationView = (point.y - frameOfOriginalOfImageView.origin.y) / frameOfOriginalOfImageView.size.height
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("结束拖拽")
        zoomStart = false
        
        if self.animationImageView.superview != nil {
            UIView.animate(withDuration: 0.25, animations: {
                self.animationImageView.frame = self.frameOfOriginalOfImageView
            }) { (_) in
                self.scroll.contentOffset = self.startOffsetOfScrollView
                self.animationImageView.removeFromSuperview()
                self.imageView.isHidden = false
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.didScrollPanGesture(scrollView)
    }
    
    //处理拖拽滑动的页面动画
    func didScrollPanGesture(_ scrollView: UIScrollView){
        if zoomStart { //如果scrollview在缩放中返回
            return
        }
        let pan = scrollView.panGestureRecognizer
        if (pan.numberOfTouches != 1){ //如果不是单个手指的手势，直接返回
            return
        }
        
        let point = pan.location(in: self)
        if scrollView.contentOffset.y < -10 && point.y > lastPointY && abs(point.y) > abs(point.x) && self.animationImageView.superview == nil {
            print("添加动画视图")
            self.imageView.isHidden = true//临时处理，隐藏原imageview
            totalOffsetY = 0
            totalOffsetX = 0
            self.animateImageViewIsStart = true
            self.animationImageView.image = self.imageView.image
            self.animationImageView.frame = frameOfOriginalOfImageView
            UIApplication.shared.keyWindow?.addSubview(self.animationImageView)
        }
        
        if pan.state == .changed {
            if self.animationImageView.superview != nil {
                let maxHeight = self.bounds.size.height
                if (maxHeight <= 0){
                    return
                }
                //偏移
                var offsetX = point.x - lastPointX
                var offsetY = point.y - lastPointY
                if (animateImageViewIsStart) {
                    offsetX = 0
                    offsetY = 0
                    animateImageViewIsStart = false
                }
                totalOffsetX += offsetX
                totalOffsetY += offsetY
                //缩放比例
                var scale = (1 - totalOffsetY / maxHeight)
                if (scale > 1){ scale = 1}
                if (scale < 0){ scale = 0}

                let width = frameOfOriginalOfImageView.size.width * scale
                let height = frameOfOriginalOfImageView.size.height * scale
                self.animationImageView.frame = CGRect(x: point.x - width * startScaleWidthInAnimationView, y: point.y - height * startScaleheightInAnimationView, width: width, height: height)
            }
        }

        lastPointY = point.y
        lastPointX = point.x
    }
}
