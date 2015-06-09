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


class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    let locationManager = CLLocationManager()
    let picker = UIImagePickerController()
    
    @IBOutlet weak var navTitle: UIButton!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    var editingAge = false
    var editingAbout = false
    var aboutMeText : String!
    
    func colorTable() {
        for subview in table.subviews {
            subview.contentView.backgroundColor = UIColor.blueColor()
        }
    }
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleNotification:", name: "ageNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateAboutMeText:", name: "updateAboutMe", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleAboutMeNotification:", name: "aboutMeNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleAboutMeEndNotification:", name: "aboutMeNotificationEnd", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"handleImageNotification:", name: "imageNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "logOut:", name: "logoutNotification", object: nil)
    }
    
    func logOut(notification: NSNotification) {
        PFUser.logOut()
        let vc = storyboard?.instantiateViewControllerWithIdentifier("root") as! RootVC
        navigationController?.presentViewController(vc, animated: true, completion: nil)
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
        
        if showsKeyboard == false {
            self.table.frame.size.height = view.frame.height - (49 + 64)
        } else {
                            var height = self.table.frame.size.height
                            println(height)
                            let a = height + originDelta + 50
                            self.table.frame.size.height = a
        }
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
        
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        //let selectedRange = textView.selectedRange
        //textView.scrollRangeToVisible(selectedRange)
    }
    
    func updateAboutMeText(notification: NSNotification) {
        if let info = notification.userInfo as? [String : String] {
            aboutMeText = info["value"]
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 8
    }
    
    @IBAction func navTap(sender: UIButton) {
        
        let a = (UINib(nibName: "swagView", bundle: nil
            ).instantiateWithOwner(nil, options: nil)[0] as? SwagView)!

        a.frame = CGRectMake(view.frame.width/2.0 - 140, -100, 280, 200)
        view.addSubview(a)
        
        UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.4, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            a.frame.origin = CGPointMake(a.frame.origin.x, 140)
        }, completion: nil)
    
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("hideSettings", object: nil)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func getCellID(path : Int) -> String {
        let a = getTitleForPath(path)
        if a == "Age" {
            return "ageCell"
        } else if a == "" {
            return "logoutCell"
        }
        else if a == "Privacy" {
            return "privacyCell"
        }
        else if a == "Profile Picture"{
            return "profilePictureCell"
        }
        else if a == "Location" {
            return "locationCell"
        } else if a == "About Me" {
            return "aboutMeCell"
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 7 {
            performSegueWithIdentifier("privacyVC", sender: nil)
        }
        println(indexPath.section)
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
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if ID == "logoutCell" {
            var cell = tableView.dequeueReusableCellWithIdentifier(ID) as! LogOutTVCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
            
        else if ID == "aboutMeCell" {
            var cell = tableView.dequeueReusableCellWithIdentifier(ID) as! AboutMeTVCell
            cell.aboutMeLabel.numberOfLines = 0
            println(aboutMeText)
            if aboutMeText == "" {
                let user = PFUser.currentUser()
                if let aboutMe = user!.objectForKey("aboutMe") as? String {
                    cell.aboutMeLabel.text = aboutMe
                    aboutMeText = aboutMe
                } else {
                    cell.aboutMeLabel.text = ""
                }
            } else {
                cell.aboutMeLabel.text = aboutMeText
            }
            cell.aboutMeTF.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
            
        else if ID == "locationCell" {
            var c = tableView.dequeueReusableCellWithIdentifier(ID) as! LocationTVCell
            if c.editButton.enabled == true {
                c.editButton.alpha = 1
            } else {
                if (CLLocationManager.authorizationStatus() == .AuthorizedAlways) {
                    c.control.selectedSegmentIndex = 0
                } else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
                    c.control.selectedSegmentIndex = 1
                } else {
                    c.control.selectedSegmentIndex = 2
                }
                c.selectionStyle = UITableViewCellSelectionStyle.None
            }
            return c
        }
        
        else if ID == "tableCell" {
            var cell = tableView.dequeueReusableCellWithIdentifier(ID) as! TableTVCell
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
            let title = getTitleForPath(indexPath.section)
            cell.editButton.tag = indexPath.section
            cell.textField.delegate = self
            cell.textField.attributedPlaceholder = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName : UIColor.darkGrayColor()])
            let user = PFUser.currentUser()
            let attr = getTitleForPath(indexPath.section)
            
            if let val = user?.objectForKey(attr) as? String {
                cell.textField.attributedPlaceholder = NSAttributedString(string: val, attributes: [NSForegroundColorAttributeName : UIColor.darkGrayColor()])
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if ID == "ageCell" {
            var b = tableView.dequeueReusableCellWithIdentifier(ID) as! AgeTVCell
            b.selectionStyle = UITableViewCellSelectionStyle.None
            return b
        } else if ID == "privacyCell" {
            var b = tableView.dequeueReusableCellWithIdentifier(ID) as! UITableViewCell
            b.selectionStyle = UITableViewCellSelectionStyle.Blue
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
            c.selectionStyle = UITableViewCellSelectionStyle.None
            return c
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        registerNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
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
    
    func handleAbouMeNotification(notification: NSNotification) {
        /*
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
        */
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > 300 {
            return false
        }
        return true
    }
    
    func handleImageNotification(notification: NSNotification) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title:"Take Photo", style:UIAlertActionStyle.Default, handler:{ action in
            let type = UIImagePickerControllerSourceType.Camera
            self.presentPicker(type)
        }))
        actionSheet.addAction(UIAlertAction(title:"Photo Library", style:UIAlertActionStyle.Default, handler:{ action in
            let type = UIImagePickerControllerSourceType.PhotoLibrary
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
    
    func handleAboutMeNotification(notification: NSNotification) {
        editingAbout = !editingAbout
        if editingAbout == true {
            
        }
        table.beginUpdates()
        table.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let a = getTitleForPath(indexPath.section)
        if a == "Age" && editingAge == true {
            return 340
        } else if a == "Location" {
            return 90
        } else if a == "Profile Picture" {
            return 240
        } else if a == "Log Out" || a == "Privacy" {
            return 44
        } else if a == "About Me" && editingAbout == false {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("aboutMeCell") as! AboutMeTVCell
            let maxWidth = CGFloat(cell.aboutMeLabel.frame.width)
            let maxHeight = CGFloat(10000.0)
            let size = CGSizeMake(maxWidth, maxHeight)
            if let aboutMe = aboutMeText {
                
            } else {
                aboutMeText = ""
            }
            let frame = NSString(string: aboutMeText).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17)], context: nil)
            
            return frame.height + 40
            
        }
        return 44
    }
    
    func getTitleForPath(path : Int) -> String {
        switch path {
        case 0:
            return "Profile Picture"
        case 1:
            return "About Me"
        case 2:
            return "Name"
        case 3:
            return "Hometown"
        case 4:
            return "School"
        case 5:
            return "Occupation"
        case 6:
            return "Location"
        default:
            return ""
        }
    }
}
