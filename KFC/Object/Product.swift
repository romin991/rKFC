//
//  Product.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Product: NSObject {

    var guid : String? = ""
    var id : String? = ""
    var categoryId : String? = ""
    var categoryGuid : String? = ""
    var image : String? = ""
    var name : String? = ""
    var note : String? = ""
    var price : String? = "0"
    var taxable : Bool? = true
    
    var quantity : Int = 1 //for shoppingCart
    
    init(guid:String?, id:String?, categoryId:String?, categoryGuid:String?, image:String?, name:String?, note:String?, price:String?, taxable:Bool?){
        self.guid = guid
        self.id = id
        self.categoryId = categoryId
        self.categoryGuid = categoryGuid
        self.image = image
        self.name = name
        self.note = note
        self.price = price
        self.taxable = taxable
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
