//
//  VacationDetailViewController.swift
//  DisneyCountdownApp
//
//  Created by Rick on 9/19/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class VacationDetailViewController: UIViewController {

    // MARK: outlets
    
    @IBOutlet weak var vacationNameLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var adrDateLabel: UILabel!
    @IBOutlet weak var fpDateLabel: UILabel!
    @IBOutlet weak var cruiseCheckin: UILabel!
    @IBOutlet weak var parksView: UIView!
    
    @IBOutlet weak var tripPhoto: UIImageView!
    @IBOutlet weak var cruiseView: UIView!
    
    var vacation: Vacation?
    let dateFormatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let vacation = vacation {
            vacationNameLabel.text = vacation.title
            countdownLabel.text = "\(dateFormatter.calculateDaysUntilArrival(endDate: vacation.arrivalDate)) days to go!"
            arrivalDateLabel.text = "\(dateFormatter.formatFullDate(dateIn: vacation.arrivalDate))"
            if vacation.parks == true {
                adrDateLabel.text = "\(dateFormatter.calculateADRDate(arrivalDate: vacation.arrivalDate))"
                fpDateLabel.text = "\(dateFormatter.calculateFPDate(arrivalDate: vacation.arrivalDate))"
                parksView.isHidden = false
            }
            if vacation.cruise == true {
                cruiseCheckin.text = "\(dateFormatter.calculateCruiseCheckinDate(sailDate: vacation.arrivalDate, ccLevel: vacation.ccLevel))"
                cruiseView.isHidden = false
            }
            tripPhoto.image = vacation.photo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditVacation" {
            let destinationController = segue.destination as! VacationViewController
            destinationController.vacation = self.vacation
        }
    }
    

}
