//
//  Vacation.swift
//  WDWCountdownApp
//
//  Created by Rick on 9/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class Vacation: NSObject, NSCoding {
    // MARK: Properties
    
    var title: String
    var photo: UIImage?
    var arrivalDate: Date!
    var parks: Bool
    var cruise: Bool
    var ccLevel: String
    var resort: String?
    var resv: String?
    var onProperty: Bool
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("vacations")
    
    // MARK: Types
    
    struct PropertyKey {
        static let titleKey = "title"
        static let photoKey = "photo"
        static let arrivalDateKey = "arrival"
        static let parksKey = "parks"
        static let cruiseKey = "cruise"
        static let ccLevelKey = "ccLevel"
        static let resortKey = "resort"
        static let resvKey = "resv"
        static let onPropertyKey = "onProperty"
    }
    
    // MARK: Initialization
    
    init?(title: String, photo: UIImage?, arrivalDate: Date?, parks: Bool, cruise: Bool, ccLevel: String, resort: String, resv: String, onProperty: Bool) {
        // Initialize stored properties.
       self.title = title
        self.photo = photo
        self.arrivalDate = arrivalDate!
        self.parks = parks
        self.cruise = cruise
        self.ccLevel = ccLevel
        self.resort = resort
        self.resv = resv
        self.onProperty = onProperty
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if title.isEmpty || arrivalDate == nil {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.titleKey)
        aCoder.encode(photo, forKey: PropertyKey.photoKey)
        aCoder.encode(arrivalDate, forKey: PropertyKey.arrivalDateKey)
        aCoder.encode(parks, forKey: PropertyKey.parksKey)
        aCoder.encode(cruise, forKey: PropertyKey.cruiseKey)
        aCoder.encode(ccLevel, forKey: PropertyKey.ccLevelKey)
        aCoder.encode(resort, forKey: PropertyKey.resortKey)
        aCoder.encode(resv, forKey: PropertyKey.resvKey)
        aCoder.encode(onProperty, forKey: PropertyKey.onPropertyKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let title = aDecoder.decodeObject(forKey: PropertyKey.titleKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photoKey) as? UIImage
        
        let arrivalDate = aDecoder.decodeObject(forKey: PropertyKey.arrivalDateKey) as! Date
        let parks = aDecoder.decodeBool(forKey: PropertyKey.parksKey)
        let cruise = aDecoder.decodeBool(forKey: PropertyKey.cruiseKey)
        let ccLevel = aDecoder.decodeObject(forKey: PropertyKey.ccLevelKey) as! String
        let resort = aDecoder.decodeObject(forKey: PropertyKey.resortKey) as? String ?? ""
        let resv = aDecoder.decodeObject(forKey: PropertyKey.resvKey) as? String  ?? ""
        let onProperty = aDecoder.decodeBool(forKey: PropertyKey.onPropertyKey)
                      // Must call designated initializer.
        self.init(title: title, photo: photo, arrivalDate: arrivalDate, parks: parks, cruise: cruise, ccLevel: ccLevel, resort: resort, resv: resv, onProperty: onProperty)
    }
}
