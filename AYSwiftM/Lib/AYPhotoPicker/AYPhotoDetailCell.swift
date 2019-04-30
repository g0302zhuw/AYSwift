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
}

class AYPhotoDetailCell:UICollectionViewCell,UIScrollViewDelegate{
    var imageView = UIImageView()
    var scroll = UIScrollView()
    weak var delegate:AYPhotoDetailCellDelegate?
    
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
        if #available(iOS 11.0, *){
            scroll.contentInsetAdjustmentBehavior = .never
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: scroll.width, height: scroll.height)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        scroll.addSubview(imageView)
        
        
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
                self.imageView.frame = CGRect(x: 0, y: (self.scroll.height - imageHeight) / 2, width: SCREEMW, height: imageHeight)
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

