//
//  TableViewController.swift
//  SampleEventKit
//
//  Refer: https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/eventkit/karendawo-qu-desuru
//
//  Created by 一騎高橋 on 2016/10/04.
//  Copyright © 2016年 IkkiTakahashi. All rights reserved.
//

import UIKit
import EventKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Tableで使用する配列を設定する
    var myItems: NSArray = []
    @IBOutlet weak var MyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myItems[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) 
        
        let event: EKEvent = myItems[indexPath.row] as! EKEvent
        cell.textLabel!.text = "\(event.startDate) \(event.title)"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
