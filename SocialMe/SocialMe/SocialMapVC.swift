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

class SocialMapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var map = MKMapView()
    var hidden = false
    
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var arrow: UIVisualEffectView!
    
    @IBOutlet weak var zoomToggle: UIImageView!
    
    @IBAction func tooltipTap(sender: UITapGestureRecognizer) {
        orientMapView()
        rotateArrow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
        registerForNotification()
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("logLocation"), userInfo: nil, repeats: true)
        
        setupMap()
        styleDisplay()
        showPeopleNearby()
    }
    
    func styleDisplay() {
        arrow.layer.cornerRadius = arrow.frame.height / 2.0
    }
    
    func setupMap() {
        map.delegate = self
        map.setUserTrackingMode(.Follow, animated: true)
        map.frame = mapContainer.frame
        mapContainer.addSubview(map)
    }
    
    func registerForNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"returnAction:", name: "hideSettings", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"requestLocationUpdate:", name: "locationPreferences", object: nil)
    }
    
    
    func mapView(mapView: MKMapView!,
        regionDidChangeAnimated animated: Bool) {
    }
    
    func rotateArrow() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 0.2
        arrow.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    func getLocation() -> PFGeoPoint {
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        return PFGeoPoint(location: location)
    }
    
    func logLocation() {
        if PFUser.currentUser() != nil {
            let geoPoint = getLocation()
            let user = PFUser.currentUser()
            user!.setObject(geoPoint, forKey: "location")
            let now = NSDate().timeIntervalSince1970
            user!.setObject(now, forKey: "lastSeen")
            user!.saveInBackgroundWithBlock {
                (succeeded, error) -> Void in
                if error == nil {
                    println("success for user \(user!.username)")
                }
            }
        }
    }
    
    func showPeopleNearby() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let location : PFGeoPoint = self.getLocation()
            let query = PFUser.query()
            query!.whereKey("location", nearGeoPoint: location)
            let nearby = query!.findObjects() as! [PFUser]
            dispatch_async(dispatch_get_main_queue()) {
                self.plotPlaces(nearby)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomAnnotation) {
            return nil
        }
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        let cpa = annotation as! CustomAnnotation
        anView.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    private func plotPlaces(people: [PFUser]) {
        var annotations = [CustomAnnotation]()
        for person in people {
            let location : PFGeoPoint = person["location"] as! PFGeoPoint
            let a = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let annotation = CustomAnnotation()
            annotation.title = person.username
            annotation.imageName = "balloon.png"
            
            if let lastSeen : Double = person.objectForKey("lastSeen") as? Double {
                var date = NSDate(timeIntervalSince1970: lastSeen)
                var formatter = NSDateFormatter()
                formatter.dateStyle = .MediumStyle
                formatter.timeStyle = .MediumStyle
                let it = formatter.stringFromDate(date)
                annotation.subtitle = it
            }
            
            annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            annotations.append(annotation)

        }
        
        map.addAnnotations(annotations)
        map.showAnnotations(annotations, animated: true)

    }

    func presentMainVC () {
        let vc : UINavigationController = storyboard!.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        //let vc = navigationController!.viewControllers[0] as! UINavigationController
        //navigationController?.popToViewController(vc, animated: true)
        //navigationController?.popToViewController(navigationController!.viewControllers[2], animated: true)
        // navigationController?.popViewControllerAnimated(true)
        
        //popToRootViewControllerAnimated(true)
        
    }
    
    func returnToMap(sender: UIButton) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        sender.removeFromSuperview()
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.map.frame.origin = CGPointMake(0, 0)
            let tabFrame = self.tabBarController?.tabBar.frame
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.height - tabFrame!.height)
            }, completion: {
                (value: Bool) in
                self.hidden = false
                //self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    /*
    func addMapReturnButton() {
        let returnButton = UIButton(frame: CGRectMake(0, view.frame.height - 50, view.frame.width, 50))
        returnButton.addTarget(self, action: "returnToMap:", forControlEvents: UIControlEvents.TouchUpInside)
        returnButton.backgroundColor = UIColor.clearColor()
        view.addSubview(returnButton)
    }
*/
    
    
    @IBAction func returnTap(sender: UIButton) {
        returnAction(sender)
    }
    
    @IBAction func buttonSwipe(sender: UIButton) {
        returnAction(sender) 
    }
    
    
    @IBAction func showFilterPreferences(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("settings") as! SettingsTVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func showProfile(sender: UIBarButtonItem) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        UIView.animateWithDuration(0.3, animations: {
            self.mapContainer.frame.origin = CGPointMake(0, self.view.frame.height - 49)
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.height)
            self.arrow.alpha = 0
            self.mapContainer.alpha = 0.5
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(0.2, animations: {
                    self.returnButton.alpha = 1
                    self.hidden = true
                    //self.setNeedsStatusBarAppearanceUpdate()
                })
        })
        
    }
    
    func requestLocationUpdate(notification: NSNotification) {
        let info  = notification.userInfo as! [String: String]
        let type = info["pref"]
        if type == "always" {
            if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
                locationManager.startUpdatingLocation()
                locationManager.requestAlwaysAuthorization()
            }
        } else if type == "while" {
            if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
                locationManager.startUpdatingLocation()
                locationManager.requestWhenInUseAuthorization()
            }
            
        } else {
            //handle #TODO
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
    }
    
    func returnAction(sender: UIButton) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        hidden = false
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.mapContainer.frame.origin = CGPointMake(0, 0)
            self.returnButton.alpha = 0
            self.arrow.alpha = 1
            self.mapContainer.alpha = 1
            let tabFrame = self.tabBarController?.tabBar.frame
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.height - tabFrame!.height)
            }, completion: {
                (value: Bool) in
                
        })
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        presentMainVC()
    }
    
    func orientMapView() {
    }
    
    func zoomToUserLocation(placemark: CLPlacemark) {
        self.map.setRegion(MKCoordinateRegion(center: placemark.location.coordinate,
            span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
    }
    
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
    }
}
