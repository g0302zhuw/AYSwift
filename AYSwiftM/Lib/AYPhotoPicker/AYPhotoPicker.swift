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

class AYNavVC: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
}

@objc class AYPhotoPicker: UIViewController {
    
    @objc static func show(_ maxCount:Int,block:((_ imageArray:Array<UIImage>)->Void)?){
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied || status == .restricted {
            AYToast.showBottom("请到设置去允许访问相册权限")
        }else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus == .authorized {
                    DispatchQueue.main.async {
                        let picker = AYAlbumListVC()
                        picker.maxCount = maxCount
                        picker.block = block
                        let nav = AYNavVC(rootViewController: picker)
                        nav.navigationBar.isTranslucent = true
                        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
                    }
                }
            }
        }else{
            let picker = AYAlbumListVC()
            picker.maxCount = maxCount
            picker.block = block
            let nav = AYNavVC(rootViewController: picker)
            nav.navigationBar.isTranslucent = true
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }

    
    var colletView:UICollectionView!
    var okBt = UIButton()

    var block:((_ imageArray:Array<UIImage>)->Void)?
    
    var maxCount = 1
    var assets:PHFetchResult<PHAsset>?
    var selectArray:Array<Int> = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "选择照片"
        self.view.backgroundColor = .white

        okBt.frame = CGRect(x: 0, y: 0, width: 60, height: (self.navigationController?.navigationBar.frame.size.height)!)
        okBt.setTitle("确定", for: .normal)
        okBt.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        okBt.setTitleColor(.white, for: .normal)
        okBt.contentHorizontalAlignment = .right
        okBt.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .disabled)
        okBt.titleLabel?.font = Font(15)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: okBt)
        okBt.isEnabled = false
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: AYitemWidth, height: AYitemWidth)
        flowlayout.minimumLineSpacing = 1
        flowlayout.minimumInteritemSpacing = 1
        
        colletView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEMW, height: SCREEMH) ,collectionViewLayout: flowlayout)
        colletView.backgroundColor = .white
        colletView.delegate = self
        colletView.dataSource = self
        colletView.register(AYPhotoCell.self, forCellWithReuseIdentifier: "AYPhotoPickerCell")
        self.view.addSubview(colletView)
    }
    
    @objc func okClick(){
        if selectArray.count == 0 {
            return;
        }
        
        let manager = PHImageManager.default()

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.version = .current
        
        let group = DispatchGroup()
        
        var imageArray = [UIImage]()
        for i in 0...selectArray.count - 1 {
            group.enter()
            manager.requestImage(for: assets![selectArray[i]], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { (image, info) in
                if image != nil {
                    imageArray.append(image!)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if self.block != nil {
                self.block!(imageArray)
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func reloadSelect(){
        print(selectArray)
        
        colletView.reloadData()
        okBt.setTitle("确定(\(selectArray.count))", for: .normal)
        okBt.isEnabled = (selectArray.count > 0)
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        if assets != nil && assets!.count > 0 {
            colletView.scrollToItem(at: IndexPath(row: assets!.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    @objc func cancelClick(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("释放AYPhotoPicker")
    }
}

extension AYPhotoPicker: UICollectionViewDelegate,UICollectionViewDataSource,AYPhotoCellDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (assets == nil){
            return 0
        }
        return assets!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AYPhotoPickerCell", for: indexPath) as! AYPhotoCell
        cell.delegate = self
        cell.asset = assets![indexPath.row]
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
        vc.nowIndex = indexPath.row
        vc.picker = self
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.present(vc, animated: true) {
        }
    }
}
