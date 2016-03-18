//
//  Category.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Category: NSObject {
    var guid : String? = ""
    var id : String? = ""
    var name : String? = ""
    
    init(guid:String?, id:String?, name:String?){
        self.guid = guid
        self.name = name
        self.id = id
        
        super.init()
    }
    
    override init() {
        super.init()
    }
}
