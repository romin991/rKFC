//
//  ModifierModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class ModifierModel: NSObject {

    class func create(modifier:Modifier) -> Modifier{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let entity =  NSEntityDescription.entityForName("Modifier", inManagedObjectContext:managedContext)
        let cdModifier = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        modifier.guid = NSUUID().UUIDString
        
        cdModifier.setValue(modifier.guid, forKey: "guid")
        cdModifier.setValue(modifier.id, forKey: "id")
        cdModifier.setValue(modifier.amount, forKey: "amount")
        cdModifier.setValue(modifier.minimumSelect, forKey: "minimumSelect")
        cdModifier.setValue(modifier.maximumSelect, forKey: "maximumSelect")
        cdModifier.setValue(modifier.multipleSelect, forKey: "multipleSelect")
        cdModifier.setValue(modifier.name, forKey: "name")
        cdModifier.setValue(modifier.productId, forKey: "productId")
        cdModifier.setValue(modifier.productGuid, forKey: "productGuid")
        
//        for modifierOption in modifier.modifierOptions{
//            ModifierOptionModel.create(modifierOption)
//        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return modifier
    }
    
    class func getModifier(product:Product) -> [Modifier]{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Modifier")
        fetchRequest.predicate = NSPredicate(format: "productId = %@", product.id!)
        
        var modifiers : [Modifier] = [Modifier]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdModifiers = results as! [NSManagedObject]
            for cdModifier in cdModifiers{
                let modifier = Modifier.init(
                    guid: (cdModifier.valueForKey("guid") as? String),
                    id: (cdModifier.valueForKey("id") as? String),
                    amount: (cdModifier.valueForKey("amount") as? String),
                    minimumSelect: (cdModifier.valueForKey("minimumSelect") as? Int),
                    maximumSelect: (cdModifier.valueForKey("maximumSelect") as? Int),
                    multipleSelect: (cdModifier.valueForKey("multipleSelect") as? Bool),
                    name: (cdModifier.valueForKey("name") as? String),
                    productId: (cdModifier.valueForKey("productId") as? String),
                    productGuid: (cdModifier.valueForKey("productGuid") as? String),
                    modifierOptions: [ModifierOption]()
                )
                modifier.modifierOptions = ModifierOptionModel.getModifierOption(modifier)
                modifiers.append(modifier)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return modifiers
        
    }
    
    class func deleteAllModifier() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Modifier")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdModifiers = results as! [NSManagedObject]
            for cdModifier in cdModifiers{
                let modifier = Modifier.init(
                    guid: (cdModifier.valueForKey("guid") as? String),
                    id: (cdModifier.valueForKey("id") as? String),
                    amount: (cdModifier.valueForKey("amount") as? String),
                    minimumSelect: (cdModifier.valueForKey("minimumSelect") as? Int),
                    maximumSelect: (cdModifier.valueForKey("maximumSelect") as? Int),
                    multipleSelect: (cdModifier.valueForKey("multipleSelect") as? Bool),
                    name: (cdModifier.valueForKey("name") as? String),
                    productId: (cdModifier.valueForKey("productId") as? String),
                    productGuid: (cdModifier.valueForKey("productGuid") as? String),
                    modifierOptions: [ModifierOption]()
                )
                ModifierOptionModel.deleteModifierOption(modifier)
                managedContext.deleteObject(cdModifier)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    class func deleteModifier(product:Product){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Modifier")
        fetchRequest.predicate = NSPredicate(format: "productId = %@", product.id!)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdModifiers = results as! [NSManagedObject]
            for cdModifier in cdModifiers{
                let modifier = Modifier.init(
                    guid: (cdModifier.valueForKey("guid") as? String),
                    id: (cdModifier.valueForKey("id") as? String),
                    amount: (cdModifier.valueForKey("amount") as? String),
                    minimumSelect: (cdModifier.valueForKey("minimumSelect") as? Int),
                    maximumSelect: (cdModifier.valueForKey("maximumSelect") as? Int),
                    multipleSelect: (cdModifier.valueForKey("multipleSelect") as? Bool),
                    name: (cdModifier.valueForKey("name") as? String),
                    productId: (cdModifier.valueForKey("productId") as? String),
                    productGuid: (cdModifier.valueForKey("productGuid") as? String),
                    modifierOptions: [ModifierOption]()
                )
                ModifierOptionModel.deleteModifierOption(modifier)
                managedContext.deleteObject(cdModifier)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
