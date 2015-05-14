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
    var hidden = false
    
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var arrow: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        setupLocationManager()
        setupDisplay()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"returnAction:", name: "hideSettings", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"requestLocationUpdate:", name: "locationPreferences", object: nil)
    }
    
    
    
    func setupDisplay() {
        logLocation()
        orientMapView()
        showPeopleNearby()
        arrow.layer.cornerRadius = 22
    }
    
    @IBOutlet weak var zoomToggle: UIImageView!
    
    @IBAction func tooltipTap(sender: UITapGestureRecognizer) {
        orientMapView()
        rotateArrow()
    }
    
    func mapView(mapView: MKMapView!,
        regionDidChangeAnimated animated: Bool) {
            if self.arrow.alpha == 0 {
                UIView.animateWithDuration(0.2, animations: {
                    self.arrow.alpha = 1
                })
            }
    }
    
    func rotateArrow() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 0.2
        arrow.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    func initDisplay() {
        setupLocationManager()
        logLocation()
    }
    
    func getLocation() -> PFGeoPoint {
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        return PFGeoPoint(location: location)
    }
    
    func logLocation() {
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
    
    func showPeopleNearby() {
        let location : PFGeoPoint = getLocation()
        let query = PFUser.query()
        query!.whereKey("location", nearGeoPoint: location)
        let nearby = query!.findObjects() as! [PFUser]
        plotPlaces(nearby)
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
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
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

            /*
            let artwork = annotation(title: "King David Kalakaua",
                locationName: "Waikiki Gateway Park",
                discipline: "Sculpture",
                coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            mapView.addAnnotation(artwork)
            */
        }
        
        map.addAnnotations(annotations)
        map.showAnnotations(annotations, animated: true)

    }

    func presentMainVC () {
        let vc : UINavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
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
                self.setNeedsStatusBarAppearanceUpdate()
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
        PFUser.logOut()
        let alert = UIAlertView(title: "Logout", message: "You have been logged out", delegate: self, cancelButtonTitle: "Continue")
        alert.show()
    }
    
    
    
    @IBAction func showProfile(sender: UIBarButtonItem) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        UIView.animateWithDuration(0.3, animations: {
            self.map.frame.origin = CGPointMake(0, self.view.frame.height)
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.height)
            self.arrow.alpha = 0
            self.map.alpha = 0.5
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(0.2, animations: {
                    self.returnButton.alpha = 1
                    self.hidden = true
                    self.setNeedsStatusBarAppearanceUpdate()
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
            //Deal with it.
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        /*
        if status == .Authorized || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            // ...
        }
*/
    }
    
    func returnAction(sender: UIButton) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        hidden = false
        setNeedsStatusBarAppearanceUpdate()
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.map.frame.origin = CGPointMake(0, 0)
            self.returnButton.alpha = 0
            self.arrow.alpha = 1
            self.map.alpha = 1
            let tabFrame = self.tabBarController?.tabBar.frame
            self.tabBarController?.tabBar.frame.origin = CGPointMake(0, self.view.frame.height - tabFrame!.height)
            }, completion: {
                (value: Bool) in
                
        })
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        presentMainVC()
    }


    func handleMap() {
        /*
        mapView.delegate = self
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        addLocationToggleToView(mapView)
        view.addSubview(mapView)
        */
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
            span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return hidden
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Fade
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
