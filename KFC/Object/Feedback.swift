//
//  Feedback.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Feedback: NSObject {

    var guid : String? = ""
    var id : String? = ""
    var rating : String? = ""
    var questions : [Name] = [Name]()
    var answers : [Name] = [Name]()
    
    init(guid:String?, id:String?, rating:String?){
        self.guid = guid
        self.id = id
        self.rating = rating
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
