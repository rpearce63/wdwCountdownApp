//
//  VacationTableViewController.swift
//  WDWCountdownApp
//
//  Created by Rick Pearce.
//  Copyright © 2016 Pearce, Rick. All rights reserved.
//

import UIKit
import GoogleMobileAds
import UserNotifications

class VacationTableViewController: UITableViewController {
    // MARK: Properties
     var bannerView: GADBannerView!
    var vacations :[Vacation] = []
    let dateFormatter: DateFormatter = DateFormatter()
    var rowIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addPageBackgroundImage()
        setupAdBar()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved vacations, otherwise load sample data.
        if let savedVacations = loadVacations() {
            
            //remove past vacations
            for vacation: Vacation in savedVacations {
                
                let arrivalDate = vacation.arrivalDate
                let countdown = dateFormatter.calculateDaysUntilArrival(endDate: arrivalDate!)
                if countdown >= 0 {
                    vacations.append(vacation)
                }
            }
            
        }
        if vacations.count == 0 {
            // go to Add New page for initial set up
            performSegue(withIdentifier: "AddItem", sender: Any?.self)
        } else {
            vacations.sort { (v1, v2) -> Bool in
                return v1.arrivalDate < v2.arrivalDate
            }
            
            //updateBadge()
            checkForKeyDates()
        }
        let userDefaults = UserDefaults()
        if userDefaults.value(forKey: "newFeaturesDisplayed") as? String != "done" {
            var newFeaturesMessage = "* Swipe the row left to display the Edit option.\n"
            newFeaturesMessage.append("* Select your own icon and background for each row from your photo gallery.\n")
            newFeaturesMessage.append("* Enter free form notes on the Details view.")
        
            showAlert(title: "New Features", message: newFeaturesMessage)
            userDefaults.set("done", forKey: "newFeaturesDisplayed")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "VacationTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VacationTableViewCell
        
        // Fetches the appropriate vacation for the data source layout.
        let vacation = vacations[(indexPath as NSIndexPath).row]
        //let rowBackgroundImg = vacation.parks ? "wdw-row-background" : "dcl-row-background"
        cell.titleLabel.text = vacation.title
        cell.photoImageView.image = vacation.iconImage ?? setDefaultIcon(parks: vacation.parks)
        cell.backgroundImageView.image = vacation.backgroundImage ?? setDefaultBackground(parks: vacation.parks)
        //cell.photoImageView.image = vacation.photo
        cell.arrivalDateLabel.text = dateFormatter.formatFullDate(dateIn: vacation.arrivalDate)
        cell.countdownLabel.text = "\(dateFormatter.calculateDaysUntilArrival(endDate: vacation.arrivalDate)) days to go!"
                
        return cell
    }
    
    func setDefaultIcon(parks: Bool) -> UIImage {
        return (parks ? UIImage(named:"WDWCastle") : UIImage(named:"dcl-logo"))!
    }
    
