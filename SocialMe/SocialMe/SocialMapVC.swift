//
//  SocialMapVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/14/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SocialMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView  = MKMapView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.initDisplay()
    }
    
    func initDisplay() {
        self.setupLocationManager()
        self.addMap()
        self.addNavBar()
        orientMapView()
    }
    
    func addNavBar() {
        var navbar : UINavigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.width, 66))
        var profileButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "profileButtonTouched:")
        var circle : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "button"), style: UIBarButtonItemStyle.Plain,
            target: self, action: "profileButtonTouched:")
        circle.tintColor = UIColor.greenColor()
        
        var navItem : UINavigationItem = UINavigationItem()
        navItem.setLeftBarButtonItem(circle, animated: true)
        navbar.setItems([navItem], animated: true)
        self.view .addSubview(navbar)
    }
    
    @IBAction func profileButtonTouched(sender: UIButton) {
        self.orientMapView()
        self.addBlur()
    }
    
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
        
        self.view.addSubview(blurViewTwo)
        self.view.addSubview(blurView)
    }

    func addMap() {
        mapView.frame = self.view.frame
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
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
        
        var span = MKCoordinateSpanMake(0.15, 0.15)
        var region = MKCoordinateRegion(center: placemark.location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

}
