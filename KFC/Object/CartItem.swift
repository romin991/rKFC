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
    var name: String? = ""
    var total: String? = "0"
    
    var cartModifiers:[CartModifier] = [CartModifier]()
    
    init(guid: String?, cartGuid:String?, productId:String?, quantity:Int?, price:String?, name:String?, total:String?) {
        self.guid = guid
        self.cartGuid = cartGuid
        self.productId = productId
        self.quantity = quantity
        self.price = price
        self.name = name
        self.total = total
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
