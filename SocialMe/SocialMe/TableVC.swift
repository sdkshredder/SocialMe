//
//  TableVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/6/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62
        
        //selected.containsObject(indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func getTitleForPath(indexPath: NSIndexPath) -> String {
        var res = ""
        switch indexPath.row {
            case 0:
                res = "Name"
            case 1:
                res = "Age"
            case 2:
                res = "Hometown"
            case 3:
                res = "School"
            case 4:
                res = "Occupation"
        default:
                res = "hello"
        }
        return res
    }
    
    func getCurrentUserAttributes() {
        /*
        var user = PFUser.currentUser()
        user!.setObject(geoPoint, forKey: "location")
        
        user!.saveInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                println("success for user \(user!.username)")
            }
        }

        */
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! TableTVCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        
        cell.title.text = getTitleForPath(indexPath)
        cell.textField.placeholder = getTitleForPath(indexPath)
        cell.title.tag = indexPath.row
        
        let attr = getTitleForPath(indexPath)
        
        let user = PFUser.currentUser()
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsetsZero
        table.layoutMargins = UIEdgeInsetsZero
    }
}
