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
        refresh.addTarget(self, action: "updateFeed", forControlEvents: .ValueChanged)
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
        var delayInSeconds = 1.0;
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
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
            profilePicture.image = UIImage(named: "podcasts")
            profilePicture.contentMode = .ScaleAspectFit
        }
        
        var frame = CGRectMake(22, content.frame.height/2.0 - 5, 50, 50)
        profilePicture.frame = frame
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2.0
        profilePicture.clipsToBounds = true
        content.addSubview(profilePicture)
        
        var nameLabel = UILabel(frame: CGRectMake(100, profilePicture.frame.origin.y - 10, 200, 30))
        nameLabel.text = user.username
        nameLabel.font = UIFont.boldSystemFontOfSize(18)
        content.addSubview(nameLabel)
        
        var distance = ((user.objectForKey("location") as? PFGeoPoint)!.distanceInKilometersTo(PFUser.currentUser()?.objectForKey("location") as? PFGeoPoint)) * 3280.84
        var distanceLabel = UILabel(frame: CGRectMake(100, nameLabel.frame.origin.y + 26, 200, 20))
        distanceLabel.text = "\(round(100*distance)/100) ft"
        distanceLabel.font = UIFont.systemFontOfSize(16)
        content.addSubview(distanceLabel)
        
        if let occupation = user.objectForKey("Occupation") as? String {
            var occupationLabel = UILabel(frame: CGRectMake(100, nameLabel.frame.origin.y + 44, 200, 20))
            occupationLabel.text = occupation
            occupationLabel.textColor = UIColor.lightGrayColor()
            occupationLabel.font = UIFont.systemFontOfSize(14)
            content.addSubview(occupationLabel)
        }
    
    }
	
	func queryForUserFilters(feedUser :PFUser, filters :NSMutableArray, type :NSString) -> PFQuery {
		var QArr = NSMutableArray()
		for filter in filters {
			var Q = PFQuery(className: "KeywordFilter")
			Q.whereKey("username", equalTo: feedUser.username!)
			Q.whereKey(type as String, equalTo: filter)
			Q.selectKeys(["username"])
			QArr.addObject(Q)
		}
		return PFQuery.orQueryWithSubqueries(QArr as [AnyObject])
		
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
					query!.whereKey("relationshipGoal", equalTo: userRelationshipGoal)
				}
			}

            if user?.objectForKey("genderFilter") as! String != "Both"{
                query!.whereKey("gender", matchesRegex: (user?.objectForKey("genderFilter") as! String))
            }
            
			/* Uncomment this to implement distance filter.......
            let kilometers = (user?.objectForKey("distanceFilter") as! Double) / 3280.84
				query!.whereKey("location", nearGeoPoint: user?.objectForKey("location") as! PFGeoPoint, withinKilometers: kilometers)
			*/
			
			
			var res = query?.findObjects()
			
			
			if (res?.count > 0) {
				
				var keywordQuery = PFQuery(className: "KeywordFilter")
				keywordQuery.whereKey("username", equalTo: user!.username!)
				var objectArr = keywordQuery.findObjects() as! [PFObject]
				var userHomefilters = NSMutableArray()
				var userSchoolfilters = NSMutableArray()
				var userOccfilters = NSMutableArray()

				if objectArr.count > 0 { // Username exists in keyword filters
					var keyObj = objectArr[0]
					
					
					if var homeFilters =  keyObj["homeFilter"] as? NSArray {
						for filter in homeFilters {
							userHomefilters.addObject(filter)
						}
					}
					
					if var schoolFilters = keyObj["schoolFilter"] as? NSArray {
						for filter in schoolFilters {
							userSchoolfilters.addObject(filter)
						}
					}
					
					if var occFilters = keyObj["occFilter"] as? NSArray {
						for filter in occFilters {
							userOccfilters.addObject(filter)
						}
					}
					
					var homeQArr = NSMutableArray()
					var schoolQArr = NSMutableArray()
					var occQArr = NSMutableArray()
					//Sets up the metaQuery by forming diff subarrays for each filtering type
					for feedUser  in res as! [PFUser] {
						homeQArr.addObject(self.queryForUserFilters(feedUser, filters: userHomefilters, type: "homeFilter"))
						schoolQArr.addObject(self.queryForUserFilters(feedUser, filters: userSchoolfilters, type: "schoolFilter"))
						occQArr.addObject(self.queryForUserFilters(feedUser, filters: userOccfilters, type: "occFilter" ))
					}
					
					println("size of homeQarr Before")
					println(homeQArr.count)
					homeQArr.addObjectsFromArray(schoolQArr as [AnyObject])
					println("size of homeQarr After")
					println(homeQArr.count)
					
					
				}
			}

			
			
			
            dispatch_async(dispatch_get_main_queue()) {
                self.data = res!
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
		println("You're logged in as \(PFUser.currentUser()?.username)")
    }
	func capFirstLetter(name: String) -> String {
		if (name.isEmpty) {
			return name
		}
		var capLet = name.substringWithRange(Range<String.Index>(start: name.startIndex , end: advance(name.startIndex, 1))) as NSString
		capLet = capLet.uppercaseString
		var rest =  name.substringFromIndex(advance(name.startIndex, 1)) as NSString
		return (capLet as String) + (rest as String)
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
