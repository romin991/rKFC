//
//  StoreModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/11/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class StoreModel: NSObject {

    class func save(store:Store) -> Store{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdUsers = (results as! [NSManagedObject])
            if (cdUsers.count != 0) {
                let cdUser = cdUsers.first!
                cdUser.setValue(store.id, forKey: "storeId")
                cdUser.setValue(store.code, forKey: "storeCode")
                cdUser.setValue(store.name, forKey: "storeName")
                cdUser.setValue(store.long, forKey: "storeLong")
                cdUser.setValue(store.lat, forKey: "storeLat")
                cdUser.setValue(store.priceId, forKey: "storePriceId")
                
                cdUser.setValue(store.deliveryTax, forKey: "storeDeliveryTax")
                cdUser.setValue(store.delivery, forKey: "storeDelivery")
                cdUser.setValue(store.ppn, forKey: "storePpn")
                cdUser.setValue(store.tax, forKey: "storeTax")
                cdUser.setValue(store.isBreakfast, forKey: "storeIsBreakfast")
                cdUser.setValue(store.breakfastStart, forKey: "storeBreakfastStart")
                cdUser.setValue(store.breakfastEnd, forKey: "storeBreakfastEnd")
            
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return store
    }
    
    class func getSelectedStore() -> Store{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        var store : Store = Store.init()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdUsers = (results as! [NSManagedObject])
            if (cdUsers.count != 0){
                let cdUser = cdUsers.first!
                store = Store.init(
                    code: (cdUser.valueForKey("storeCode") as? String),
                    name: (cdUser.valueForKey("storeName") as? String),
                    id: (cdUser.valueForKey("storeId") as? String),
                    long: (cdUser.valueForKey("storeLong") as? String),
                    lat: (cdUser.valueForKey("storeLat") as? String),
                    priceId: (cdUser.valueForKey("storePriceId") as? String),
                    delivery: (cdUser.valueForKey("storeDelivery") as? String),
                    deliveryTax: (cdUser.valueForKey("storeDeliveryTax") as? String),
                    tax: (cdUser.valueForKey("storeTax") as? String),
                    ppn: (cdUser.valueForKey("storePpn") as? String),
                    isBreakfast: (cdUser.valueForKey("storeIsBreakfast") as? Bool),
                    breakfastStart: (cdUser.valueForKey("storeBreakfastStart") as? String),
                    breakfastEnd: (cdUser.valueForKey("storeBreakfastEnd") as? String)
                )
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return store
    }
    
    class func deleteSelectedStore(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdUsers = (results as! [NSManagedObject])
            if (cdUsers.count != 0) {
                let cdUser = cdUsers.first!
                cdUser.setValue("", forKey: "storeId")
                cdUser.setValue("", forKey: "storeCode")
                cdUser.setValue("", forKey: "storeName")
                cdUser.setValue("", forKey: "storeLong")
                cdUser.setValue("", forKey: "storeLat")
                cdUser.setValue("", forKey: "storePriceId")
                cdUser.setValue("", forKey: "storeDelivery")
                cdUser.setValue("", forKey: "storeDeliveryTax")
                cdUser.setValue("", forKey: "storeTax")
                cdUser.setValue("", forKey: "storePpn")
                cdUser.setValue(true, forKey: "storeIsBreakfast")
                cdUser.setValue("", forKey: "storeBreakfastStart")
                cdUser.setValue("", forKey: "storeBreakfastEnd")
            
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
