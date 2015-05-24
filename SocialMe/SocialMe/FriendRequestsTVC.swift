//
//  FriendRequestsTVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/23/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse


class FriendRequestsTVC: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell") as! FriendRequectTVCell
        
        cell.acceptButton.layer.cornerRadius = 4
        cell.acceptButton.layer.borderWidth = 1
        cell.acceptButton.layer.borderColor = UIColor.greenColor().CGColor
        
        cell.rejectButton.layer.cornerRadius = 4
        cell.rejectButton.layer.borderWidth = 1
        cell.rejectButton.layer.borderColor = UIColor.redColor().CGColor
        
        cell.blockButton.layer.cornerRadius = 4
        cell.blockButton.layer.borderWidth = 1
        cell.blockButton.layer.borderColor = UIColor.blackColor().CGColor
        cell.profilePicture.tag = indexPath.row
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"showProfile:", name: "showUserProfile", object: nil)
    }

    func showProfile(notification: NSNotification) {
        let info = notification.userInfo as! [String : Int]
        let index = info["index"]
        println("index")
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("profileVC") as! ProfileVC
        
        // Get correct user from index and set username appropriately 
        
        vc.username = "a"
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
