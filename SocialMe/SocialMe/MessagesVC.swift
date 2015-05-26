//
//  MessagesVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/23/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var data = [(String, [String])]()
    var convoData = [PFObject]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageTVCell
        let info : (String, [String]) = data[indexPath.row] as (String, [String])
        
        cell.senderLabel.text = info.0
        let messages_info : [String] = info.1
        cell.messageLabel.text = messages_info[messages_info.count - 1].0
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let message : (String, [String]) = data[indexPath.row] as (String, [String])
        let username = message.0
        let currentUser = PFUser.currentUser()!
        let key = getQueryKey(currentUser.username!, b: username)
        fetchConversation(key, cell: cell!)
        
        // performSegueWithIdentifier("conversation", sender: cell)
        
    }
    
    func getQueryKey(a: String, b: String) -> String {
        if a > b {
            return "\(a)\(b)"
        }
        return "\(b)\(a)"
    }
    
    func fetchConversation(key : String, cell : UITableViewCell) {
        var query = PFQuery(className:"Messages")
        let currentUser = PFUser.currentUser()!
        query.whereKey("key", equalTo:key)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.convoData = objects
                    self.performSegueWithIdentifier("conversation", sender: cell)
                }
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    func fetchMessages() {
        var query = PFQuery(className:"Messages")
        let currentUser = PFUser.currentUser()!
        query.whereKey("toUser", equalTo:currentUser.username!)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects as? [PFObject] {
                    var dictionary = [String : [String]]()
                    for message in objects {
                        let sender = message.objectForKey("fromUser") as? String
                        let text = message.objectForKey("message") as? String
                        if dictionary[sender!] != nil {
                            var array = dictionary[sender!]!
                            array.append((text!))
                            
                            dictionary[sender!] = array
                        } else {
                            dictionary[sender!] = [(text!)]
                        }
                    }
                    var mutableData = [(String, [String])]()
                    for (sender, messages) in dictionary {
                        mutableData.append((sender, messages))
                    }
                    self.data = mutableData
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        fetchMessages()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if tabBarController?.tabBar.frame.origin.y == view.frame.height {
            UIView.animateWithDuration(0.2, animations: {
                self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.size.height - 49)
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let path = tableView.indexPathForCell(cell)
        let destination = segue.destinationViewController as! ConversationVC
        let message : (String, [String]) = data[path!.row] as (String, [String])
        let username = message.0
        let messages = message.1
        destination.username = username
        destination.data = convoData
        destination.navigationItem.title = username
    }
    
}
