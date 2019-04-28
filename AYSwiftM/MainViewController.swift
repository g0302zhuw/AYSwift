//
//  MainViewController.swift
//  AYSwiftM
//
//  Created by zw on 2019/4/19.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let AYArray = ["AYToast","AYAlert","AYActionSheet","AYPicker","AYProgressHUD"]
    
    var table:UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AYArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = AYArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ayfunction = AYArray[indexPath.row]
        switch ayfunction {
        case "AYToast":
            AYToast.showBottom("AYToast")
            break
            
        case "AYAlert":
            AYAlert.show(title: "提示", message: "弹出alert", cancle: "取消", okBtn: "确定") { (index) in
                print("点击了" + index.description)
            }
            break
            
        case "AYActionSheet":
            AYActionSheet.show(["AYToast","AYAlert","取消"]) { (index) in
                if index == 0 {
                    AYToast.showCenter("AYToast")
                }else if index == 1 {
                    AYAlert.show(title: "提示", message: "弹出alert", okBtn: "确定") { (index) in
                    }
                }
            }
            break
        
        case "AYPicker":
            AYPicker.show(array: ["0","1","2","3","4","5"], index: 2) { (index) in
                print("点击了" + index.description)

            }
            break
            
        case "AYProgressHUD":
            AYProgressHUD.show("加载中...")

            self.perform(#selector(show2), with: nil, afterDelay: 1)
            self.perform(#selector(dimssHUD), with: nil, afterDelay: 2)
            break
            
        default:
            break
        }
    }
    
    @objc func show2(){
        AYProgressHUD.show("加载中2...")
    }
    
    @objc func dimssHUD(){
        AYProgressHUD.dimMiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "AYSwiftM"
        
        table = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView(frame: CGRect.zero)
        self.view.addSubview(table)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
