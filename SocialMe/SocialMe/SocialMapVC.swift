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
    var thePeople : [PFUser]!
    
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
        var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("logLocation"), userInfo: nil, repeats: true)
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
        map.showsUserLocation = true
        map.frame = view.frame
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
                    println("success for user: \(user!.username)")
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
                self.thePeople = nearby
                self.plotPlaces(nearby)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomAnnotation) {
            return nil
        }
        let reuseId = "mapID"
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
        
        anView.leftCalloutAccessoryView = UIImageView(frame: CGRectMake(10, 10, 30, 30))
        anView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIButton
        anView.rightCalloutAccessoryView.tintColor = UIColor.darkGrayColor()
        
        return anView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        // performSegueWithIdentifier("profileSegue", sender: view)
        // println("yo yo yooo!")
        let vc = storyboard?.instantiateViewControllerWithIdentifier("profileVC") as! ProfileVC
        let b = view.annotation as! CustomAnnotation
        vc.username = b.username
        vc.navigationItem.title = b.username
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let a = sender as? MKAnnotationView {
            let b = a.annotation as! CustomAnnotation
            
            // let path = tableView.indexPathForCell(cell)
            let destination = segue.destinationViewController as! ProfileVC
            
            destination.username = b.username
            destination.navigationItem.title = b.username
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if let a = view.leftCalloutAccessoryView as? UIImageView {
            if let b = view.annotation as? CustomAnnotation {
                let c = thePeople[b.index]
                if let picFile = c.objectForKey("photo") as? PFFile {
                    picFile.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                let image = UIImage(data:imageData)
                                a.image = image
                                a.clipsToBounds = true
                                a.layer.cornerRadius = a.frame.height/2.0
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func plotPlaces(people: [PFUser]) {
        var annotations = [CustomAnnotation]()
        var index = 0
        for person in people {
            let location : PFGeoPoint = person["location"] as! PFGeoPoint
            let a = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let annotation = CustomAnnotation()
            annotation.title = person.username
            annotation.imageName = "smilez-0.png"
            annotation.index = index
            annotation.username = person.username! 
            if let occupation = person["Occupation"] as? String {
                annotation.subtitle = occupation
            }
            annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            annotations.append(annotation)
            index += 1
        }
        
        map.addAnnotations(annotations)
        map.showAnnotations(annotations, animated: true)

    }

    func presentMainVC () {
        let vc : UINavigationController = storyboard!.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
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
        })
    }
    
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
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        } else if type == "while" {
            if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
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
        self.map.setRegion(MKCoordinateRegion(center: placemark.location.coordinate,
            span: MKCoordinateSpanMake(0.005, 0.005)), animated: true)
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
}
