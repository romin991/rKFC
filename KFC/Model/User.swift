//
//  User.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/15/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class User: NSObject {

    var guid: String? = ""
    var fullname: String? = ""      //name
    var currentLong: String? = ""
    var currentLat: String? = ""
    var username: String? = ""      //email
    var handphone: String? = ""     //phone
    var languageId: String? = ""
    var customerId: String? = ""
    
    var password: String? = ""
    var confirmPassword: String? = ""
    var type: String? = ""
    var addresses:[Address] = [Address]()
    
    init(guid: String?, fullname: String?, currentLong: String?, currentLat: String?, username: String?, handphone: String?, languageId: String?, customerId: String?) {
        self.guid = guid
        self.fullname = fullname
        self.currentLong = currentLong
        self.currentLat = currentLat
        self.username = username
        self.handphone = handphone
        self.languageId = languageId
        self.customerId = customerId
        
        super.init()
    }
    
    init(username: String?, fullname: String?, handphone: String?, password:String?, confirmPassword:String?, languageId: String?){
        self.username = username
        self.fullname = fullname
        self.handphone = handphone
        self.password = password
        self.confirmPassword = confirmPassword
        self.languageId = languageId
        
        super.init()
    }
    
    init(username:String?, password:String?, type:String?){
        self.username = username
        self.password = password
        self.type = type
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
