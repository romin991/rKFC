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
    var deliveryTax: String? = "0"
    var rounding: String? = "0"
    var ppn: String? = "0"
    
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
    
    var transId:String? = ""
    var transNo:String? = ""
    var transDate:NSDate? = NSDate()
    
    var paymentInfo:String? = ""
    var paymentSubInfo:String? = ""
    
    var cartItems: [CartItem] = [CartItem]()
    
    init(guid: String?, notes:String?, status:String?, subtotal:String?, ppn:String?, deliveryTax:String?, rounding:String?, tax:String?, delivery:String?, total:String?, customerId:String?, customerAddressId:String?, storeId:String?, priceId:String?, quantity:Int?, address:String?, addressDetail:String?, long:Double?, lat:Double?, recipient:String?, transId:String?, transNo:String?, transDate:NSDate?, paymentInfo:String?, paymentSubInfo:String?) {
        self.guid = guid
        self.notes = notes
        self.status = status
        self.subtotal = subtotal
        self.ppn = ppn
        self.deliveryTax = deliveryTax
        self.rounding = rounding
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
        self.transId = transId
        self.transNo = transNo
        self.transDate = transDate
        self.paymentInfo = paymentInfo
        self.paymentSubInfo = paymentSubInfo
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
