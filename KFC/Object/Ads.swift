//
//  Ads.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/20/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Ads: NSObject {

    var guid : String? = ""
    var id : String? = ""
    var message : String? = ""
    var title : String? = ""
    var type : String? = ""
    var image : Image? = Image()
    
    init(guid:String?, id:String?, message:String?, title:String?, type:String?, image:Image?){
        self.guid = guid
        self.id = id
        self.title = title
        self.message = message
        self.type = type
        self.image = image
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
