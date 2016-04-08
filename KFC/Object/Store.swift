//
//  Store.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/24/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Store: NSObject {
    var code: String? = ""
    var name: String? = ""
    var id: String? = ""
    var long: String? = ""
    var lat: String? = ""
    var priceId: String? = ""
    
    var delivery: String? = ""
    var deliveryTax: String? = ""
    var tax: String? = ""
    var ppn: String? = ""
    
    init(code: String?, name: String?, id: String?, long: String?, lat: String?, priceId: String?, delivery:String?, deliveryTax:String?, tax:String?, ppn:String?) {
        self.code = code
        self.name = name
        self.id = id
        self.long = long
        self.lat = lat
        self.priceId = priceId
        
        self.delivery = delivery
        self.deliveryTax = deliveryTax
        self.tax = tax
        self.ppn = ppn
        
        super.init()
    }
    
    override init() {
        super.init()
    }
}
