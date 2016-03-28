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
    var names : [Name] = [Name]()
    
    init(guid:String?, id:String?){
        self.guid = guid
        self.id = id
        
        super.init()
    }
    
    override init() {
        super.init()
    }
}
