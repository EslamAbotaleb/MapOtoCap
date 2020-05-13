//
//  PinModel.swift
//  DrawRouteOnMapKit
//
//  Created by Islam Abotaleb on 5/13/20.
//  Copyright © 2020 Aman Aggarwal. All rights reserved.
//

import Foundation
import MapKit
class PinModel: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(pinTitle:String,  location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.coordinate = location
    }
}
