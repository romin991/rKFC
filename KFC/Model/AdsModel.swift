//
//  AdsModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/20/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class AdsModel: NSObject {

    class func create(ads:Ads) -> Ads{
        
        let (_, cdImage) = ImageModel.create(ads.image!)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Ads", inManagedObjectContext:managedContext)
        let cdAds = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        ads.guid = NSUUID().UUIDString
        
        cdAds.setValue(ads.guid, forKey: "guid")
        cdAds.setValue(ads.id, forKey: "id")
        cdAds.setValue(ads.title, forKey: "title")
        cdAds.setValue(ads.message, forKey: "message")
        cdAds.setValue(ads.type, forKey: "type")
        cdAds.setValue(cdImage, forKey: "image")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return ads
    }
    
    class func getAdsType(type:String) -> [Ads] {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Ads")
        fetchRequest.predicate = NSPredicate(format: "type = %@", type)
        
        var adsList : [Ads] = [Ads]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdAdsList = results as! [NSManagedObject]
            for cdAds in cdAdsList{
                let cdImage = cdAds.valueForKey("image")
                
                let image = Image.init(
                    guid: cdImage?.valueForKey("guid") as? String,
                    imageURL: cdImage?.valueForKey("imageURL") as? String,
                    imagePath: cdImage?.valueForKey("imagePath") as? String,
                    imageDownloaded: cdImage?.valueForKey("imageDownloaded") as? Bool
                )
                
                let ads = Ads.init(
                    guid: (cdAds.valueForKey("guid") as? String),
                    id: (cdAds.valueForKey("id") as? String),
                    message: (cdAds.valueForKey("message") as? String),
                    title: (cdAds.valueForKey("title") as? String),
                    type: (cdAds.valueForKey("type") as? String),
                    image: image
                )
                
                adsList.append(ads)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return adsList
    }
    
    class func deleteAdsByType(type:String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Ads")
        fetchRequest.predicate = NSPredicate(format: "type = %@", type)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdAdsList = results as! [NSManagedObject]
            for cdAds in cdAdsList{
                managedContext.deleteObject(cdAds)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
