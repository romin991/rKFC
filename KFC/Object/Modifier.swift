//
//  Modifier.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Modifier: NSObject {

    var guid : String? = ""
    var id : String? = ""
    var amount : String? = ""
    var minimumSelect : Int? = 0
    var maximumSelect : Int? = 0
    var multipleSelect : Bool? = false
    var productId : String? = ""
    var productGuid : String? = ""
    var modifierOptions : [ModifierOption] = [ModifierOption]()
    var names : [Name] = [Name]()
    
    var status : String = ""
    
    init(guid:String?, id:String?, amount:String?, minimumSelect:Int?, maximumSelect:Int?, multipleSelect:Bool?, productId:String?, productGuid:String?){
        self.guid = guid
        self.id = id
        self.amount = amount
        self.minimumSelect = minimumSelect
        self.maximumSelect = maximumSelect
        self.multipleSelect = multipleSelect
        self.productId = productId
        self.productGuid = productGuid
        
        self.status = Status.Valid
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
