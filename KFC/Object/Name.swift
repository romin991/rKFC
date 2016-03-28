//
//  Name.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/27/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class Name: NSObject {

    var guid : String? = ""
    var languageId : String? = ""
    var name : String? = ""
    var refId : String? = ""
    var refGuid : String? = ""
    var refTable : String? = ""
    
    init(guid:String?, languageId:String?, name:String?, refId:String?, refGuid:String?, refTable:String?){
        self.guid = guid
        self.name = name
        self.languageId = languageId
        self.refId = refId
        self.refGuid = refGuid
        self.refTable = refTable
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
