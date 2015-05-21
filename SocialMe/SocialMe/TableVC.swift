//
//  TableVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/6/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices
// import CoreImage

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let locationManager = CLLocationManager()
    let picker = UIImagePickerController()
    
    @IBOutlet weak var table: UITableView!
    var editingAge = false
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let a = getTitleForPath(indexPath.section)
        if a == "Age" && editingAge == true {
            return 220
        } else if a == "Location" {
            return 90
        } else if a == "Profile Picture" {
            return 150
        }
        return 60
    }
    
    func colorTable() {
        for subview in table.subviews {
            subview.contentView.backgroundColor = UIColor.blueColor() // = UIColor.blueColor()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func getTitleForPath(path : Int) -> String {
        switch path {
            case 0:
                return "Profile Picture"
            case 1:
                return "Name"
            case 2:
                return "Age"
            case 3:
                return "Hometown"
            case 4:
                return "School"
            case 5:
                return "Occupation"
            case 6:
                return "Location"
        default:
                return "Log Out"
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("hideSettings", object: nil)
    }
    
    func getCellID(path : Int) -> String {
        let a = getTitleForPath(path)
        if a == "Age" {
            return "ageCell"
        } else if a == "Profile Picture"{
            return "profilePictureCell"
        }
        else if a == "Location" {
            return "locationCell"
        }
        return "tableCell"
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getTitleForPath(section)
    }
    
    func configureStandardCell(cell: TableTVCell, indexPath: NSIndexPath) {
        cell.textField.placeholder = getTitleForPath(indexPath.section)
        cell.editButton.tag = indexPath.section
        
        let user = PFUser.currentUser()
        let attr = getTitleForPath(indexPath.section)
        
        if let val = user?.objectForKey(attr) as? String {
            cell.textField.placeholder = val 
        }
    }
    
    func configureAgeCell(cell: AgeTVCell) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ID = getCellID(indexPath.section)
        
        if ID == "profilePictureCell" {
            var cell = tableView.dequeueReusableCellWithIdentifier(ID) as! ProfilePictureTVCell
            
            if let picFile = PFUser.currentUser()?.objectForKey("photo") as? PFFile {
                picFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            cell.profilePicture.image = image
                        }
                    }
                }
            }
            
            return cell
        }
        
        else if ID == "tableCell" {
            var cell = tableView.dequeueReusableCellWithIdentifier(ID) as! TableTVCell
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
            let title = getTitleForPath(indexPath.section)
            cell.editButton.tag = indexPath.section
            cell.textField.attributedPlaceholder = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName : UIColor.purpleColor()])
            let user = PFUser.currentUser()
            let attr = getTitleForPath(indexPath.section)
            
            if let val = user?.objectForKey(attr) as? String {
                cell.textField.attributedPlaceholder = NSAttributedString(string: val, attributes: [NSForegroundColorAttributeName : UIColor.darkGrayColor()])
            }

            /*
            let val = user?.objectForKey(attr) as! String
   
            if !val.isEmpty {
                cell.textField.attributedPlaceholder = NSAttributedString(string: val, attributes: [NSForegroundColorAttributeName : UIColor.darkGrayColor()])
            }
            */
            return cell
        } else if ID == "ageCell" {
            var b = tableView.dequeueReusableCellWithIdentifier(ID) as! AgeTVCell
            return b
        } else {
            var c = tableView.dequeueReusableCellWithIdentifier(ID) as! LocationTVCell
            if (CLLocationManager.authorizationStatus() == .AuthorizedAlways) {
                c.control.selectedSegmentIndex = 0
            } else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
                c.control.selectedSegmentIndex = 1
            } else {
                c.control.selectedSegmentIndex = 2
            }
            return c
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleNotification:", name: "ageNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleImageNotification:", name: "imageNotification", object: nil)
    }
    
    func handleImageNotification(notification: NSNotification) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.showsCameraControls = true
            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = true
            let button = UIButton(frame: CGRectMake(100, 100, 100, 100))
            button.backgroundColor = UIColor.greenColor()
            button.addTarget(self, action: "pickPic:", forControlEvents: UIControlEvents.TouchUpInside)
            //picker.insertSubview(button, aboveSubview: picker.view)
            
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func pickPic(sender: UITapGestureRecognizer) {
        println("piiiimp")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
        }
        
        let file = PFFile(name:"photo.png", data:UIImagePNGRepresentation(image))
        let currentUser = PFUser.currentUser()
        currentUser!.setObject(file, forKey: "photo")
        currentUser!.saveInBackgroundWithBlock{
            (succeeded, error) -> Void in
            if error == nil {
                println("successsssss for user \(currentUser!.username)")
            } else {
                println(" error")
            }
    
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("hideSettings", object: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("hideSettings", object: nil)
    }
    
    /*
    func imagePickerControllerDidCancel(UIIPC) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil) }
    }
    */

    func handleNotification(notification: NSNotification) {
        editingAge = !editingAge
        //println(editingAge)
        table.beginUpdates()
        table.endUpdates()
        NSNotificationCenter.defaultCenter().postNotificationName("pickerNotification", object: nil)
    }
}
