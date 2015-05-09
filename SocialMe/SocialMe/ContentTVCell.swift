//
//  ContentTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/3/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class ContentTVCell: UITableViewCell {
	
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var button: UIButton!
	@IBAction func tap(sender: UIButton) {
		
		var info = [String : Int]()
		info["index"] = sender.tag
		let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotateAnimation.fromValue = 0.0
		rotateAnimation.toValue = CGFloat(M_PI * 2.0)
		rotateAnimation.duration = 0.2
		sender.layer.addAnimation(rotateAnimation, forKey: nil)
		NSNotificationCenter.defaultCenter().postNotificationName("cellNotification", object: nil, userInfo: info)
		handleTextField()
	}
	
	func handleTextField() {
		if textField.enabled {
			textField.enabled = false
		} else {
			textField.enabled = true
		}
	}
}