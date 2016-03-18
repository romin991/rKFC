//
//  Cart.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/15/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Cart: NSObject {
    
    var guid: String? = ""
    var notes: String? = ""
    var status: String? = ""
    var subtotal: String? = "0"
    var tax: String? = "0"
    var delivery: String? = "0"
    var total: String? = "0"
    
    var customerId: String? = ""
    var customerAddressId: String? = ""
    var storeId: String? = ""
    var priceId: String? = ""
    var quantity: Int? = 0
    
    var address:String? = ""
    var addressDetail:String? = ""
    var long:Double? = 0
    var lat:Double? = 0
    var recipient:String? = ""
    
    var cartItems: [CartItem] = [CartItem]()
    
    init(guid: String?, notes:String?, status:String?, subtotal:String?, tax:String?, delivery:String?, total:String?, customerId:String?, customerAddressId:String?, storeId:String?, priceId:String?, quantity:Int?, address:String?, addressDetail:String?, long:Double?, lat:Double?, recipient:String?) {
        self.guid = guid
        self.notes = notes
        self.status = status
        self.subtotal = subtotal
        self.tax = tax
        self.delivery = delivery
        self.total = total
        self.customerId = customerId
        self.customerAddressId = customerAddressId
        self.storeId = storeId
        self.priceId = priceId
        self.quantity = quantity
        self.address = address
        self.addressDetail = addressDetail
        self.long = long
        self.lat = lat
        self.recipient = recipient
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
