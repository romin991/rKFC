//
//  Address.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/25/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import GoogleMaps

class Address: NSObject {
    let address:String?
    let long:Double?
    let lat:Double?
    
    init(address: String, long: Double, lat: Double) {
        self.address = address
        self.long = long
        self.lat = lat
        super.init()
    }
}
