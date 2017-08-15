//
//  VacationDetailViewController.swift
//  WDWCountdownApp
//
//  Created by Rick on 9/19/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class VacationDetailViewController: UIViewController {

    // MARK: outlets
    @IBOutlet var notesTableView: UITableView!
    
    @IBOutlet weak var vacationNameLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var adrDateLabel: UILabel!
    @IBOutlet weak var fpDateLabel: UILabel!
    @IBOutlet weak var cruiseCheckin: UILabel!
    @IBOutlet weak var parksView: UIView!
    
    //@IBOutlet weak var tripPhoto: UIImageView!
    @IBOutlet weak var cruiseView: UIView!
    @IBOutlet weak var reservation: UILabel!
    @IBOutlet weak var resort: UILabel!
    @IBOutlet weak var resvStack: UIStackView!
    @IBOutlet weak var resortStack: UIStackView!
    @IBOutlet weak var notesTextView: UITextView!
    
    var vacation: Vacation?
    var rowIndex: Int?
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
                fpDateLabel.text = "\(dateFormatter.calculateFPDate(arrivalDate: vacation.arrivalDate, onProperty: vacation.onProperty))"
                parksView.isHidden = false
                resort.text = vacation.resort
                resortStack.isHidden = (vacation.resort?.isEmpty)!
            }
            if vacation.cruise == true {
                cruiseCheckin.text = "\(dateFormatter.calculateCruiseCheckinDate(sailDate: vacation.arrivalDate, ccLevel: vacation.ccLevel))"
                cruiseView.isHidden = false
            }
            reservation.text = vacation.resv
            resvStack.isHidden = (vacation.resv?.isEmpty)!
            notesTextView.text = vacation.notes
            //tripPhoto.image = vacation.photo
            //reservation.layer.borderColor = UIColor.black.cgColor
            //reservation.layer.borderWidth = 1.0
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        vacation?.notes = notesTextView.text
        var vacations: [Vacation] = loadVacations()!
        vacations[rowIndex!] = vacation!
        saveVacations(vacations: vacations)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func saveVacations(vacations: [Vacation]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(vacations, toFile: Vacation.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save vacations...")
        }
    }
    
    func loadVacations() -> [Vacation]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Vacation.ArchiveURL.path) as? [Vacation]
    }

}
