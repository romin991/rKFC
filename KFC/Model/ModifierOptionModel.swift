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
        
        let setNames = cdModifierOption.mutableSetValueForKey("names")
        for name in modifierOption.names{
            
            name.guid = NSUUID().UUIDString
            name.refId = modifierOption.id
            name.refTable = Table.ModifierOption
            
            let entityName =  NSEntityDescription.entityForName("Name", inManagedObjectContext:managedContext)
            let cdName = NSManagedObject(entity: entityName!, insertIntoManagedObjectContext: managedContext)
            
            cdName.setValue(name.guid, forKey: "guid")
            cdName.setValue(name.languageId, forKey: "languageId")
            cdName.setValue(name.name, forKey: "name")
            cdName.setValue(name.refId, forKey: "refId")
            cdName.setValue(name.refGuid, forKey: "refGuid")
            cdName.setValue(name.refTable, forKey: "refTable")
            
            setNames.addObject(cdName)
        }
        
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
                    price: (cdModifierOption.valueForKey("price") as? String)
                )
                let cdNames = cdModifierOption.mutableSetValueForKey("names")
                for cdName in cdNames{
                    let name = Name.init(
                        guid: (cdName.valueForKey("guid") as? String),
                        languageId: (cdName.valueForKey("languageId") as? String),
                        name: (cdName.valueForKey("name") as? String),
                        refId: (cdName.valueForKey("refId") as? String),
                        refGuid: (cdName.valueForKey("refGuid") as? String),
                        refTable: (cdName.valueForKey("refTable") as? String)
                    )
                    
                    modifierOption.names.append(name)
                }
                
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
            try managedContext.save()
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
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
