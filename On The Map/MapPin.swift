//
//  MapPin.swift
//  On The Map
//
//  Created by Nils Riebeling on 15.11.19.
//  Copyright © 2019 Nils Riebeling. All rights reserved.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var studentLocation: StudentLocation?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, studentLocation: StudentLocation) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.studentLocation = studentLocation
    }
    
    
}
