//
//  VacationTableViewCell.swift
//  WDWCountdownApp
//
//  Created by Rick Pearce
//  Copyright © 2016 Rick Pearce. All rights reserved.

//

import UIKit

class VacationTableViewCell: UITableViewCell {
    // MARK: Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
