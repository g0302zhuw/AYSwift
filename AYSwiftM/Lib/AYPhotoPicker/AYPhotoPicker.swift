//
//  AYPhotoPicker.swift
//  AYSwiftM
//
//  Created by zw on 2019/4/28.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit
import Photos

let AYitemWidth = (SCREEMW - 3) / 4

class AYPhotoPicker: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,AYPhotoCellDelegate {
    
    static func show(_ maxCount:Int){
        let picker = AYPhotoPicker()
        picker.maxCount = maxCount
        let nav = UINavigationController(rootViewController: picker)
        nav.navigationBar.isTranslucent = false
        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
    }

    
    var colletView:UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AYPhotoPickerCell", for: indexPath) as! AYPhotoCell
        cell.delegate = self
        cell.asset = assets[indexPath.row]
        cell.select = selectArray.contains(indexPath.row)
        return cell
    }
    
    func AYPhotoCellSelect(_ cell: AYPhotoCell) {
        let index = colletView.indexPath(for: cell)?.row
        if selectArray.contains(index!) {
            selectArray.removeAll(where: {$0 == index!})
            cell.select = !cell.selectButton.isSelected
        }else{
            if selectArray.count == maxCount { //最大选择数量限制
                AYToast.showBottom("最多选择\(maxCount)张图片")
                return
            }
            selectArray.append(index!)
            cell.select = !cell.selectButton.isSelected
        }
        
        okBt.setTitle("确定(\(selectArray.count))", for: .normal)
        okBt.isEnabled = (selectArray.count > 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AYPhotoDetail()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var okBt = UIButton()

    var maxCount = 1
    var assets:PHFetchResult<PHAsset>!
    var selectArray = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "选择照片"
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelClick))

        okBt.frame = CGRect(x: 0, y: 0, width: 60, height: (self.navigationController?.navigationBar.frame.size.height)!)
        okBt.setTitle("确定", for: .normal)
        okBt.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        okBt.setTitleColor(GreenColor, for: .normal)
        okBt.contentHorizontalAlignment = .right
        okBt.setTitleColor(RGBCOLOR_HEX(0xA5E8C2), for: .disabled)
        okBt.titleLabel?.font = Font(15)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: okBt)
        okBt.isEnabled = false
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: AYitemWidth, height: AYitemWidth)
        flowlayout.minimumLineSpacing = 1
        flowlayout.minimumInteritemSpacing = 1
        
        colletView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEMW, height: SCREEMH - TOPHEIGHT) ,collectionViewLayout: flowlayout)
        colletView.backgroundColor = .white
        colletView.delegate = self
        colletView.dataSource = self
        colletView.register(AYPhotoCell.self, forCellWithReuseIdentifier: "AYPhotoPickerCell")
        self.view.addSubview(colletView)
        
        //获取相册照片数组
        assets = PHAsset.fetchAssets(with: .image, options: nil)
    }
    
    @objc func okClick(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        colletView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        colletView.scrollToItem(at: IndexPath(row: assets.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    @objc func cancelClick(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("释放AYPhotoPicker")
    }
}

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
        imageView.backgroundColor = .lightGray
        self.contentView.addSubview(imageView)
        
        selectButton.frame = CGRect(x: frame.size.width - 25, y: 1, width: 25, height: 25)
        selectButton.setBackgroundImage(UIImage(named: "btn_xz_nor"), for: .normal)
        selectButton.setBackgroundImage(UIImage(named: "btn_xz_pre"), for: .selected)
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
        manager.requestImage(for: photo, targetSize: CGSize(width: AYitemWidth, height: AYitemWidth), contentMode: .aspectFill, options: nil) { (image, info) in
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
