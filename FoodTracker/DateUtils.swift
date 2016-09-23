//
//  DateUtils.swift
//  FoodTracker
//
//  Created by Rick on 9/19/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

extension DateFormatter {
    
    
    private func getDateFormatter(style : DateFormatter.Style) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter
    }
    
    
    func formatFullDate(dateIn : Date ) -> String {
            return getDateFormatter(style: .full).string(from: dateIn)
    }
    
    func calculateDaysUntilArrival(endDate: Date) -> Int {
        
        // Assuming that firstDate and secondDate are defined
        // ...
        
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        
        let flags = NSCalendar.Unit.day
        let components = calendar.components(flags, from: Date(), to: endDate, options: [])
        
        return components.day! + 1 // This will return the number of day(s) between dates
        
    }
    
    func calculateKeyDate(fromDate: Date, dayCount: Int) -> Date {
        
        let calculatedDate = NSCalendar.current.date(byAdding: .day, value: dayCount, to: fromDate)
        
        return calculatedDate!
    }
    
    func calculateADRDate(arrivalDate: Date) -> String{
        return getDateFormatter(style: .medium).string(from:  calculateKeyDate(fromDate: arrivalDate, dayCount: -180))
    }
    
    func calculateFPDate(arrivalDate: Date) -> String {
         return getDateFormatter(style: .medium).string(from:  calculateKeyDate(fromDate: arrivalDate, dayCount: -60))
    }
    
    func calculateCruiseCheckinDate(sailDate: Date, ccLevel: String) -> String {
        return getDateFormatter(style: .medium).string(from:   calculateKeyDate(fromDate: sailDate, dayCount: getCCLeveCount(ccLevel: ccLevel)))
    }
    
    func getCCLeveCount(ccLevel: String) -> Int {
        if ccLevel.isEmpty {
            return -75
        }
        
        let dictionary: [String:Int] = [
            "First Cruise" : -75,
            "Silver" : -90,
            "Gold" : -105,
            "Platinum" : -120,
            "Concierge" : -120
        ]
        return dictionary[ccLevel]!
        
    }
}
