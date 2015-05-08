//
//  ProfileTVC.swift
//  SocialMe
//
//  Created by Kelsey Young on 5/1/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class ProfileTVC: UITableViewCell, UITextFieldDelegate {
	//weak dissappears if there is not a pointer to it anymore

	@IBOutlet weak var inputLabel: UILabel!
	@IBOutlet weak var attrLabel: UILabel!
	@IBAction func hello(sender: UIButton) {
		println("hello")
	}
//    override func awakeFromNib() {
//        super.awakeFromNib()
//		// self.contentView.userInteractionEnabled = false
//        // Initialization code
//    }

//	@IBAction func editAttribute(sender: UIButton) {
//		println(sender.titleLabel!.text)
//		if sender.titleLabel!.text == "Edit" {
//			
//		}
//	}
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		println("Hey")
        // Configure the view for the selected state
    }

}
