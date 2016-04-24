//
//  CartModifier.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/15/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class CartModifier: NSObject {

    var guid: String? = ""
    var cartGuid:String? = ""
    var cartItemGuid: String? = ""
    var modifierId: String? = ""
    var modifierOptionId: String? = ""
    var quantity: Int? = 0
    var names : [Name] = [Name]()
    
    init(guid: String?, cartGuid:String?, cartItemGuid:String?, modifierId:String?, modifierOptionId:String?, quantity:Int?) {
        self.guid = guid
        self.cartGuid = cartGuid
        self.cartItemGuid = cartItemGuid
        self.modifierId = modifierId
        self.modifierOptionId = modifierOptionId
        self.quantity = quantity
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
