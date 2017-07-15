//
//  BusinessAnnotation.swift
//  Yelp
//
//  Created by Nghia Nguyen on 7/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessAnnotation: NSObject, MKAnnotation {
    var business: Business
    var coordinate: CLLocationCoordinate2D { return business.getLocation()  }
    
    init(business: Business) {
        self.business = business
    }
    
    var title: String? {
        return business.name!
    }
}
