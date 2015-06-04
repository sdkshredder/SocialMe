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

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource,
    UITextFieldDelegate, UITextViewDelegate {
    
    var userPic : UIImage?
    var username = NSString()
    var user : PFUser! // = []
    var numAttr = 5
    var loggedInUser = PFUser.currentUser()!
    var requestRes : NSString!
    var messageTV = UITextView()
    var v_ : UIVisualEffectView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var addUserButton: UIButton!
    @IBAction func addFriendAction(sender: UIButton) {
        sendFriendRequest(user, fromUser: loggedInUser)
    }
    
    func sendFriendRequest(toUser : PFUser, fromUser : PFUser)  {
		//let predicate = NSPredicate(format: "toUser = '@s' and fromUser = '@s' ",toUser.username!,fromUser.username!)
		var requestQuery = PFQuery(className: "FriendRequests")
        requestQuery.whereKey("toUser", equalTo: toUser.username!)
        requestQuery.whereKey("fromUser", equalTo: fromUser.username!)
		
		var requestQuery2 = PFQuery(className: "FriendRequests")
		requestQuery2.whereKey("toUser", equalTo: fromUser.username!)
		requestQuery2.whereKey("fromUser", equalTo: toUser.username!)
		
		var query = PFQuery.orQueryWithSubqueries([requestQuery,requestQuery2])
        var status : NSString?
        query.findObjectsInBackgroundWithBlock{
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
                            println("Friend Request Sent")
                            let alert = UIAlertView(title: "Success!", message: "Friend Request Sent", delegate: nil, cancelButtonTitle: "Done")
                            alert.show()
                        }
                    }
                } else {
                    //Entry does pre-exist
                    if let objects = objects as? [PFObject] {
                        var entry = objects[0]
						var entryStatus = entry["status"] as! NSString
						if (entryStatus == "approved") {
							let alert = UIAlertView(title: "Hey!", message: "You guys are already friends.", delegate: nil, cancelButtonTitle: "OK")
							alert.show()
						} else if (entryStatus == "blocked") {
							let alert = UIAlertView(title: "Sorry,", message: "This user is not accepting friend requests right now.", delegate: nil, cancelButtonTitle: "OK")
							alert.show()
						} else {
							let alert = UIAlertView(title: "Guess What!", message: "There's already a pending friend request between you two.", delegate: nil, cancelButtonTitle: "OK")
							alert.show()
						}
					}
                }
            }
        }
    }
    

    
    /*
    //set width and height by click.....ctrl drag on the center vertically to set it on the blue line
    func tableView(tableView: UITableView, heightForRowAtIndexPath: NSIndexPath) -> CGFloat {
        return 62
    }
*/
	
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
		cell.selectionStyle = .None
		
        //let user = userData[0] as! PFUser
        println(user)
        if user != nil {
			
			if (indexPath.row == 0) {
				cell.attrLabel?.text = "About "+user.username!+""
				if let aboutMe = user.objectForKey("aboutMe") as? String {
					cell.inputLabel?.text = aboutMe
					cell.inputLabel?.numberOfLines = 0
				}
			}
            if (indexPath.row == 1) {
                cell.attrLabel?.text = "Name "
                cell.inputLabel?.text = user.username
            }
            if (indexPath.row == 2) {
                cell.attrLabel?.text = "Age "
                if let age = user.objectForKey("Age") as? String {
                    cell.inputLabel?.text = age
					
                }
                //cell.inputLabel?.text = user.objectForKey("Age") as? String
            }
            if (indexPath.row == 3) {
                cell.attrLabel?.text = "Hometown "
                if let hometown = user.objectForKey("Hometown") as? String {
                    cell.inputLabel?.text = hometown
                }
                //cell.inputLabel?.text = user.objectForKey("Hometown") as? String
            }
            if (indexPath.row == 4) {
                cell.attrLabel?.text = "Occupation "
                if let occupation = user.objectForKey("Occupation") as? String {
                    cell.inputLabel?.text = occupation
                }
                //cell.inputLabel?.text = user.objectForKey("Occupation") as? String
            }
            if (indexPath.row == 5) {
                cell.attrLabel?.text = "Alma Mater "
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
    
    func hideBars(bool: Bool) {
        navigationController?.setNavigationBarHidden(bool, animated: true)
        
        
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        let blur = UIBlurEffect(style: .ExtraLight)
        let vibrancy = UIVibrancyEffect(forBlurEffect: blur)
        let v = UIVisualEffectView(effect: vibrancy)
        v_ = UIVisualEffectView(effect: blur)
        v.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        v_.frame = CGRectMake(0, view.frame.height, view.frame.width, view.frame.height)
        
        let messageLabel = UILabel(frame: CGRectMake(16, 64, 400, 30))
        messageLabel.text = "Send \(user.username!) a message:"
        v.contentView.addSubview(messageLabel)
        
        messageTV.delegate = self
        messageTV.frame = CGRectMake(16, 100, view.frame.width - 32, 200)
        messageTV.layer.cornerRadius = 4
        messageTV.layer.borderWidth = 1
        messageTV.font = UIFont.systemFontOfSize(23)
        messageTV.becomeFirstResponder()
        
        let sendButton = UIButton(frame: CGRectMake(view.frame.width - 116, 308, 100, 44))
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.layer.cornerRadius = 4
        sendButton.layer.borderWidth = 2
        sendButton.layer.borderColor = UIColor.greenColor().CGColor
        sendButton.tintColor = UIColor.greenColor()
        sendButton.addTarget(self, action: "sendMessageButtonTouched:", forControlEvents: .TouchUpInside)
        v.contentView.addSubview(sendButton)
        
        let xButton = UIButton(frame: CGRectMake(16, 32, 34, 34))
        xButton.setBackgroundImage(UIImage(named: "x_"), forState: UIControlState.Normal)
        xButton.addTarget(self, action: "exitMessage:", forControlEvents: .TouchUpInside)
        v.contentView.addSubview(xButton)
        
        messageTV.layer.borderColor = UIColor.whiteColor().CGColor
        v.contentView.addSubview(messageTV)
        v_.contentView.addSubview(v)
        
        view.addSubview(v_)
        
        hideBars(true)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.v_.frame.origin = CGPointMake(0, 0)
        }, completion: nil)
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            messageTV.resignFirstResponder()    
        }
        return true
    }
    
    func getQueryKey(a: String, b: String) -> String {
        if a > b {
            return "\(a)\(b)"
        }
        return "\(b)\(a)"
    }
    
    func sendMessageButtonTouched(sender : UIButton) {
        var requestEntry = PFObject(className: "Messages")
        requestEntry["toUser"] = user.username
        requestEntry["fromUser"] = loggedInUser.username
        requestEntry["message"] = messageTV.text
        requestEntry["key"] = getQueryKey(user.username!, b: loggedInUser.username!)
        
        requestEntry.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let alert = UIAlertView(title: "Success!", message: "Your message has been sent.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                self.exitMessageView(true)
            } else {
                let alert = UIAlertView(title: "Error :(", message: "There was an error sending your message.  Please try again.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                self.exitMessageView(false)
            }
        }
    }
    
    func exitMessage(sender :UIButton) {
        exitMessageView(true)
    }
    
    func exitMessageView(clearTV: Bool) {
        UIView.animateWithDuration(0.2, animations: {
            self.v_.frame.origin = CGPointMake(0, self.view.frame.height)
        })
        if clearTV == true {
            messageTV.text = ""
        }
        messageTV.removeFromSuperview()
        messageTV.resignFirstResponder()
        hideBars(false)
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
		//Below Set Style for the Table View to allow For the aboutMe
		tableView.estimatedRowHeight = 60;
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.separatorColor = UIColor.clearColor()
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
