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
    //@IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //@IBOutlet weak var datePicker: UIDatePicker!
    //@IBOutlet weak var parksSwitch: UISwitch!
    //@IBOutlet weak var cruiseSwitch: UISwitch!
    @IBOutlet weak var ccLevelView: UIView!
    //@IBOutlet weak var ccLevelPicker: UIPickerView!
    @IBOutlet weak var tripTypeSwitch: UISegmentedControl!
    @IBOutlet weak var ccLevelTextField: UITextField!
    @IBOutlet weak var arrivalDateTextField: UITextField!
    @IBOutlet weak var parksDetail: UIView!
    @IBOutlet weak var resortTextField: UITextField!
    @IBOutlet weak var resvTextField: UITextField!
    @IBOutlet weak var onPropertySwitch: UISwitch!
   
    /*
        This value is either passed by `VacationTableViewController` in `prepareForSegue(_:sender:)`
        or constructed as part of adding a new vaccation.
    */
    var vacation: Vacation?
    var parksChecked: Bool = false
    var cruiseChecked: Bool = false
    
   
    
    //var radioButtonController: SSRadioButtonsController?
    
    let ccLevelPickerData: [String] = ["First Cruise", "Silver", "Gold", "Platinum", "Concierge"]
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        let ccLevelPicker = UIPickerView()
        ccLevelPicker.delegate = self
        //ccLevelPicker.dataSource = self
        ccLevelTextField.inputView = ccLevelPicker
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        arrivalDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(VacationViewController.dateChanged), for: .valueChanged)
        arrivalDateTextField.inputAccessoryView = UIToolbar().getToolBar(mySelect: #selector(VacationViewController.dismissPicker))
        
        
        dateFormatter.dateStyle = .full
        // Handle the text field’s user input through delegate callbacks.
        titleTextField.delegate = self
        
        // Set up views if editing an existing Vacation.
        if let vacation = vacation {
            navigationItem.title = vacation.title
            titleTextField.text   = vacation.title
            //photoImageView.image = vacation.photo
            //arrivalDateLabel.text = dateFormatter.formatFullDate(dateIn: vacation.arrivalDate)
            arrivalDateTextField.text = dateFormatter.string(from: vacation.arrivalDate)
            tripTypeSwitch.selectedSegmentIndex = vacation.parks ? 0 : 1
//            parksSwitch.isOn = vacation.parks
//            cruiseSwitch.isOn = vacation.cruise
            ccLevelView.isHidden = tripTypeSwitch.selectedSegmentIndex == 0
            parksDetail.isHidden = tripTypeSwitch.selectedSegmentIndex == 1
            ccLevelTextField.text = vacation.ccLevel
            //ccLevelPicker.selectRow(ccLevelPickerData.index(of: vacation.ccLevel)!, inComponent: 0, animated: false)
            resortTextField.text = vacation.resort
            resvTextField.text = vacation.resv
            onPropertySwitch.isOn = vacation.onProperty
        } else {
            arrivalDateTextField.text = dateFormatter.formatFullDate(dateIn: Date())
        }
        
        // Enable the Save button only if the text field has a valid Vacation name.
        checkValidVacationName()
        titleTextField.becomeFirstResponder()
        datePicker.date = dateFormatter.date (from: arrivalDateTextField.text!)!
        let selectedCCLevel = (ccLevelTextField.text?.isEmpty)! ? "First Cruise" : ccLevelTextField.text
        ccLevelPicker.selectRow((ccLevelPickerData.index(of: selectedCCLevel!))!, inComponent: 0, animated: true)
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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ccLevelTextField.text = ccLevelPickerData[row]
        self.view.endEditing(false)
    }
    
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
            let arrivalDate = dateFormatter.date (from: arrivalDateTextField.text!)
            let parksBool = tripTypeSwitch.selectedSegmentIndex == 0
            let cruiseBool = tripTypeSwitch.selectedSegmentIndex == 1
            let ccLevel = ccLevelTextField.text
            let resort = resortTextField.text
            let resv = resvTextField.text
            let onProperty = onPropertySwitch.isOn
            
            // Set the vacation to be passed to VacationTableViewController after the unwind segue.
            vacation = Vacation(title: title, photo: photo, arrivalDate: arrivalDate, parks: parksBool, cruise: cruiseBool,
                                ccLevel: ccLevel!, resort: resort!, resv: resv!, onProperty: onProperty)
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
    
    func dateChanged(_ sender: UIDatePicker) {
        titleTextField.resignFirstResponder()
        arrivalDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func dismissPicker(){
        self.view.endEditing(false)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissPicker()
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
                parksDetail.isHidden = false
            case 1:
                ccLevelView.isHidden = false
                parksDetail.isHidden = true
            default:
                break;
        }
        dismissPicker()
    }
        
}
