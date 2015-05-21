//
//  SettingsTVC.swift
//  SocialMe
//
//  Created by Mariam Ghanbari on 5/17/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class SettingsTVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var lowerAge: UIPickerView!
    @IBOutlet weak var upperAge: UIPickerView!
    @IBOutlet weak var distanceValue: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var pickerData = [18]
    
    @IBAction func valueDidChange(sender: UISlider) {
        var current = Int(sender.value)
        current = 10
        distanceValue.text = String(format: "\(current) feet")
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
            let alert = UIAlertView(title: "Error", message: "Invalid settings", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    /*
    func action(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 1:
            println("Segment 1 selected")
        case 2:
            println("Segment 2 selected")
        case 3:
            println("Segment 3 selecteed")
        default:
            println("No segments")
        }
    }
    */

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton
        initData()
        distanceValue.text = "10 feet"
        slider.value = 10
        lowerAge.delegate = self
        lowerAge.dataSource = self
        upperAge.delegate = self
        upperAge.dataSource = self
        //segment.addTarget(self, action: "action:", forControlEvents: .ValueChanged)
        //segment.
        
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        handleSave()
    }
    
    
    
}