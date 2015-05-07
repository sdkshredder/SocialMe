//
//  ProfileTVC.swift
//  SocialMe
//
//  Created by Kelsey Young on 5/1/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class ProfileTVC: UITableViewCell, UITextFieldDelegate {

	@IBOutlet weak var attrTextField: UITextField!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		// self.contentView.userInteractionEnabled = false
        // Initialization code
    }

	@IBAction func editAttribute(sender: UIButton) {
		println(sender.titleLabel!.text)
		if sender.titleLabel!.text == "Edit" {
			
		}
	}
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
