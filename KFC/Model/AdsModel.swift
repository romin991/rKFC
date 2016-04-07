//
//  AdsModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/3/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class AdsModel: NSObject {

    class func downloadAdsImages(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let adsURLs = appDelegate.adsURLs
            for adsURL in adsURLs{
                let imageURL = adsURL["url"]!
                let filename = adsURL["title"]!
                let data = NSData.init(contentsOfURL: NSURL.init(string: imageURL)!)
                if (data != nil){
                    CommonFunction.saveData(data!, directory: Path.AdsImage, filename: filename)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.ImageAdsDownloaded, object: nil)
                })

            }
        })
    }
    
}
