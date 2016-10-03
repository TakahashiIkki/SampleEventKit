//
//  ViewController.swift
//  SampleEventKit
//  
//  Refer: https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/eventkit/karendawo-qu-desuru
//
//  Created by 一騎高橋 on 2016/10/04.
//  Copyright © 2016年 IkkiTakahashi. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    var myEventStore: EKEventStore!
    var myEvents: NSArray!
    var myTargetCalendar: EKCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // EventStoreを生成する.
        myEventStore = EKEventStore()
        
        // ユーザーにカレンダーの使用の許可を求める.
        allowAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     認証ステータスを取得.
     */
    func getAuthorizationStatus() -> Bool {
        
        // ステータスを取得.
        let status = EKEventStore.authorizationStatus(for: .event)
        
        // ステータスを表示 許可されている場合のみtrueを返す.
        switch status {
        case .notDetermined:
            print("NotDetermined")
            return false
            
        case .denied:
            print("Denied")
            return false
            
        case .authorized:
            print("Authorized")
            return true
            
        case .restricted:
            print("Restricted")
            return false
        }
    }

    /*
     認証許可.
     */
    func allowAuthorization() {
        
        // 許可されていなかった場合、認証許可を求める.
        if getAuthorizationStatus() {
            return
        } else {
            // ユーザーに許可を求める.
            myEventStore.requestAccess(to: .event) { (granted , error) -> Void in
                
                // 許可を得られなかった場合アラート発動.
                if granted {
                    return
                } else {
                    
                    // メインスレッド 画面制御. 非同期.
                    DispatchQueue.main.async(){ () -> Void in
                        
                        // アラート生成.
                        let myAlert = UIAlertController(title: "権限許可なし", message: "カレンダー情報の取得は許可されていません", preferredStyle: .alert)
                        
                        // アラートアクション.
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEvents" {
            // NSCalendarを生成.
            let myCalendar = NSCalendar.current
            
            // 開始日(昨日)コンポーネントの生成.
            let oneDayAgoComponents: NSDateComponents = NSDateComponents()
            oneDayAgoComponents.day = -1
            
            // 昨日から今日までのNSDateを生成.
            let oneDayAgo = myCalendar.date(byAdding: oneDayAgoComponents as DateComponents,
                                            to: Date())
            
            // 終了日(一年後)コンポーネントの生成.
            let oneYearFromNowComponents: NSDateComponents = NSDateComponents()
            oneYearFromNowComponents.year = 1
            
            // 今日から一年後までのNSDateを生成.
            let oneYearFromNow = myCalendar.date(byAdding: oneYearFromNowComponents as DateComponents,
                                                 to: Date())
            
            // イベントストアのインスタンスメソッドで述語を生成.
            var predicate = NSPredicate()
            
            // ユーザーの全てのカレンダーからフェッチする.
            predicate = myEventStore.predicateForEvents(withStart: oneDayAgo!,
                                                        end: oneYearFromNow!,
                                                        calendars: nil)
            
            // 述語にマッチする全てのイベントをフェッチ.
            let events = myEventStore.events(matching: predicate)
            
            // 発見したイベントを格納する配列を生成.
            var eventItems = [String]()
            
            if !events.isEmpty {
                for i in events{
                    // 配列に格納.
                    eventItems += ["\(i.title): \(i.startDate)"]
                }
            }

            let myTableViewController = (segue.destination as? TableViewController)!
            
            // TableViewに表示する内容として発見したイベントを入れた配列を渡す.
            myTableViewController.myItems = events as NSArray
        }
    }
}

