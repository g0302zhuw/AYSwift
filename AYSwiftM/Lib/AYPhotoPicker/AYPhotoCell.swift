//
//  AYPhotoCell.swift
//  AYSwiftM
//
//  Created by zw on 2019/8/2.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit
import Photos

protocol AYPhotoCellDelegate:NSObjectProtocol {
    func AYPhotoCellSelect(_ cell:AYPhotoCell)
}

class AYPhotoCell:UICollectionViewCell{
    var imageView = UIImageView()
    var selectButton = UIButton()
    weak var delegate:AYPhotoCellDelegate?
    
    var asset:PHAsset?{
        didSet{
            self.updateAsset(asset!)
        }
    }
    
    var select:Bool?{
        didSet{
            self.updateSelect(select!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        self.contentView.addSubview(imageView)
        
        selectButton.frame = CGRect(x: frame.size.width - 50, y: 0, width: 50, height: 50)
        selectButton.setImage(UIImage(named: "btn_xz_nor"), for: .normal)
        selectButton.setImage(UIImage(named: "btn_xz_pre"), for: .selected)
        selectButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        selectButton.contentHorizontalAlignment = .right
        selectButton.addTarget(self, action: #selector(selectClick(bt:)), for: .touchUpInside)
        self.contentView.addSubview(selectButton)
    }
    
    @objc func selectClick(bt:UIButton){
        if self.delegate != nil {
            self.delegate?.AYPhotoCellSelect(self)
        }
    }
    
    func updateAsset(_ photo:PHAsset){
        let manager = PHImageManager.default()
        manager.requestImage(for: photo, targetSize: CGSize(width: AYitemWidth * 1.5, height: AYitemWidth * 1.5), contentMode: .aspectFit, options: nil) { (image, info) in
            self.imageView.image = image
        }
    }
    
    func updateSelect(_ select:Bool){
        selectButton.isSelected = select
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
