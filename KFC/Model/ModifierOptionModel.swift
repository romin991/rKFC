//
//  ModifierOptionModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class ModifierOptionModel: NSObject {

    class func create(modifierOption:ModifierOption) -> ModifierOption{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("ModifierOption", inManagedObjectContext:managedContext)
        let cdModifierOption = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        modifierOption.guid = NSUUID().UUIDString
        
        cdModifierOption.setValue(modifierOption.guid, forKey: "guid")
        cdModifierOption.setValue(modifierOption.id, forKey: "id")
        cdModifierOption.setValue(modifierOption.code, forKey: "code")
        cdModifierOption.setValue(modifierOption.defaultSelect, forKey: "defaultSelect")
        cdModifierOption.setValue(modifierOption.image, forKey: "image")
        cdModifierOption.setValue(modifierOption.modifierId, forKey: "modifierId")
        cdModifierOption.setValue(modifierOption.modifierGuid, forKey: "modifierGuid")
        cdModifierOption.setValue(modifierOption.price, forKey: "price")
        cdModifierOption.setValue(modifierOption.name, forKey: "name")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return modifierOption
    }
    
    class func getModifierOption(modifier:Modifier) -> [ModifierOption]{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ModifierOption")
        fetchRequest.predicate = NSPredicate(format: "modifierId = %@", modifier.id!)
        
        var modifierOptions : [ModifierOption] = [ModifierOption]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdModifierOptions = results as! [NSManagedObject]
            for cdModifierOption in cdModifierOptions{
                let modifierOption = ModifierOption.init(
                    guid: (cdModifierOption.valueForKey("guid") as? String),
                    id: (cdModifierOption.valueForKey("id") as? String),
                    code: (cdModifierOption.valueForKey("code") as? String),
                    defaultSelect: (cdModifierOption.valueForKey("defaultSelect") as? Bool),
                    image: (cdModifierOption.valueForKey("image") as? String),
                    modifierId: (cdModifierOption.valueForKey("modifierId") as? String),
                    modifierGuid: (cdModifierOption.valueForKey("modifierGuid") as? String),
                    price: (cdModifierOption.valueForKey("price") as? String),
                    name: (cdModifierOption.valueForKey("name") as? String)
                )
                modifierOptions.append(modifierOption)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return modifierOptions
        
    }
    
    class func deleteAllModifierOption() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ModifierOption")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdModifierOptions = results as! [NSManagedObject]
            for cdModifierOption in cdModifierOptions{
                managedContext.deleteObject(cdModifierOption)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    class func deleteModifierOption(modifier:Modifier) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ModifierOption")
        fetchRequest.predicate = NSPredicate(format: "modifierId = %@", modifier.id!)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdModifierOptions = results as! [NSManagedObject]
            for cdModifierOption in cdModifierOptions{
                managedContext.deleteObject(cdModifierOption)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
