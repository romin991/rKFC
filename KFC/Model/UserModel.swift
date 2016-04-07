//
//  UserModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/15/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class UserModel: NSObject {

    class func create(user:User) -> User{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("User", inManagedObjectContext:managedContext)
        let cdUser = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        user.guid = NSUUID().UUIDString
        
        cdUser.setValue(user.guid, forKey: "guid")
        cdUser.setValue(user.fullname, forKey: "fullname")
        cdUser.setValue(user.currentLong, forKey: "currentLong")
        cdUser.setValue(user.currentLat, forKey: "currentLat")
        cdUser.setValue(user.username, forKey: "username")
        cdUser.setValue(user.handphone, forKey: "handphone")
        cdUser.setValue(user.languageId, forKey: "languageId")
        cdUser.setValue(user.customerId, forKey: "customerId")
        cdUser.setValue(user.gender, forKey: "gender")
        cdUser.setValue(user.address, forKey: "address")
        cdUser.setValue(user.birthdate, forKey: "birthdate")
        
        let addresses:NSMutableSet = NSMutableSet()
        for address in user.addresses{
            let entity =  NSEntityDescription.entityForName("Address", inManagedObjectContext:managedContext)
            let cdAddress = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            address.guid = NSUUID().UUIDString
            cdAddress.setValue(address.guid, forKey: "guid")
            cdAddress.setValue(address.id, forKey: "id")
            cdAddress.setValue(address.address, forKey: "address")
            cdAddress.setValue(address.addressDetail, forKey: "addressDetail")
            cdAddress.setValue(address.long, forKey: "long")
            cdAddress.setValue(address.lat, forKey: "lat")
            cdAddress.setValue(address.recipient, forKey: "recipient")
            
            addresses.addObject(cdAddress)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return user
    }
    
    class func updateUser(user:User) -> User{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdUsers = (results as! [NSManagedObject])
            if (cdUsers.count == 0){
                return self.create(user)
                
            } else {
                let cdUser = cdUsers.first!
            
                cdUser.setValue(user.fullname, forKey: "fullname")
                cdUser.setValue(user.currentLong, forKey: "currentLong")
                cdUser.setValue(user.currentLat, forKey: "currentLat")
                cdUser.setValue(user.username, forKey: "username")
                cdUser.setValue(user.handphone, forKey: "handphone")
                cdUser.setValue(user.languageId, forKey: "languageId")
                cdUser.setValue(user.customerId, forKey: "customerId")
                cdUser.setValue(user.gender, forKey: "gender")
                cdUser.setValue(user.address, forKey: "address")
                cdUser.setValue(user.birthdate, forKey: "birthdate")
                
                let setAddresses = cdUser.mutableSetValueForKey("addresses")
                for address in user.addresses{
                    let entity =  NSEntityDescription.entityForName("Address", inManagedObjectContext:managedContext)
                    let cdAddress = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                    
                    address.guid = NSUUID().UUIDString
                    cdAddress.setValue(address.guid, forKey: "guid")
                    cdAddress.setValue(address.id, forKey: "id")
                    cdAddress.setValue(address.address, forKey: "address")
                    cdAddress.setValue(address.addressDetail, forKey: "addressDetail")
                    cdAddress.setValue(address.long, forKey: "long")
                    cdAddress.setValue(address.lat, forKey: "lat")
                    cdAddress.setValue(address.recipient, forKey: "recipient")
                    
                    setAddresses.addObject(cdAddress)
                }
                
                try managedContext.save()
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return user
    }
    
    class func getUser() -> User{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        var user : User = User.init()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdUsers = results as! [NSManagedObject]
            if (cdUsers.count != 0){
                let cdUser = cdUsers.first!
                user = User.init(
                    guid: (cdUser.valueForKey("guid") as? String)!,
                    fullname: (cdUser.valueForKey("fullname") as? String)!,
                    currentLong: (cdUser.valueForKey("currentLong") as? String)!,
                    currentLat: (cdUser.valueForKey("currentLat") as? String)!,
                    username: (cdUser.valueForKey("username") as? String)!,
                    handphone: (cdUser.valueForKey("handphone") as? String)!,
                    languageId: (cdUser.valueForKey("languageId") as? String)!,
                    customerId: (cdUser.valueForKey("customerId") as? String)!,
                    gender: (cdUser.valueForKey("gender") as? String)!,
                    address: (cdUser.valueForKey("address") as? String)!,
                    birthdate: (cdUser.valueForKey("birthdate") as? NSDate)!
                )
                
                let cdAddresses = cdUser.mutableSetValueForKey("addresses")
                for cdAddress in cdAddresses{
                    let address:Address = Address.init(
                        guid: (cdAddress.valueForKey("guid") as? String)!,
                        id: (cdAddress.valueForKey("id") as? String)!,
                        address: (cdAddress.valueForKey("address") as? String)!,
                        addressDetail: (cdAddress.valueForKey("addressDetail") as? String)!,
                        long: (cdAddress.valueForKey("long") as? Double)!,
                        lat: (cdAddress.valueForKey("lat") as? Double)!,
                        recipient: (cdAddress.valueForKey("recipient") as? String)!
                    )
                    user.addresses.append(address)
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return user
    }
    
    class func deleteAllUser(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdUsers = results as! [NSManagedObject]
            for cdUser in cdUsers{
                managedContext.deleteObject(cdUser)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
