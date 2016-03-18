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
    var guid:String? = ""
    var address:String? = ""
    var long:Double? = 0.0
    var lat:Double? = 0.0
    var id:String? = ""
    var addressDetail:String? = ""
    var recipient:String? = ""
    
    init(address:String?, addressDetail:String?, long:Double?, lat:Double?, recipient:String?){
        self.address = address
        self.addressDetail = addressDetail
        self.long = long
        self.lat = lat
        self.recipient = recipient
        
        super.init()
    }
    
    init(guid:String?, id:String?, address: String?, addressDetail:String?, long: Double?, lat: Double?, recipient: String?) {
        self.guid = guid
        self.id = id
        self.address = address
        self.addressDetail = addressDetail
        self.long = long
        self.lat = lat
        self.recipient = recipient
        
        super.init()
    }
}
