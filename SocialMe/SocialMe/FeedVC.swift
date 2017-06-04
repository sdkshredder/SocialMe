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
    var refresh = UIRefreshControl()
    
    @IBAction func ShowProfile(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("myProfile") as! TableVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func showSettings(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("settings") as! SettingsTVC
            navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func addSwipeUp() {
        let swipeView = UIView(frame: CGRectMake(0, view.frame.height - 50, view.frame.width, 50))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(FeedVC.swipeUp(_:)))
        swipe.direction = .Up
        view.backgroundColor = UIColor.orangeColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(FeedVC.swipeUp(_:)))
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
        refresh.addTarget(self, action: #selector(FeedVC.updateFeed), forControlEvents: .ValueChanged)
        tableView.addSubview(refresh)
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.rowHeight = 240
        view.addSubview(tableView)
    }
    
    func updateFeed() {
        tableView.reloadData()
        let delayInSeconds = 1.0;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.refresh.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        let user = data[indexPath.row] as! PFUser
        styleCell(cell.contentView, user: user)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }

    
    func styleCell(content: UIView, user: PFUser) {
        let profilePicture = UIImageView()
        if let userImageFile = user.objectForKey("photo") as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil {
                    profilePicture.image = UIImage(data:imageData!)!
                }
                profilePicture.contentMode = .ScaleAspectFill
            }
        } else {
            profilePicture.image = UIImage(named: "SI-60@2x.png")
            profilePicture.contentMode = .ScaleAspectFit
        }
        
        var frame = CGRectMake(22, content.frame.height/2.0 - 5, 50, 50)
        profilePicture.frame = frame
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2.0
        profilePicture.clipsToBounds = true
        content.addSubview(profilePicture)
		
		var nameLabel = UILabel(frame: CGRectMake(100, profilePicture.frame.origin.y - 10, 200,30))
        nameLabel.text = user.username
        nameLabel.font = UIFont.boldSystemFontOfSize(18)
        content.addSubview(nameLabel)
        
        var distance = ((user.objectForKey("location") as? PFGeoPoint)!.distanceInKilometersTo(PFUser.currentUser()?.objectForKey("location") as? PFGeoPoint)) * 3280.84
        var distanceLabel = UILabel(frame: CGRectMake(100, nameLabel.frame.origin.y + 26, 200, 20))
        distanceLabel.text = "\(round(distance)) ft"
        distanceLabel.font = UIFont.systemFontOfSize(16)
        content.addSubview(distanceLabel)
		
		var goalLabel = UILabel(frame: CGRectMake(100, nameLabel.frame.origin.y + 44, 200, 20))
		
		
        if let goal = user.objectForKey("relationshipGoal") as? String {
			var relatGoal = "Relationship Goal: "
			
			let prefix = NSMutableAttributedString(string: relatGoal + goal)
			
			var color : UIColor
			
			if (goal == "Romantic") {
				color = UIColor(red: 299.0/255.0, green: 79.0/255.0, blue: 122.0/255.0, alpha: 1)
				

			} else if (goal == "Business") {
				color = UIColor.blueColor()
			} else if (goal == "Social") {
				color = UIColor(red: 58.0/255.0, green: 45.0/255.0, blue: 128.0/255.0, alpha: 1)
			} else {
				color = UIColor.greenColor()
			}
			
//			prefix.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(count(relatGoal), count(goal)))
			goalLabel.attributedText = prefix
			
		} else {
			var goal = "All"
			var relatGoal = "Relationship Goal: "
			
			let prefix = NSMutableAttributedString(string: relatGoal + goal)
//			prefix.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSMakeRange(count(relatGoal), count(goal)))
			goalLabel.attributedText = prefix
		}
		
		
		goalLabel.font = UIFont.systemFontOfSize(14)
		content.addSubview(goalLabel)
		
    }
	
    func fetchUsers() {
        let value = NSArray()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            let user = PFUser.currentUser()
            
            var query = PFUser.query()
            query!.whereKey("username", notEqualTo: user?.objectForKey("username") as! String)
            
            query!.whereKey("Age", greaterThan: (user?.objectForKey("lowerAgeFilter") as! Int) - 1)
            query!.whereKey("Age", lessThan: (user?.objectForKey("upperAgeFilter") as! Int) + 1)
			if let userRelationshipGoal = user?.objectForKey("relationshipGoal") as? String {
				if (userRelationshipGoal != "All") {
                    query!.whereKey("relationshipGoal", matchesRegex: userRelationshipGoal)
				}
			}

            if user?.objectForKey("genderFilter") as! String != "Both"{
                query!.whereKey("gender", matchesRegex: (user?.objectForKey("genderFilter") as! String))
            }
            
			
            let kilometers = (user?.objectForKey("distanceFilter") as! Double) / 3280.84
            query!.whereKey("location", nearGeoPoint: user?.objectForKey("location") as! PFGeoPoint, withinKilometers: kilometers)
			
            
            let keywordQuery = PFQuery(className: "KeywordFilter")
            keywordQuery.whereKey("username", equalTo: user!.username!)
            var objectArr = keywordQuery.findObjects() as! [PFObject]
            
            if objectArr.count > 0 { // Username exists in keyword filters
                let keyObj = objectArr[0]
                
                
                
                if let filter = keyObj["homeFilter"] as? NSMutableArray {
                    if filter.count > 0 {
                        var home = PFQuery.orQueryWithSubqueries([query!])
                        home.whereKey("Hometown", containsString: (filter[0] as! String))
                        for keyword in filter {
                            let find = PFQuery.orQueryWithSubqueries([query!])
                            find.whereKey("Hometown", containsString: (keyword as! String))
                            home = PFQuery.orQueryWithSubqueries([home, find])
                        }
                        query = PFQuery.orQueryWithSubqueries([home])
                        /*var res : NSArray = query!.findObjects()!
                        
                        self.data = res
                        self.tableView.reloadData()*/
                        
                    }
                }
                if let filter = keyObj["schoolFilter"] as? NSMutableArray {
                    if filter.count > 0 {
                        var school = PFQuery.orQueryWithSubqueries([query!])
                        school.whereKey("School", containsString: (filter[0] as! String))
                        print("First filter is")
                        print(filter[0] as! String)
                        for keyword in filter {
                            //var tQuery = PFUser.query()
                            //tQuery!.whereKey("School", containsString: (keyword as! String))
                            
                            let find = PFQuery.orQueryWithSubqueries([query!])
                            print("This is our school query")
                            print(keyword as! String)
                            print(query?.description)
                            find.whereKey("School", containsString: (keyword as! String))
                            school = PFQuery.orQueryWithSubqueries([school, find])
                        }
                        query = PFQuery.orQueryWithSubqueries([school])
                        /*var res : NSArray = query!.findObjects()!
                        
                        self.data = res
                        self.tableView.reloadData()*/
                        
                    }
                }
                if let filter = keyObj["occFilter"] as? NSMutableArray {
                    if filter.count > 0 {
                        var occ = PFQuery.orQueryWithSubqueries([query!])
                        occ.whereKey("Occupation", containsString: (filter[0] as! String))
                        for keyword in filter {
                            let find = PFQuery.orQueryWithSubqueries([query!])
                            find.whereKey("Occupation", containsString: (keyword as! String))
                            occ = PFQuery.orQueryWithSubqueries([occ, find])
                        }
                        query = PFQuery.orQueryWithSubqueries([occ])
                        /*var res : NSArray = query!.findObjects()!
                    
                        self.data = res
                        self.tableView.reloadData()*/
                        
                        
                    }
                }
                if let filter = keyObj["aboutFilter"] as? NSMutableArray {
                    if filter.count > 0 {
                        var about = PFQuery.orQueryWithSubqueries([query!])
                        about.whereKey("aboutMe", containsString: (filter[0] as! String))
                        for keyword in filter {
                            let find = PFQuery.orQueryWithSubqueries([query!])
                            find.whereKey("aboutMe", containsString: (keyword as! String))
                            about = PFQuery.orQueryWithSubqueries([about, find])
                            print("Heeere")
                            print(keyword)
                        }
                        query = PFQuery.orQueryWithSubqueries([about])
                        /*var res : NSArray = query!.findObjects()!
                        
                        self.data = res
                        self.tableView.reloadData()*/
                        
                        
                    }
                }
            }
            let res : NSArray = query!.findObjects()!
                    
            dispatch_async(dispatch_get_main_queue()) {
                self.data = res
                self.tableView.reloadData()
            }

            
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        fetchUsers()
		print("You're logged in as \(PFUser.currentUser()?.username)")
    }
	func capFirstLetter(name: String) -> String {
        return "temp"
        /*
		if (name.isEmpty) {
			return name
		}
		var capLet = name.substringWithRange(Range<String.Index>(start: name.startIndex , end: advance(name.startIndex, 1))) as NSString
		capLet = capLet.uppercaseString
		let rest =  name.substringFromIndex(advance(name.startIndex, 1)) as NSString
		return (capLet as String) + (rest as String)
        */
	}
	
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            presentMainVC()
        }
        fetchUsers()
    }
    
    func presentMainVC () {
        let vc : UINavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let path = tableView.indexPathForCell(cell)
        let destination = segue.destinationViewController as! ProfileVC
        
        let user : PFUser = data[path!.row] as! PFUser
        destination.username = user.username!
		
		destination.navigationItem.title = capFirstLetter(user.username!)

    }

}
