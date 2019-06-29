//
//  InterestingPlace.swift
//  InterestingPlaces
//
//  Created by Thomas Bouges on 2019-06-29.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import CoreLocation

class InterestingPlace {
    
    let location: CLLocation
    let name: String
    let imageName: String
    
    init(latitude: Double, longitude: Double, name:String, imageName: String) {
        
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.name = name
        self.imageName = imageName
    }
}
