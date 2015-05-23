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
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    var editingAge = false
    
    func colorTable() {
        for subview in table.subviews {
            subview.contentView.backgroundColor = UIColor.blueColor()
        }
    }
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleNotification:", name: "ageNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleImageNotification:", name: "imageNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        var originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // constraint.constant -= originDelta
        
        // view.setNeedsUpdateConstraints()
        
        if showsKeyboard == false {
            self.table.frame.size.height = 470
            //self.table.frame.height // = originDelta
        } else {
                            var height = self.table.frame.size.height
                            println(height)
                            let a = height + originDelta + 50
                            self.table.frame.size.height = a
        }
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            //self.view.layoutIfNeeded()
            
            if showsKeyboard == false {
                
                //self.table.frame.height // = originDelta
            } else {
//                var height = self.table.frame.size.height
//                println(height)
//                let a = height + originDelta + 50
//                self.table.frame.size.height = a
            }
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        //let selectedRange = textView.selectedRange
        //textView.scrollRangeToVisible(selectedRange)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("hideSettings", object: nil)
    }
    
    func getCellID(path : Int) -> String {
        let a = getTitleForPath(path)
        if a == "Age" {
            return "ageCell"
        } else if a == "" {
            return "logoutCell"
        }
        
        else if a == "Profile Picture"{
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
                            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height / 2.0
                            cell.profilePicture.clipsToBounds = true
                        }
                    }
                }
            }
            
            return cell
        } else if ID == "logoutCell" {
            var cell = tableView.dequeueReusableCellWithIdentifier(ID) as! LogOutTVCell
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
        registerNotifications()
    }
    
    func presentPicker(type : UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let picker = UIImagePickerController()
            picker.sourceType = type
            if type == .Camera {
                picker.showsCameraControls = true
                picker.mediaTypes = [kUTTypeImage]
            }
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func handleImageNotification(notification: NSNotification) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title:"Upload Photo", style:UIAlertActionStyle.Default, handler:{ action in
            let type = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentPicker(type)
        }))
        actionSheet.addAction(UIAlertAction(title:"Take a Picture", style:UIAlertActionStyle.Default, handler:{ action in
            let type = UIImagePickerControllerSourceType.Camera
            self.presentPicker(type)
        }))
        actionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        
        presentViewController(actionSheet, animated:true, completion:nil)
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
                println("image saved")
            } else {
                println("error saving image")
            }
    
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("hideSettings", object: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("hideSettings", object: nil)
    }

    func handleNotification(notification: NSNotification) {
        editingAge = !editingAge
        table.beginUpdates()
        table.endUpdates()
        NSNotificationCenter.defaultCenter().postNotificationName("pickerNotification", object: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let a = getTitleForPath(indexPath.section)
        if a == "Age" && editingAge == true {
            return 340
        } else if a == "Location" {
            return 90
        } else if a == "Profile Picture" {
            return 240
        } else if a == "Log Out" {
            return 50
        }
        return 60
    }
    
    func getTitleForPath(path : Int) -> String {
        switch path {
        case 0:
            return "Profile Picture"
        case 1:
            return "Name"
        case 2:
            return "Hometown"
        case 3:
            return "School"
        case 4:
            return "Occupation"
        case 5:
            return "Location"
        default:
            return ""
        }
    }
}