    func setDefaultBackground(parks: Bool) -> UIImage {
        return (parks ? UIImage(named:"wdw-row-background") : UIImage(named:"dcl-row-background"))!
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let screenSize: CGRect = UIScreen.main.bounds
//        let screenHeight = screenSize.height
//        return (screenHeight * 0.8) / 4
//    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            vacations.remove(at: (indexPath as NSIndexPath).row)
            saveVacations()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") {(action, indexPath) in
            self.performSegue(withIdentifier: "EditRow", sender: tableView.cellForRow(at: indexPath))
        }
        edit.backgroundColor = .orange
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete" ) { (action, indexPath) in
            self.vacations.remove(at: (indexPath as NSIndexPath).row)
            self.saveVacations()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        delete.backgroundColor = .red
        return [delete, edit]
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            let vacationDetailViewController = segue.destination as! VacationDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedVacationCell = sender as? VacationTableViewCell {
                let indexPath = tableView.indexPath(for: selectedVacationCell)!
                let selectedVacation = vacations[(indexPath as NSIndexPath).row]
                vacationDetailViewController.vacation = selectedVacation
                vacationDetailViewController.rowIndex = indexPath.row
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new vacation.")
        } else if segue.identifier == "EditRow" {
            if let selectedCell = sender as? VacationTableViewCell {
                rowIndex = tableView.indexPath(for: selectedCell)
                let backgroundPhoto = selectedCell.backgroundImageView.image
                let getPhotoViewController = segue.destination as! GetPhotoViewController
                getPhotoViewController.backgroundImage = backgroundPhoto
                getPhotoViewController.iconImage = selectedCell.photoImageView.image
                getPhotoViewController.isParks = vacations[((rowIndex)?.row)!].parks
            }
        }
        
    }
    

    @IBAction func unwindToVacationList(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? VacationViewController, let vacation = sourceViewController.vacation {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing vacation.
                vacations[(selectedIndexPath as NSIndexPath).row] = vacation
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new vacation.
                let newIndexPath = IndexPath(row: vacations.count, section: 0)
                vacations.append(vacation)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            // Sort the rows by date
            vacations.sort { (v1, v2) -> Bool in
                return v1.arrivalDate < v2.arrivalDate
            }
            tableView.reloadData()
           
            // Save the vacations.
            saveVacations()
            updateWidget(vacations: vacations)
        }
        if let sourceViewController = sender.source as? GetPhotoViewController {
            let selectedRow = tableView.cellForRow(at: rowIndex!) as! VacationTableViewCell
            let rowData = vacations[(rowIndex?.row)!]
            rowData.iconImage = sourceViewController.iconImage
            rowData.backgroundImage = sourceViewController.backgroundImage
            //tableView.reloadRows(at: [rowIndex!], with: .none)
            selectedRow.photoImageView.image = sourceViewController.iconImage
            selectedRow.backgroundImageView.image = sourceViewController.backgroundImage
            saveVacations()

        }
    }
    
    
    // MARK: NSCoding
    
    func saveVacations() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(vacations, toFile: Vacation.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save vacations...")
        }
    }
    
    func loadVacations() -> [Vacation]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Vacation.ArchiveURL.path) as? [Vacation]
    }
    
    func checkForKeyDates() {
        var message : String = ""
        for vacation: Vacation in vacations {
            let arrivalDate = vacation.arrivalDate
            let countdown = dateFormatter.calculateDaysUntilArrival(endDate: arrivalDate!)
            if 0 ... 7 ~= countdown {
                message.append("Arrival Date is only \(countdown) days away for \(vacation.title)\n")
            } else {
                if vacation.parks == true {
                    let adrDays = dateFormatter.calculateDaysUntilArrival(endDate: dateFormatter.calculateKeyDate(fromDate: arrivalDate!, dayCount: -180))
                    if 0 ... 7 ~= adrDays {
                        message.append("Make dining reservations in \(adrDays) days for \(vacation.title)\n")
                    }
                    let fpDays = dateFormatter.calculateDaysUntilArrival(endDate: dateFormatter.calculateKeyDate(fromDate: arrivalDate!, dayCount: vacation.onProperty ? -60 : -30))
                    if 0 ... 7 ~= fpDays {
                        message.append("Make FastPass reservations in \(fpDays) days for \(vacation.title)\n")
                    }
                }
            }
        }
        if !message.isEmpty {
            showAlert(title: "Key Dates Coming Up", message: message)
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updateWidget(vacations: [Vacation]) {
            
           let userDefaults = UserDefaults(suiteName: "group.com.pearce.wdwCountdownTimer")
                userDefaults?.set(vacations[0].arrivalDate, forKey: "arrivalDate")
                userDefaults?.set(vacations[0].title, forKey: "title")
                userDefaults?.synchronize()
     }
    
    func setupAdBar() {
        self.navigationController!.isToolbarHidden = false
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.navigationController?.toolbar.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-5535985233243357/2100500420"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "95194d67850f2724e5c5bf840fb7b33d" ]
        bannerView.load(request)
    }
    
    func addPageBackgroundImage() {
        let background = UIImage(named: "LaunchScreenImage")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        imageView.alpha = 0.5
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
    }
}
