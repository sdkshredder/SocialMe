//
//  Profilepage.swift
//  SocialMe
//
//  Created by Kelsey Young on 4/23/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class ProfilepageVC: UIViewController, UITextFieldDelegate, UITableViewDataSource{
	var attrs = ["Name": "", "Age": 0, "Hometown": "", "Occupation": "","School": "","Favorite Hobby": ""]
	//ensures tableView will have val unless it will crash
	@IBOutlet var tableView:UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadProfInfo()
	}
	
	func loadProfInfo() {
		// get profile dada from parse
		
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//plus 1 for the photo row.
		return self.attrs.count + 1 ?? 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("attrCell") as! ProfilepageTableViewCell
		return cell
	}
	
}
