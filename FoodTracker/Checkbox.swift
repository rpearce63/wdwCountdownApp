//
//  Checkbox.swift
//  FoodTracker
//
//  Created by Rick on 9/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "cb-on")! as UIImage
    let uncheckedImage = UIImage(named: "cb-off")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        self.isChecked = false
    }
    
}
