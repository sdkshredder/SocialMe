//
//  TableVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/6/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var table: UITableView!
    var editingAge = false
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let a = getTitleForPath(indexPath.section)
        if a == "Age" && editingAge == true {
            return 220
        } else if a == "Location" {
            return 90
        }
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func getTitleForPath(path : Int) -> String {
        switch path {
            case 0:
                return "Name"
            case 1:
                return "Age"
            case 2:
                return "Hometown"
            case 3:
                return "School"
            case 4:
                return "Occupation"
            case 5:
                return "Location"
        default:
                return "Log Out"
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("hideSettings", object: nil)
    }
    
    func getCellID(path : Int) -> String {
        let a = getTitleForPath(path)
        if a == "Age" {
            return "ageCell"
        } else if a == "Location" {
            return "locationCell"
        }
        return "tableCell"
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getTitleForPath(section)
    }
    
    func configureStandardCell(cell: TableTVCell, indexPath: NSIndexPath) {
        cell.textField.placeholder = getTitleForPath(indexPath.section)
        cell.editButton.tag = indexPath.section
        // cell.textField.placeholder = "blah"
        
        let user = PFUser.currentUser()
        let attr = getTitleForPath(indexPath.section)
        
        if let val = user?.objectForKey(attr) as? String {
            cell.textField.placeholder = val 
        }
        /*
        let val = user?.objectForKey(attr) as! String
        
        if !val.isEmpty {
            cell.textField.placeholder = val
        }
        */
        
    }
    
    func configureAgeCell(cell: AgeTVCell) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ID = getCellID(indexPath.section)
        
        if ID == "tableCell" {
            var cell = tableView.dequeueReusableCellWithIdentifier(ID) as! TableTVCell
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
            let title = getTitleForPath(indexPath.section)
            cell.editButton.tag = indexPath.section
            cell.textField.attributedPlaceholder = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName : UIColor.purpleColor()])
            let user = PFUser.currentUser()
            let attr = getTitleForPath(indexPath.section)
            
            if let val = user?.objectForKey(attr) as? String {
                cell.textField.attributedPlaceholder = NSAttributedString(string: val, attributes: [NSForegroundColorAttributeName : UIColor.darkGrayColor()])
            }
            
            /*
            let val = user?.objectForKey(attr) as! String
   
            if !val.isEmpty {
                cell.textField.attributedPlaceholder = NSAttributedString(string: val, attributes: [NSForegroundColorAttributeName : UIColor.darkGrayColor()])
            }
            */
            return cell
        } else if ID == "ageCell" {
            var b = tableView.dequeueReusableCellWithIdentifier(ID) as! AgeTVCell
            return b
        } else {
            var c = tableView.dequeueReusableCellWithIdentifier(ID) as! LocationTVCell
            if (CLLocationManager.authorizationStatus() == .AuthorizedAlways) {
                c.control.selectedSegmentIndex = 0
            } else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
                c.control.selectedSegmentIndex = 1
            } else {
                c.control.selectedSegmentIndex = 2
            }
            return c
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        //table.separatorInset = UIEdgeInsetsZero
        //table.layoutMargins = UIEdgeInsetsZero
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleNotification:", name: "ageNotification", object: nil)
    }
    
    func handleNotification(notification: NSNotification) {
        editingAge = !editingAge
        //println(editingAge)
        table.beginUpdates()
        table.endUpdates()
        NSNotificationCenter.defaultCenter().postNotificationName("pickerNotification", object: nil)
    }
}
