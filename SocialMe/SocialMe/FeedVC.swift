//
//  FeedVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/19/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let tableView = UITableView()
    var data = NSArray()
    
    @IBAction func ShowProfile(sender: UIBarButtonItem) {
        println("Profile Tab")
        navigationController?.setNavigationBarHidden(true, animated: true)
        let tab = tabBarController!.tabBar
        UIView.animateWithDuration(0.2, animations: {
            tab.frame.origin = CGPointMake(0, self.view.frame.height)
            self.tableView.frame.origin = CGPointMake(0, self.view.frame.height - 50)
            
            }, completion: {
                (value: Bool) in
                self.addSwipeUp()
        })
        
    }
    
    
    @IBAction func showSettings(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("settings") as! SettingsTVC
        
            navigationController?.pushViewController(vc, animated: true)
            /*setNavigationBarHidden(true, animated: true)
        
        UIView.animateWithDuration(0.2, animations: {
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.height)
            self.tableView.frame.origin = CGPointMake(0, self.view.frame.height)
            
        })
*/
        
    }
    
    
    func addSwipeUp() {
        let swipeView = UIView(frame: CGRectMake(0, view.frame.height - 50, view.frame.width, 50))
        let swipe = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        swipe.direction = .Up
        view.backgroundColor = UIColor.orangeColor()
        let tap = UITapGestureRecognizer(target: self, action: "swipeUp:")
        swipeView.userInteractionEnabled = true
        swipeView.addGestureRecognizer(swipe)
        swipeView.addGestureRecognizer(tap)
        view.addSubview(swipeView)
        
    }
    
    func swipeUp(sender: UISwipeGestureRecognizer) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let tab = tabBarController!.tabBar
        UIView.animateWithDuration(0.2, animations: {
            tab.frame.origin = CGPointMake(0, self.view.frame.height - 50)
            self.tableView.frame.origin = CGPointMake(0, 0)
            }, completion: {
                (value: Bool) in
                sender.view?.removeFromSuperview()
        })
        
    }
    
    func initTableView() {
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.rowHeight = 240
        view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell") //tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let user = data[indexPath.row] as! PFUser
        println(user)
        /*
        cell.textLabel!.text = user.username
        cell.detailTextLabel!.text = user.email
        cell.imageView?.image = UIImage(named: "podcasts")
        cell.separatorInset = UIEdgeInsetsZero
        
        cell.layoutMargins = UIEdgeInsetsZero
*/
        styleCell(cell.contentView, user: user)
        
        // cell.contentView.backgroundColor = UIColor.grayColor()
        
        return cell
    }

    
    func styleCell(content: UIView, user: PFUser) {
        let a = UIView(frame: CGRectMake(0, 0, 350, 240))
        //a.backgroundColor = UIColor.greenColor()
        /*
        let userImageFile = anotherPhoto["imageFile"] as PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                }
            }
        }
        */
        /*
        if user.objectForKey("photo") != nil {
           let profilePic = UIImageView(data:user.objectForKey("photo") as! PFFile)
        } else {
            let profilePic = UIImageView(image: UIImage(named: "podcasts"))
        }
        */
        
        let profilePic = UIImageView(image: UIImage(named: "podcasts"))
        profilePic.layer.cornerRadius = profilePic.frame.height/2.0
        profilePic.clipsToBounds = true
        profilePic.frame = CGRect(x: CGRectGetMinX(a.bounds) + 30, y: CGRectGetMinY(a.bounds) + 10, width: profilePic.frame.size.width, height: profilePic.frame.size.height)
        a.addSubview(profilePic)
        
        var name = UILabel(frame: CGRect(x: CGRectGetMaxX(profilePic.bounds) + 60, y: CGRectGetMinY(a.bounds), width: 100, height: 50))
        name.text = user.username
        name.font = UIFont .boldSystemFontOfSize(18.0)
        a.addSubview(name)
        var distance = UILabel(frame: CGRect(x: CGRectGetMaxX(profilePic.bounds) + 60, y: CGRectGetMinY(a.bounds) + 35, width: 100, height: 20))
        distance.text = "500 feet"
        a.addSubview(distance)
        var occupation = UILabel(frame: CGRect(x: CGRectGetMaxX(profilePic.bounds) + 60, y: CGRectGetMinY(a.bounds) + 55, width: 150, height: 20))
        occupation.text = user.objectForKey("Occupation") as? String
        a.addSubview(occupation)

        
        
        content.clipsToBounds = true
        content.addSubview(a)
        content.sendSubviewToBack(a)
        content.bringSubviewToFront(profilePic)
    }
    
    func getAllUsers() {
        let value = NSArray()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            let user = PFUser.currentUser()
            
            var query = PFUser.query()
            query!.whereKey("username", notEqualTo: user?.objectForKey("username") as! String)
            query!.whereKey("Age", greaterThan: (user?.objectForKey("lowerAgeFilter") as! Int) - 1)
            query!.whereKey("Age", lessThan: (user?.objectForKey("upperAgeFilter") as! Int) + 1)
            if user?.objectForKey("genderFilter") as! String != "Both"{
                query!.whereKey("gender", matchesRegex: (user?.objectForKey("genderFilter") as! String))
            }
            
            //let kilometers = (user?.objectForKey("distanceFilter") as! Double) / 3280.84
            //println(kilometers)
            
            //query!.whereKey("location", nearGeoPoint: user?.objectForKey("location") as! PFGeoPoint, withinKilometers: kilometers)
            
            
            //query!.whereKey("location", nearGeoPoint: user?.objectForKey("location") as! PFGeoPoint, withinKilometers: user?.objectForKey("distanceFilter") as! Double)
            
            //var name = PFUser.query()
            //name!.whereKey("username", notEqualTo: user?.objectForKey("username") as! String)
            
            //var lowerAge = PFUser.query()
            //lowerAge!.whereKey("Age", greaterThan: (user?.objectForKey("lowerAgeFilter") as! Int) - 1)
            
            //var query = PFQuery.orQueryWithSubqueries([lowerAge!, name!])
            println(query)
            /*query.findObjectsInBackgroundWithBlock{
                (results: [AnyObject]?, error:NSError?) -> Void in
                if error == nil {*/
                    var res : NSArray = query!.findObjects()!
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.data = res
                        self.tableView.reloadData()
                    }
                //}
            //}
            
            
            

            
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        //let segueID = UIStoryboardSegue(identifier: "profileSegue", source: self, destination: ProfileVC.self)
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("profileSegue", sender: cell)
        
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    @IBAction func logout(sender: UIButton) {
        PFUser.logOut()
        presentMainVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        getAllUsers()
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            presentMainVC()
        }
        getAllUsers()
    }
    
    func presentMainVC () {
        let vc : UINavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let path = tableView.indexPathForCell(cell)
        let destination = segue.destinationViewController as! ProfileVC
        
        let user : PFUser = data[path!.row] as! PFUser
        destination.username = user.username!
        destination.navigationItem.title = user.username!
        
    }

}
