//
//  Payment.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Payment: NSObject {
    
    var guid : String? = ""
    var paymentInfo : String? = ""
    var paymentSubInfo : String? = ""
    var name : String? = ""
    var successURL : String? = ""
    var failedURL : String? = ""
    var image : Image? = Image()
    
    init(guid:String?, paymentInfo:String?, paymentSubInfo:String?, name:String?, image:Image?, successURL:String?, failedURL:String?){
        self.guid = guid
        self.paymentInfo = paymentInfo
        self.paymentSubInfo = paymentSubInfo
        self.name = name
        self.image = image
        self.successURL = successURL
        self.failedURL = failedURL
        
        super.init()
    }
    
    override init() {
        super.init()
    }

}
