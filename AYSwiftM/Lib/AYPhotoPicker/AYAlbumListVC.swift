//
//  AYPhotoListVC.swift
//  AYSwiftM
//
//  Created by zw on 2019/8/2.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit
import Photos

class AYAlbumListVC: UIViewController {

    var table:UITableView!
    
    var maxCount = 1
    var block:((_ imageArray:Array<UIImage>)->Void)?
    
    var albumArray = [PHAssetCollection]()
    var countArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "相册"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelClick))
        
        let defaultIndex = self.getAblums()
        
        table = UITableView(frame: self.view.bounds)
        table.delegate = self
        table.dataSource = self
        table.register(AYAlbumCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(table)
        table.tableFooterView = UIView()
        
        //自动跳转
        let collection:PHAssetCollection = albumArray[defaultIndex];
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]//时间排序
        options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)//只选照片
        let picker = AYPhotoPicker()
        picker.assets = PHAsset.fetchAssets(in: collection, options: options)
        picker.maxCount = maxCount
        picker.block = block
        self.navigationController?.pushViewController(picker, animated: false)
    }
    
    //获取相册数据
    func getAblums() -> Int{
        var defaultIndex = 0
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,subtype: .albumRegular,options: nil)//列出所有系统的智能相册
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album,subtype: .albumRegular,options: nil)//列出所有用户创建的相册
        
        //筛选条件
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]//时间排序
        options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)//只选照片
        
        for i in 0..<smartAlbums.count {
            let collection:PHAssetCollection = smartAlbums[i];
            if collection.estimatedAssetCount > 0 && collection.localizedTitle != nil {
                let fetchResult:PHFetchResult = PHAsset.fetchAssets(in: collection, options: options)
                if fetchResult.count > 0 {
                    albumArray.append(collection)
                    countArray.append(fetchResult.count)
                    
                    //默认需要跳转到的相册页面
                    if collection.localizedTitle! == "相机胶卷" {
                        defaultIndex = albumArray.count - 1
                    }
                }
            }
        }
        
        for i in 0..<userAlbums.count {
            let collection:PHAssetCollection = userAlbums[i];
            if collection.estimatedAssetCount > 0 && collection.localizedTitle != nil {
                let fetchResult:PHFetchResult = PHAsset.fetchAssets(in: collection, options: options)
                if fetchResult.count > 0 {
                    albumArray.append(collection)
                    countArray.append(fetchResult.count)
                }
            }
        }
        return defaultIndex
    }
    
    @objc func cancelClick(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("释放AYAlbumListVC")
    }
}

extension AYAlbumListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier:"cell" , for: indexPath) as! AYAlbumCell
        
        let collection:PHAssetCollection = albumArray[indexPath.row];
        
        //相册封面 但是图片可能被删了，有点坑
        let assets:PHFetchResult<PHAsset>? = PHAsset.fetchKeyAssets(in: collection, options: nil)
        if assets != nil && assets!.count > 0 {
            let photo:PHAsset = assets!.firstObject!
            let manager = PHImageManager.default()
            manager.requestImage(for: photo, targetSize: CGSize(width: 160, height: 160), contentMode: .aspectFit, options: nil) { (image, info) in
                cell.imageV.image = image
            }
        }
        cell.titLbl.text = collection.localizedTitle! + " " + (countArray[indexPath.row].description)
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let collection:PHAssetCollection = albumArray[indexPath.row];
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]//时间排序
        options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)//只选照片
        
        let picker = AYPhotoPicker()
        picker.assets = PHAsset.fetchAssets(in: collection, options: options)
        picker.maxCount = maxCount
        picker.block = block
        self.navigationController?.pushViewController(picker, animated: true)
    }
}


class AYAlbumCell:UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.imageV)
        self.contentView.addSubview(self.titLbl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageV.frame = CGRect(x: 10, y: 10, width: 80, height: 80)
        self.titLbl.frame = CGRect(x: self.imageV.maxX + 10, y: 0, width: self.contentView.frame.width - self.imageV.maxX - 20, height: self.contentView.frame.height)
    }
    
    lazy var imageV: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        return imgV
    }()
    
    lazy var titLbl:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textColor = .black
        return lbl
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
