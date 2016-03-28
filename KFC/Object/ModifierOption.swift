//
//  ModifierOption.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class ModifierOption: NSObject {

    var guid : String? = ""
    var id : String? = ""
    var code : String? = ""
    var defaultSelect : Bool? = false
    var image : String? = ""
    var modifierId : String? = ""
    var modifierGuid : String? = ""
    var price : String? = "0"
    var names : [Name] = [Name]()
    
    var selected : Bool? = false
    var quantity : Int = 0 //for shoppingCart
    
    init(guid:String?, id:String?, code:String?, defaultSelect:Bool?, image:String?, modifierId:String?, modifierGuid:String?, price:String?){
        self.guid = guid
        self.id = id
        self.code = code
        self.defaultSelect = defaultSelect
        self.image = image
        self.modifierId = modifierId
        self.modifierGuid = modifierGuid
        self.price = price
        self.selected = defaultSelect
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
