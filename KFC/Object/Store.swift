//
//  Store.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/24/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Store: NSObject {
    let code: String
    let name: String
    let id: String
    let long: String
    let lat: String
    
    init(code: String, name: String, id: String, long: String, lat: String) {
        self.code = code
        self.name = name
        self.id = id
        self.long = long
        self.lat = lat
        
        super.init()
    }
}
