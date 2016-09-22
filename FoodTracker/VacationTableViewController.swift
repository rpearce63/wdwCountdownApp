//
//  VacationTableViewController.swift
//  FoodTracker
//
//  Created by Rick Pearce.
//  Copyright © 2016 Pearce, Rick. All rights reserved.
//

import UIKit


class VacationTableViewController: UITableViewController {
    // MARK: Properties
    
    var vacations = [Vacation]()
    let dateFormatter: DateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved vacations, otherwise load sample data.
        if let savedVacations = loadVacations() {
            vacations += savedVacations
        }
        //else {
            // Load the sample data.
            //loadSampleVacations()
        //}
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
        
        cell.titleLabel.text = vacation.title
        cell.photoImageView.image = vacation.photo
        cell.arrivalDateLabel.text = dateFormatter.formatFullDate(dateIn: vacation.arrivalDate)
        cell.countdownLabel.text = "\(dateFormatter.calculateDaysUntilArrival(endDate: vacation.arrivalDate)) days to go!"
                
        return cell
    }

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


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new vacation.")
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
            // Save the vacations.
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
    
    
}
