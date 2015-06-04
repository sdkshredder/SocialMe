//
//  PrivacyVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/26/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class PrivacyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tempCell = UITableViewCell()
        return tempCell
    }

}
