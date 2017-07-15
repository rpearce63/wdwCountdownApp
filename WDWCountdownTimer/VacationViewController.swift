//
//  VacationViewController.swift
//  WDWCountdownApp
//
//  Created by Rick Pearce.
//  Copyright © 2016 Rick Pearce. All rights reserved.

//

import UIKit



class VacationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var parksSwitch: UISwitch!
    @IBOutlet weak var cruiseSwitch: UISwitch!
    @IBOutlet weak var ccLevelView: UIView!
    @IBOutlet weak var ccLevelPicker: UIPickerView!
    @IBOutlet weak var tripTypeSwitch: UISegmentedControl!
   
    /*
        This value is either passed by `VacationTableViewController` in `prepareForSegue(_:sender:)`
        or constructed as part of adding a new meal.
    */
    var vacation: Vacation?
    var parksChecked: Bool = false
    var cruiseChecked: Bool = false
    
   
    
    //var radioButtonController: SSRadioButtonsController?
    
    let ccLevelPickerData: [String] = ["First Cruise", "Silver", "Gold", "Platinum", "Concierge"]
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ccLevelPicker.delegate = self
        self.ccLevelPicker.dataSource = self
        
        //radioButtonController = SSRadioButtonsController(buttons: button1, button2, button3)
        //radioButtonController?.delegate = self
        //radioButtonController!.shouldLetDeSelect = true
        
        
        dateFormatter.dateStyle = .full
        // Handle the text field’s user input through delegate callbacks.
        titleTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let vacation = vacation {
            navigationItem.title = vacation.title
            titleTextField.text   = vacation.title
            //photoImageView.image = vacation.photo
            arrivalDateLabel.text = dateFormatter.formatFullDate(dateIn: vacation.arrivalDate)
            datePicker.date = vacation.arrivalDate
            tripTypeSwitch.selectedSegmentIndex = vacation.parks ? 0 : 1
//            parksSwitch.isOn = vacation.parks
//            cruiseSwitch.isOn = vacation.cruise
            ccLevelView.isHidden = tripTypeSwitch.selectedSegmentIndex == 0
            ccLevelPicker.selectRow(ccLevelPickerData.index(of: vacation.ccLevel)!, inComponent: 0, animated: false)
        } else {
            arrivalDateLabel.text = dateFormatter.formatFullDate(dateIn: Date())
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidVacationName()
        titleTextField.becomeFirstResponder()
    }
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ccLevelPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ccLevelPickerData[row]
    }

//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        vacation?.ccLevel = ccLevelPickerData[row]
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidVacationName()
        navigationItem.title = textField.text
        textField.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func checkValidVacationName() {
        // Disable the Save button if the text field is empty.
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddVacationMode = presentingViewController is UINavigationController
        
        if isPresentingInAddVacationMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if saveButton === sender as! UIBarButtonItem {
            let title = titleTextField.text ?? ""
            let photo = setPhoto()
            //let rating = ratingControl.rating
            let arrivalDate = datePicker.date
            let parksBool = tripTypeSwitch.selectedSegmentIndex == 0
            let cruiseBool = tripTypeSwitch.selectedSegmentIndex == 1
            let ccLevel = ccLevelPickerData[ccLevelPicker.selectedRow(inComponent: 0)]
            
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            vacation = Vacation(title: title, photo: photo, arrivalDate: arrivalDate, parks: parksBool, cruise: cruiseBool, ccLevel: ccLevel, notes: [])
        }
    }
    
    func setPhoto() -> UIImage {
        if tripTypeSwitch.selectedSegmentIndex == 1 {
            return UIImage(named: "dclship")!
        } else {
            return UIImage(named: "wdwcastle-1")!
        }
    }
    
    // MARK: Actions
    
    @IBAction func dateChanged(_ sender: AnyObject) {
        titleTextField.resignFirstResponder()
        arrivalDateLabel.text = dateFormatter.string(from: datePicker.date) 
    }
    
    
//    @IBAction func cruiseSwitchChanged(_ sender: UISwitch) {
//        ccLevelView.isHidden = !sender.isOn
//        parksSwitch.isOn = !sender.isOn
//    }
//    
//    @IBAction func parkSwitchChanged(_ sender: UISwitch) {
//        cruiseSwitch.isOn = !sender.isOn
//        ccLevelView.isHidden = sender.isOn
//    }
    
    @IBAction func tripTypeSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                ccLevelView.isHidden = true
            case 1:
                ccLevelView.isHidden = false
            default:
                break;
        }
    }
        
}
