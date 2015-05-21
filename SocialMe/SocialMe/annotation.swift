//
//  annotation.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/26/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import MapKit

class annotation: NSObject, MKAnnotation {
    
    let title: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    var a: MKPinAnnotationView
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, a: MKPinAnnotationView) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        // a.image = UIImage(named: "contacts.png")
        // a.image = UIImage(named: "contacts.png")
        self.a = a
        super.init()
    }
    
    var subtitle: String {
        return locationName
    }
    
    
    var image: MKPinAnnotationView {
        return a
    }

}
