//
//  LocationTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/11/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTVCell: UITableViewCell, UIAlertViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var control: UISegmentedControl!
    
    @IBAction func edit(sender: UIButton) {
        if sender.titleLabel!.text == "Edit" {
            editButton.setTitle("Save", forState: .Normal)
            control.enabled = true
        } else {
            editButton.setTitle("Edit", forState: .Normal)
            editButton.enabled = false 
            control.enabled = false
            var type = "none"
            if control.selectedSegmentIndex == 0 {
                type = "always"
            } else if control.selectedSegmentIndex == 1 {
                type = "while"
            }
            NSNotificationCenter.defaultCenter().postNotificationName("locationPreferences", object: nil, userInfo: ["pref":type])
        }
    }
    
    @IBAction func info(sender: UIButton) {
    }
    
    @IBAction func change(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            locationManager.requestAlwaysAuthorization()
        case 1:
            locationManager.requestWhenInUseAuthorization()
        default:
            UIApplication.sharedApplication().openURL(NSURL(string: "app-settings:")!)
        }
    }
}
