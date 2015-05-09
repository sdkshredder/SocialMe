//
//  TableTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/6/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class TableTVCell: UITableViewCell {
	
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var textField: UITextField!
	
	@IBAction func editTF(sender: UIButton) {
		if textField.enabled == false {
			textField.enabled = true
			sender.titleLabel?.text = "Save"
			
		} else {
			var user = PFUser.currentUser()
			var attr = getTitleForPath(title.tag)
			println(attr)
			user!.setObject(textField.text, forKey: attr)
			user!.saveInBackgroundWithBlock {
				(succeeded, error) -> Void in
				if error == nil {
					println("success for user \(user!.username)")
				}
			}
		}
	}
	
	func getTitleForPath(row: Int) -> String {
		var res = ""
		switch row {
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
}