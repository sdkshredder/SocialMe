//
//  ProfileVC.swift
//  SocialMe
//
//  Created by Mariam Ghanbari on 4/26/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse
import Foundation

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var userPic : UIImage?
    var username = NSString()
    var user : PFUser! // = []
    var numAttr = 5
    var loggedInUser = PFUser.currentUser()!
    var requestRes : NSString!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var addUserButton: UIButton!
    @IBAction func addFriendAction(sender: UIButton) {
        sendFriendRequest(user, fromUser: loggedInUser)
    }
    
    func sendFriendRequest(toUser : PFUser, fromUser : PFUser)  {
        var requestQuery = PFQuery(className: "FriendRequests")
        requestQuery.whereKey("toUser", equalTo: toUser.username!)
        requestQuery.whereKey("fromUser", equalTo: fromUser.username!)
        var status : NSString?
        requestQuery.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                println("There is a friend request here already")
                
            } else {
                if (objects?.count == 0) {
                    //No entry pre-exists
                    var requestEntry = PFObject(className: "FriendRequests")
                    requestEntry["toUser"] = toUser.username
                    requestEntry["fromUser"] = fromUser.username
                    requestEntry["status"] = "pending"
                    requestEntry.saveInBackgroundWithBlock{
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            self.requestRes = "pending"
                            self.notifyUsers("pending")
                            println("Friend Request Sent")
        
                            let alert = UIAlertView(title: "Success!", message: "Friend Request Sent", delegate: nil, cancelButtonTitle: "Done")
                            alert.show()
                            
                        }
                    }
                } else {
                    //Entry does pre-exist
                    if let objects = objects as? [PFObject] {
                        var entry = objects[0]
                        self.notifyUsers(entry["status"] as! NSString)
                    }
                    
                }
            }
        }
    }
    
    func notifyUsers(status: NSString) {
        
    }
    
    
    //set width and height by click.....ctrl drag on the center vertically to set it on the blue line
    func tableView(tableView: UITableView, heightForRowAtIndexPath: NSIndexPath) -> CGFloat {
        return 62
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("profileCell") as! ProfileTVCell
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        cell.attrLabel.alpha = 0
        cell.inputLabel.alpha = 0
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        //let user = userData[0] as! PFUser
        println(user)
        if user != nil {
            
            if (indexPath.row == 0) {
                cell.attrLabel?.text = "Name: "
                cell.inputLabel?.text = user.username
            }
            if (indexPath.row == 1) {
                cell.attrLabel?.text = "Age: "
                if let age = user.objectForKey("Age") as? String {
                    cell.inputLabel?.text = age
                }
                //cell.inputLabel?.text = user.objectForKey("Age") as? String
            }
            if (indexPath.row == 2) {
                cell.attrLabel?.text = "Hometown: "
                if let hometown = user.objectForKey("Hometown") as? String {
                    cell.inputLabel?.text = hometown
                }
                //cell.inputLabel?.text = user.objectForKey("Hometown") as? String
            }
            if (indexPath.row == 3) {
                cell.attrLabel?.text = "Occupation: "
                if let occupation = user.objectForKey("Occupation") as? String {
                    cell.inputLabel?.text = occupation
                }
                //cell.inputLabel?.text = user.objectForKey("Occupation") as? String
            }
            if (indexPath.row == 4) {
                cell.attrLabel?.text = "Alma Mater: "
                if let school = user.objectForKey("School") as? String {
                    cell.inputLabel?.text =  school
                }
                //cell.inputLabel?.text = user.objectForKey("School") as? String
            }
            
        }
        UIView.animateWithDuration(0.5, animations: {
            cell.attrLabel.alpha = 1
            cell.inputLabel.alpha = 1
        })
        
        //cell.inputLabel?.text = input
        
        //tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        //let user = data[indexPath.row] as! PFUser
        //println(user)
        /*
        cell.textLabel!.text = user.username
        cell.detailTextLabel!.text = user.email
        cell.imageView?.image = UIImage(named: "podcasts")
        cell.separatorInset = UIEdgeInsetsZero
        */
        // cell.contentView.backgroundColor = UIColor.grayColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // println(indexPath.row)
        //let segueID = UIStoryboardSegue(identifier: "profileSegue", source: self, destination: ProfileVC.self)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        //	performSegueWithIdentifier("profileSegue", sender: cell)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numAttr
    }
    
    
    
    //TODO: Need to debug for empty resulting array
    
    func getUserInfo() {
        let value = NSArray()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            var query = PFUser.query()
            query!.whereKey("username", equalTo: self.username)
            let res = query!.findObjects() as! [PFUser]
            println(res[0])
            self.user = res[0] as PFUser
            //println(self.user.objectForKey("Hometown"))
            
            dispatch_async(dispatch_get_main_queue()) {
                //println(res[0])
                //self.user = res[0] as PFUser
                //println(self.user.objectForKey("Hometown"))
                self.loadProfilePicture()
                self.tableView.reloadData()
            }
        }
    }
    
    
    func loadProfilePicture() {
        
        
        if let userImageFile = user.objectForKey("photo") as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.userProfilePic.image = image
                    }
                }
            }
        } else {
            userProfilePic.image = UIImage(named: "swag-60@2x.png")
        }
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    func styleUserPic() {
        userProfilePic.layer.cornerRadius = userProfilePic.frame.height / 2.0
        userProfilePic.clipsToBounds = true
    }
    
    func styleButtons() {
        messageButton.layer.borderWidth = 1
        messageButton.layer.cornerRadius = 4
        messageButton.layer.borderColor = UIColor.purpleColor().CGColor
        
        addUserButton.layer.borderWidth = 1
        addUserButton.layer.cornerRadius = 4
        addUserButton.layer.borderColor = UIColor.purpleColor().CGColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(username)
        initTableView()
        styleUserPic()
        getUserInfo()
        styleButtons()
    }
    
}
