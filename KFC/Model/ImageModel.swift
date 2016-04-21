//
//  ImageModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/20/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class ImageModel: NSObject {

    class func create(image:Image) -> (Image, NSManagedObject){
        
        let (savedImage, savedCDImage) = self.getImageByImageURL(image.imageURL!)
        if (savedImage != nil && savedCDImage != nil){
            return (savedImage!, savedCDImage!)
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Image", inManagedObjectContext:managedContext)
        let cdImage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        image.guid = NSUUID().UUIDString
        
        cdImage.setValue(image.guid, forKey: "guid")
        cdImage.setValue(image.imageURL, forKey: "imageURL")
        cdImage.setValue(image.imagePath, forKey: "imagePath")
        cdImage.setValue(image.imageDownloaded, forKey: "imageDownloaded")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return (image, cdImage)
    }
    
    class func downloadImage(){
        var images = [Image]()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            images = self.getUndownloadedImage()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                for image in images{
                    let imageURL = image.imageURL
                    let filename = image.guid
                    let imagePath = image.imagePath
                    
                    if (imageURL != nil && imageURL != "" && filename != nil && filename != "" && imagePath != nil && imagePath != "") {
                        let path = CommonFunction.generatePathAt(imagePath!, filename: filename!)
                        let data = NSFileManager.defaultManager().contentsAtPath(path)
                        if (data == nil) {
                            let data = NSData.init(contentsOfURL: NSURL.init(string: imageURL!)!)
                            if (data != nil){
                                CommonFunction.saveData(data!, directory: imagePath!, filename: filename!)
                                self.updateImage(imageURL!)
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if (imagePath == Path.AdsImage){
                                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.ImageAdsDownloaded, object: nil)
                            } else if (imagePath == Path.CategoryImage){
                                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.ImageCategoryDownloaded, object: nil)
                            } else if (imagePath == Path.ProductImage){
                                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.ImageItemDownloaded, object: nil)
                            } else if (imagePath == Path.PaymentImage){
                                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.ImagePaymentDownloaded, object: nil)
                            }
                        })
                    }
                }
            })
        }
    }
    
    class func updateImage(imageURL:String){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "imageURL = %@", imageURL)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdImages = results as! [NSManagedObject]
            if (cdImages.count > 0){
                let cdImage = cdImages.first!
                cdImage.setValue(true, forKey: "imageDownloaded")
                try cdImage.managedObjectContext?.save()
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    class func getUndownloadedImage() -> [Image]{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "imageDownloaded = false")
        
        var images = [Image]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdImages = results as! [NSManagedObject]
            for cdImage in cdImages{
                let image = Image.init(
                    guid: cdImage.valueForKey("guid") as? String,
                    imageURL: cdImage.valueForKey("imageURL") as? String,
                    imagePath: cdImage.valueForKey("imagePath") as? String,
                    imageDownloaded: cdImage.valueForKey("imageDownloaded") as? Bool
                )
                
                images.append(image)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return images
    }
    
    class func getImageByImageURL(imageURL:String) -> (Image?, NSManagedObject?) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "imageURL = %@", imageURL)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdImages = results as! [NSManagedObject]
            if (cdImages.count > 0){
                let cdImage = cdImages.first!
                let image = Image.init(
                    guid: cdImage.valueForKey("guid") as? String,
                    imageURL: cdImage.valueForKey("imageURL") as? String,
                    imagePath: cdImage.valueForKey("imagePath") as? String,
                    imageDownloaded: cdImage.valueForKey("imageDownloaded") as? Bool
                )
                
                return (image, cdImage)
            }
            
            return (nil, nil)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return (nil, nil)
    }
    
//    class func getAllImage() -> [Image] {
//        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        let fetchRequest = NSFetchRequest(entityName: "Image")
//        
//        var images : [Image] = [Image]()
//        
//        do {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            let cdImages = results as! [NSManagedObject]
//            for cdImage in cdImages{
//                let image = Image.init(
//                    guid: (cdImage.valueForKey("guid") as? String),
//                    imageURL: (cdImage.valueForKey("imageURL") as? String),
//                    imagePath: (cdImage.valueForKey("imagePath") as? String),
//                    imageDownloaded: (cdImage.valueForKey("imageDownloaded") as? Bool)
//                )
//                
//                images.append(image)
//            }
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        
//        return images
//    }
    
//    class func deleteImageByType(type:String){
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        let fetchRequest = NSFetchRequest(entityName: "Ads")
//        fetchRequest.predicate = NSPredicate(format: "type = %@", type)
//        
//        do {
//            let results = try managedContext.executeFetchRequest(fetchRequest)
//            let cdAdsList = results as! [NSManagedObject]
//            for cdAds in cdAdsList{
//                managedContext.deleteObject(cdAds)
//            }
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//    }
    
}
