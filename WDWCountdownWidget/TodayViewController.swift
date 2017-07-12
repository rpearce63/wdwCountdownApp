//
//  TodayViewController.swift
//  WDWCountdownWidget
//
//  Created by Rick on 7/9/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var countdownLabel: UILabel!
    
    //@IBOutlet var keyDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        if let defaults = UserDefaults(suiteName: "group.com.pearce.wdwCountdownTimer") {
            defaults.synchronize()
            let arrivalDate = defaults.object(forKey: "arrivalDate") as! Date
            let title = defaults.string(forKey: "title")
            countdownLabel.text = "Only \(daysUntil(endDate: arrivalDate)) days until \(title ?? "Your next vacation")"
        } else {
            countdownLabel.text = "Time to book a vacation!"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openApp(_ sender: Any) {
        
        let url: URL? = URL(string: "wdwCountdown:")!
        
        if let appurl = url {
            self.extensionContext!.open(appurl,
                                        completionHandler: nil)
        }
        
    }
    
    func daysUntil(endDate: Date) -> Int {
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if today.compare(endDate) == .orderedDescending {
            return -1
        }
        let diff = calendar.dateComponents([.day], from: today, to: endDate)
        
        //print(diff.day!)
        return diff.day! // This will return the number of day(s) between dates
        
    }
    
//    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        // Perform any setup necessary in order to update the view.
//        
//        // If an error is encountered, use NCUpdateResult.Failed
//        // If there's no update required, use NCUpdateResult.NoData
//        // If there's an update, use NCUpdateResult.NewData
//        
//        if let vacationCountdown = UserDefaults(suiteName: "group.com.pearce.wdwCountdownTimer")?.string(forKey: "vacationCountdown") {
//                if vacationCountdown != countdownLabel.text {
//                    countdownLabel.text = vacationCountdown
//                    completionHandler(NCUpdateResult.newData)
//                } else {
//                    completionHandler(NCUpdateResult.noData)
//            }
//        } else {
//            countdownLabel.text = "Time to book a WDW trip."
//            completionHandler(NCUpdateResult.newData)
//        }
//        
//    }
    
}
