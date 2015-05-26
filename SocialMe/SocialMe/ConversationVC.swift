//
//  ConversationVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/25/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class ConversationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTF: UITextField!
    var username = NSString()
    var data = [PFObject]()
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clearColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        UIView.animateWithDuration(0.2, animations: {
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.size.height)
        })
    }
    
    func getQueryKey(a: String, b: String) -> String {
        if a > b {
            return "\(a)\(b)"
        }
        return "\(b)\(a)"
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        if messageTF.text != "" {
            var newMessage = PFObject(className: "Messages")
            newMessage["toUser"] = username
            let sender = PFUser.currentUser()!.username!
            newMessage["fromUser"] = sender
            newMessage["message"] = messageTF.text
            newMessage["key"] = getQueryKey(username as String, b: sender)
            data.append(newMessage)
            tableView.reloadData()
            messageTF.text = ""
            messageTF.resignFirstResponder()
            newMessage.saveInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    println("success")
                } else {
                    println("not success")
                }
            }
        }
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        
        constraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        // let selectedRange = textView.selectedRange
        // textView.scrollRangeToVisible(selectedRange)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let message = data[indexPath.row]
        let sender : String = (message.objectForKey("fromUser") as? String)!
        println(sender)
        println(PFUser.currentUser()!.username!)
        
        var ID = "myConvoCell"
        var color = UIColor.blueColor()
        var textColor = UIColor.whiteColor()
        if sender != PFUser.currentUser()!.username! {
            ID = "convoCell"
            color = UIColor.lightGrayColor()
            textColor = UIColor.blackColor()
        }
        
        // println(ID)
        var messageText : String = (message.objectForKey("message") as? String)!
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as! ConvoTVCell
        cell.messageLabel.text = messageText
        cell.messageLabel.numberOfLines = 0
        cell.messageLabel.textColor = textColor
        cell.messageLabel.backgroundColor = color
        cell.messageLabel.clipsToBounds = true
        cell.messageLabel.font = UIFont.systemFontOfSize(16)
        cell.messageLabel.layer.cornerRadius = 4
        
        
        /*
        var obj = messages[indexPath.row]
        println(obj["text"])
        
        cell.messageLabel.text = obj["text"] as? String
        if let username = obj["user"] as? String {
            cell.usernameLabel.text = username
        } else {
            cell.usernameLabel.text = "[no username]"
        }
        */
        return cell
    }
}
