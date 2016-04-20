//
//  Image.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/20/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class Image: NSObject {

    var guid : String? = ""
    var imageURL : String? = ""
    var imagePath : String? = ""
    var imageDownloaded : Bool? = false
    
    init(guid:String?, imageURL:String?, imagePath:String?, imageDownloaded:Bool?){
        self.guid = guid
        self.imageURL = imageURL
        self.imagePath = imagePath
        self.imageDownloaded = imageDownloaded
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
}
