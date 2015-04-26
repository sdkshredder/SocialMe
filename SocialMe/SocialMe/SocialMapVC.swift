//
//  SocialMapVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/14/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import MapKit
import Parse
import CoreLocation

class SocialMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate {
    
    var mapView  = MKMapView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        initDisplay()
    }
    
    func initDisplay() {
        setupLocationManager()
        orientMapView()
        handleMap()
    }

    
    func setupNav() {
        var nav = navigationController!.navigationBar
        let a = UINavigationItem(title: "SocialMe")
        let b = UIBarButtonItem(image: UIImage(named: "contacts"), style: UIBarButtonItemStyle.Plain, target: self, action: "profileTap:")
        a.setLeftBarButtonItem(b, animated: false)
        nav.pushNavigationItem(a, animated: false)
    }
    
    func addNavProfile(nav : UINavigationBar) {
        let item = UINavigationItem()
        let a = UIBarButtonItem(image: UIImage(named: "contacts"), style: UIBarButtonItemStyle.Plain, target: self, action: "profileTap:")
        a.imageInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        item.setLeftBarButtonItem(a, animated: true)
        nav.pushNavigationItem(item, animated: true)
    }
    
    func addNavSettings(nav : UINavigationBar) {
        let settings = UIImageView(frame: CGRectMake(view.frame.width - 44, 2, 34, 34))
        settings.image = UIImage(named: "loading")
        addSettingsAction(settings)
        nav.addSubview(settings)
    }
    
    func addSettingsAction(settings : UIImageView) {
        settings.userInteractionEnabled = true
        settings.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "settingsTap:"))
    }
    
    func addProfileAction(profile : UIImageView) {
        profile.userInteractionEnabled = true
        profile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "profileTap:"))
    }
    
    func settingsTap(sender : UITapGestureRecognizer) {
        PFUser.logOut()
        let alert = UIAlertView(title: "Logout", message: "You have been logged out", delegate: self, cancelButtonTitle: "Continue")
        alert.show()
    }
    
    func presentMainVC () {
        let vc : UINavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func returnToMap(sender: UIButton) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        sender.removeFromSuperview()
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.mapView.frame.origin = CGPointMake(0, 0)
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.height - 49)
            }, completion: {
                (value: Bool) in
                
        })
    }
    
    func addMapReturnButton() {
        let returnButton = UIButton(frame: CGRectMake(0, view.frame.height - 50, view.frame.width, 50))
        returnButton.addTarget(self, action: "returnToMap:", forControlEvents: UIControlEvents.TouchUpInside)
        returnButton.backgroundColor = UIColor.clearColor()
        view.addSubview(returnButton)
    }
    
    @IBAction func showProfile(sender: UIBarButtonItem) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        addMapReturnButton()
        UIView.animateWithDuration(0.3, animations: {
            self.mapView.frame.origin = CGPointMake(0, self.view.frame.height - 50)
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.height)
        })
    }
        
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        presentMainVC()
    }
    
    func addNavTitle(nav : UINavigationBar) {
        let logo = UILabel(frame: CGRectMake(view.frame.width/2 - 80, 0, 160, 34))
        logo.font = UIFont(name: "HelveticaNeue-Light", size: 34)
        logo.textColor = UIColor.grayColor()
        logo.textAlignment = .Center
        logo.text = "SocialMe"
        nav.addSubview(logo)
    }
    
    func profileButtonTouched(sender: UIButton) {
        orientMapView()
    }

    func handleMap() {
        mapView.delegate = self
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        addLocationToggleToView(mapView)
        view.addSubview(mapView)
    }
    
    func orientMapView() {
        CLGeocoder().reverseGeocodeLocation(locationManager.location, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                println("Error: " + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.zoomToUserLocation(pm)
            }
        })
    }
    
    func zoomToUserLocation(placemark: CLPlacemark) {
        mapView.setRegion(MKCoordinateRegion(center: placemark.location.coordinate,
            span: MKCoordinateSpanMake(0.15, 0.15)), animated: true)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func addIconToToggle(toggle : UIVisualEffectView) {
        let icon = UIImageView(frame: CGRectMake(0, 0, toggle.frame.width, toggle.frame.height))
        icon.image = UIImage(named: "near-me")
        toggle.addSubview(icon)
    }
    
    func addLocationToggleToView(map : MKMapView) {
        let toggle = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        setFrameForToggle(toggle)
        addActionToToggle(toggle)
        addIconToToggle(toggle)
        map.addSubview(toggle)
    }
    
    func addActionToToggle(toggle : UIVisualEffectView) {
        var tap = UITapGestureRecognizer(target: self, action: "locationTap:")
        toggle.userInteractionEnabled = true
        toggle.addGestureRecognizer(tap)
    }
    
    func locationTap(sender : UITapGestureRecognizer) {
        orientMapView()
    }
    
    func setFrameForToggle(toggle : UIVisualEffectView) {
        var (width, height) = (view.frame.width, view.frame.height)
        toggle.frame = CGRectMake(width - 54, (height - (tabBarController?.tabBar.frame.height)! - 54), 44, 44);
        toggle.layer.borderColor = UIColor.grayColor().CGColor
        toggle.layer.cornerRadius = 22
        toggle.layer.borderWidth = 1
        toggle.clipsToBounds = true
    }
    
    /*
    func addBlur() {
        
        // 1 - http://www.raywenderlich.com/84043/ios-8-visual-effects-tutorial
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectDark = UIBlurEffect(style: .Dark)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        let blurViewTwo = UIVisualEffectView(effect: blurEffectDark)
        
        blurView.frame = CGRectMake(0, self.view.frame.height - 100, self.view.frame.width, 50)
        blurViewTwo.frame = CGRectMake(0, self.view.frame.height - 150, self.view.frame.width, 50)
        
        blurViewTwo.setTranslatesAutoresizingMaskIntoConstraints(false)
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(blurViewTwo)
        view.addSubview(blurView)
    }
    */
}
