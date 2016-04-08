//
//  CartItem.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/15/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class CartItem: NSObject {

    var guid: String? = ""
    var cartGuid: String? = ""
    var productId: String? = ""
    var quantity: Int? = 0
    var price: String? = "0"
    var subtotal: String? = "0"
    var tax: String? = "0"
    var ppn: String? = "0"
    var total: String? = "0"
    
    var cartModifiers:[CartModifier] = [CartModifier]()
    var names : [Name] = [Name]()
    
    init(guid: String?, cartGuid:String?, productId:String?, quantity:Int?, price:String?, tax:String?, ppn:String?, subtotal:String?, total:String?) {
        self.guid = guid
        self.cartGuid = cartGuid
        self.productId = productId
        self.quantity = quantity
        self.price = price
        self.tax = tax
        self.ppn = ppn
        self.subtotal = subtotal
        self.total = total
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
