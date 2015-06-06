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
    
    
    var homeButtons = [UIButton]()
    var schoolButtons = [UIButton]()
    var occButtons = [UIButton]()
    
    
    @IBOutlet weak var lowerAge: UIPickerView!
    @IBOutlet weak var upperAge: UIPickerView!
    @IBOutlet weak var distanceValue: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var keySeg: UISegmentedControl!
    @IBOutlet weak var keyRemove: UIButton!
    @IBOutlet weak var keyCell: UIView!
    @IBOutlet var keyTVC: UITableViewCell!
    
  

    @IBOutlet var noContentLabel: UILabel!
    
    
    var pickerData = [18]
    
    @IBAction func valueDidChange(sender: UISlider) {
        var distance = Int(sender.value)
        distanceValue.text = "\(distance) ft"

    }
    
    func deleteKey(sender: UIButton) {
        println("Deleting key")
        println(sender.titleLabel!.text!)
        let user = PFUser.currentUser()
        let toRemove = sender.titleLabel!.text! as String
        var type = keySeg.titleForSegmentAtIndex(keySeg.selectedSegmentIndex)!
        var keywordQuery = PFQuery(className: "KeywordFilter")
        keywordQuery.whereKey("username", equalTo: user!.username!)
        var objectArr = keywordQuery.findObjects() as! [PFObject]
        if objectArr.count > 0 { // Username exists in keyword filters
            var keyObj = objectArr[0]
            //sender.removeFromSuperview()
            switch type {
            case "Hometown":
                if var filter = keyObj["homeFilter"] as? NSMutableArray {
                    if filter.containsObject(toRemove){
                        filter.removeObject(toRemove)
                        keyObj["homeFilter"] = filter
                        keyObj.save()
                    }
                }
            case "School":
                if var filter = keyObj["schoolFilter"] as? NSMutableArray {
                    if filter.containsObject(toRemove){
                        filter.removeObject(toRemove)
                        keyObj["schoolFilter"] = filter
                        keyObj.save()
                    }
                }
            case "Occupation":
                if var filter = keyObj["occFilter"] as? NSMutableArray {
                    if filter.containsObject(toRemove){
                        filter.removeObject(toRemove)
                        keyObj["occFilter"] = filter
                        keyObj.save()
                    }
                }
            default:
                    println("Error determining keyword filter type")
            }
            
            viewDidLoad()
        }
    

        
    }
    
    func makeButton(order: Double, label: NSString)->UIButton{
        println("creatingbutton")
        println(label)
        var button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        var posX = Double(noContentLabel.frame.origin.x)
        //let buttonWidth = (Double(self.keyCell.frame.size.width) / 3.0) - 20.0
        let buttonWidth = 100.0
        println(self.keyCell.frame.size.width)
        
        if order == 0.0 {
            noContentLabel.hidden = true
            
        } else {
            posX += order * (buttonWidth + 10)
            
        }
        
        button.frame = CGRectMake(CGFloat(posX), noContentLabel.frame.origin.y, CGFloat(buttonWidth), 30)
        //button.backgroundColor = UIColor.greenColor()
        button.setTitle(label as String, forState: UIControlState.Normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        //button.addTarget(self, action: "deleteKey:", forControlEvents: UIControlEvents.TouchDragExit)
        button.addTarget(self, action: "deleteKey:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }

    
    @IBAction func addKey(sender: UITextField) {
        let input = sender.text
        let type = self.keySeg.titleForSegmentAtIndex(self.keySeg.selectedSegmentIndex)!
        
        if input != "" {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                let user = PFUser.currentUser()
                var query = PFQuery(className: "KeywordFilter")
                query.whereKey("username", equalTo: user!.username!)
                var objectArr = query.findObjects() as! [PFObject]
            
                if objectArr.count > 0 { // Username in list
                    var keyObj = objectArr[0]
                    switch type {
                        case "Hometown":
                            if var filter = keyObj["homeFilter"] as? NSMutableArray { // Has already filtered by hometown
                                if !filter.containsObject(input) && filter.count <= 3 { // keyword not already in list
                                    filter.addObject(input)
                                    keyObj["homeFilter"] = filter
                                    keyObj.save()
                                } else if filter.count > 3 {
                                    let alert = UIAlertView(title: "Keyword Limit Reached", message: "Delete a keyword before adding a new one", delegate: nil, cancelButtonTitle: "OK")
                                    alert.show()
                                }
                            } else { // Has not previously filtered by hometown, create new array
                                var basic = NSMutableArray()
                                basic.addObject(input)
                                keyObj["homeFilter"] = basic
                                keyObj.save()

                            }
                            /*
                            var button = self.makeButton(Double(self.homeButtons.count), label: sender.text)
                            self.homeButtons.append(button)
                            self.keyCell.addSubview(button)
                            */
                            //self.homeButtons.append(self.makeButton(Double(self.homeButtons.count), label: sender.text))
                        case "School":
                            if var filter = keyObj["schoolFilter"] as? NSMutableArray { // Has already filtered by school
                                if !filter.containsObject(input) && filter.count <= 3 {
                                    filter.addObject(input)
                                    keyObj["schoolFilter"] = filter
                                    keyObj.save()
                                } else if filter.count > 3 {
                                    let alert = UIAlertView(title: "Keyword Limit Reached", message: "Delete a keyword before adding a new one", delegate: nil, cancelButtonTitle: "OK")
                                    alert.show()
                                }
                            } else {
                                var basic = NSMutableArray()
                                basic.addObject(input)
                                keyObj["schoolFilter"] = basic
                                keyObj.save()
                            }
                            //self.schoolButtons.append(self.makeButton(Double(self.schoolButtons.count), label: sender.text))
                        case "Occupation":
                            if var filter = keyObj["occFilter"] as? NSMutableArray { // Has already filttered by occupation
                                if !filter.containsObject(input) && filter.count <= 3 {
                                    filter.addObject(input)
                                    keyObj["occFilter"] = filter
                                    keyObj.save()
                                } else if filter.count > 3 {
                                    let alert = UIAlertView(title: "Keyword Limit Reached", message: "Delete a keyword before adding a new one", delegate: nil, cancelButtonTitle: "OK")
                                    alert.show()
                                }
                            } else {
                                var basic = NSMutableArray()
                                basic.addObject(input)
                                keyObj["occFilter"] = basic
                                keyObj.save()
                            }
                            //self.occButtons.append(self.makeButton(Double(self.occButtons.count), label: sender.text))
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
                
                }
                
                self.viewDidLoad()
            }
            
            sender.text = ""
        }

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
    
    @IBAction func switchKeySeg(sender: UISegmentedControl) {
        viewDidLoad()
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
        if keySeg.selectedSegmentIndex == -1 {
            keySeg.selectedSegmentIndex = 0
        }
        
        if var type = self.keySeg.titleForSegmentAtIndex(keySeg.selectedSegmentIndex) {
            var keywordQuery = PFQuery(className: "KeywordFilter")
            keywordQuery.whereKey("username", equalTo: user!.username!)
            var objectArr = keywordQuery.findObjects() as! [PFObject]
            if objectArr.count > 0 { // Username exists in keyword filters
                var keyObj = objectArr[0]
                for v in keyCell.subviews {
                    if v is UIButton {
                        v.removeFromSuperview()
                    }
                }
                switch type {
                case "Hometown":
                    if var filter = keyObj["homeFilter"] as? NSMutableArray {
                        noContentLabel.hidden = true
                        homeButtons.removeAll(keepCapacity: false)
                        
                        for keyword in filter {
                            println("Count is...")
                            println(Double(homeButtons.count))
                            var button = makeButton(Double(homeButtons.count), label: keyword as! NSString)
                            homeButtons.append(button)
                            self.keyCell.addSubview(button)
                        }
                        if homeButtons.count == 0 {
                            noContentLabel.hidden = false
                        }
                    } else {
                        noContentLabel.hidden = false
                    }
                case "School":
                    if var filter = keyObj["schoolFilter"] as? NSMutableArray {
                        noContentLabel.hidden = true
                        schoolButtons.removeAll(keepCapacity: false)
                        
                        for keyword in filter {
                            let button = makeButton(Double(schoolButtons.count), label: keyword as! NSString)
                            schoolButtons.append(button)
                            self.keyCell.addSubview(button)
                        }
                        if schoolButtons.count == 0 {
                            noContentLabel.hidden = false
                        }
                    } else {
                        noContentLabel.hidden = false
                    }
                case "Occupation":
                    if var filter = keyObj["occFilter"] as? NSMutableArray {
                        noContentLabel.hidden = true
                        occButtons.removeAll(keepCapacity: false)
                        for keyword in filter {
                            let button = makeButton(Double(occButtons.count), label: keyword as! NSString)
                            occButtons.append(button)
                            self.keyCell.addSubview(button)
                        }
                        if occButtons.count == 0 {
                            noContentLabel.hidden = false
                        }
                    } else {
                        noContentLabel.hidden = false
                    }
                default:
                    println("Error determining keyword filter type")
                }
            } else {
                noContentLabel.hidden = false
            }
        }
    

    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        handleSave()
    }
    
    
    
}
