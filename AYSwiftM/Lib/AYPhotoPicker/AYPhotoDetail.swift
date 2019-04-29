//
//  AYPhotoDetail.swift
//  AYSwiftM
//
//  Created by zw on 2019/4/28.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit
import Photos

class AYPhotoDetail: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var selectArray:Array<Int>!
    var assets:PHFetchResult<PHAsset>!
    var nowIndex:Int!

    var colletView:UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AYPhotoPickerDetailCell", for: indexPath) as! AYPhotoDetailCell
        cell.asset = assets[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: SCREEMW, height: SCREEMH)
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.scrollDirection = .horizontal
        
        colletView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEMW, height: SCREEMH) ,collectionViewLayout: flowlayout)
        colletView.backgroundColor = .black
        colletView.delegate = self
        colletView.dataSource = self
        colletView.isPagingEnabled = true
        colletView.register(AYPhotoDetailCell.self, forCellWithReuseIdentifier: "AYPhotoPickerDetailCell")
        self.view.addSubview(colletView)
        if #available(iOS 11.0, *){
            colletView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        colletView.scrollToItem(at: IndexPath(row: nowIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    deinit {
        print("释放AYPhotoDetail")
    }
}



class AYPhotoDetailCell:UICollectionViewCell,UIScrollViewDelegate{
    var imageView = UIImageView()
    var scroll = UIScrollView()
    
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
        
        imageView.frame = CGRect(x: 0, y: 0, width: scroll.width, height: scroll.height)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        scroll.addSubview(imageView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func updateAsset(_ photo:PHAsset){
        let manager = PHImageManager.default()
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        manager.requestImageData(for: photo, options: options) { (data, string, orientation, info) in
            self.imageView.image = UIImage(data: data!)
        }
        scroll.setZoomScale(1, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
