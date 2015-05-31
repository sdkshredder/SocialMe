//
//  SettingsTVC.swift
//  SocialMe
//
//  Created by Mariam Ghanbari on 5/17/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class SettingsTVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var lowerAge: UIPickerView!
    @IBOutlet weak var upperAge: UIPickerView!
    @IBOutlet weak var distanceValue: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var keySeg: UISegmentedControl!
    @IBOutlet weak var keyRemove: UIButton!


    
    
    var pickerData = [18]
    
    @IBAction func valueDidChange(sender: UISlider) {
        var distance = Int(sender.value)
        distanceValue.text = "\(distance) ft"

    }
    
    @IBAction func addKey(sender: UITextField) {
        let input = sender.text
        let type = self.keySeg.titleForSegmentAtIndex(self.keySeg.selectedSegmentIndex)!
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let user = PFUser.currentUser()
            var query = PFQuery(className: "KeywordFilter")
            query.whereKey("username", equalTo: user!.username!)
            var objectArr = query.findObjects() as! [PFObject]
            /*
            if objectArr.count > 0 { // Username in list
                var keyObj = objectArr[0]
                switch type {
                    case "Hometown":
                        if var filter = keyObj["homeFilter"] as? NSMutableArray { // Has already filtered by hometown
                            if !filter.containsObject(input){ // keyword not already in list
                                filter.addObject(input)
                                keyObj["homeFilter"] = filter
                                keyObj.save()
                                println("added homefilter keywod")
                            }
                        } else { // Has not previously filtered by hometown, create new array
                            var basic = NSMutableArray()
                            basic.addObject(input)
                            keyObj["homeFilter"] = basic
                            keyObj.save()
                            println("made new homefilter")
                        }
                    case "School":
                        if var filter = keyObj["schoolFilter"] as? NSMutableArray { // Has already filtered by school
                            if !filter.containsObject(input){
                                filter.addObject(input)
                                keyObj["schoolFilter"] = filter
                                keyObj.save()
                            }
                        } else {
                            var basic = NSMutableArray()
                            basic.addObject(input)
                            keyObj["schoolFilter"] = basic
                            keyObj.save()
                        }
                    case "Occupation":
                        if var filter = keyObj["occFilter"] as? NSMutableArray { // Has already filttered by occupation
                            if !filter.containsObject(input){
                                filter.addObject(input)
                                keyObj["occFilter"] = filter
                                keyObj.save()
                            }
                        } else {
                            var basic = NSMutableArray()
                            basic.addObject(input)
                            keyObj["occFilter"] = basic
                            keyObj.save()
                        }
                    default:
                        println("No match" )
                    
                }
            
            } else { // Username not in list, create new row and add filter
                var newKey = PFObject(className: "KeywordFilter")
                newKey["username"] = user?.username
                var basic = NSMutableArray()
                basic.addObject(input)
                switch type {
                case "Hometown":
                    newKey["homeFilter"] = basic
                case "School":
                    newKey["schoolFilter"] = basic
                case "Occupation":
                    newKey["occFilter"] = basic
                default:
                    println("No match")
                }
                newKey.save()
                
            }*/
        }
        sender.text = ""
        
          /*
                if var basic = keyObj["basicFilter"] as? NSMutableArray {
                    if !basic.containsObject(input){
                        basic.addObject(input) 
                        keyObj["basicFilter"] = basic
                        keyObj.save()
                    }
                }
            } else {
                var newKey = PFObject(className: "KeywordFilter")
                newKey["username"] = user?.username
                var basic = NSMutableArray()
                basic.addObject(input)
                newKey["basicFilter"] = basic
                newKey.save()
            }
        }
        sender.text = ""
        */

    }

    
    
    @IBAction func segmentValueChange(sender: UISegmentedControl) {
    }

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let a = pickerData[row]
        return String(stringInterpolationSegment: a)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    
    
    func initData(){
        for index in 19...50 {
            pickerData.append(index)
        }
    }
   
    
    func handleSave(){
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            var change = 0
            let user = PFUser.currentUser()
            
            if Int(self.slider.value) != user?.objectForKey("distanceFilter") as! Int{
                user!.setObject(Int(self.slider.value), forKey:"distanceFilter")
                change = 1
            }
            if Int(self.lowerAge.selectedRowInComponent(0)) + 18 != user?.objectForKey("lowerAgeFilter") as! Int{
                user!.setObject(Int(self.lowerAge.selectedRowInComponent(0)) + 18, forKey:"lowerAgeFilter")
                change = 1
            }
            if Int(self.upperAge.selectedRowInComponent(0)) + 18 != user?.objectForKey("upperAgeFilter") as! Int{
                user!.setObject(Int(self.upperAge.selectedRowInComponent(0)) + 18, forKey:"upperAgeFilter")
                change = 1
            }
            
            if self.segment.titleForSegmentAtIndex(self.segment.selectedSegmentIndex) != user?.objectForKey("genderFilter") as? String{
                user!.setObject(self.segment.titleForSegmentAtIndex(self.segment.selectedSegmentIndex)!, forKey:"genderFilter")
                change = 1
            }
            
            if change == 1 {
                user?.save()
            }
            
        }
        
    }
    
    func back(sender: UIBarButtonItem) {
        if self.lowerAge.selectedRowInComponent(0) > self.upperAge.selectedRowInComponent(0){
            let alert = UIAlertView(title: "Invalid Age Range", message: "Lower age cannot be greater than Upper age", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        keyword.resignFirstResponder()
        keyword.endEditing(true)
        return false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton
        initData()
        let user = PFUser.currentUser()
        let distance = user?.objectForKey("distanceFilter") as! Int
        slider.value = Float(distance)
        distanceValue.text = "\(distance) ft"
        lowerAge.delegate = self
        lowerAge.dataSource = self
        lowerAge.selectRow((user?.objectForKey("lowerAgeFilter") as! Int) - 18, inComponent: 0, animated: true)
        upperAge.delegate = self
        upperAge.dataSource = self
        upperAge.selectRow((user?.objectForKey("upperAgeFilter") as! Int) - 18, inComponent: 0, animated: true)
        let gender = user?.objectForKey("genderFilter") as! String
        switch gender {
            case "Male":
                segment.selectedSegmentIndex = 0
            case "Female":
                segment.selectedSegmentIndex = 1
            default:
                segment.selectedSegmentIndex = 2
        }
        keyword.delegate = self
        keySeg.selectedSegmentIndex = 0
        

    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        handleSave()
    }
    
    
    
}
