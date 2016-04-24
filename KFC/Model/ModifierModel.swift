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
        cdModifier.setValue(modifier.productId, forKey: "productId")
        cdModifier.setValue(modifier.productGuid, forKey: "productGuid")
        
//        let setModifierOptions = cdModifier.mutableSetValueForKey("modifierOptions")
//        for modifierOption in modifier.modifierOptions{
//            
//            modifierOption.guid = NSUUID().UUIDString
//            modifierOption.modifierId = modifier.id
//            modifierOption.modifierGuid = modifier.guid
//            
//            let entityModifierOption =  NSEntityDescription.entityForName("ModifierOption", inManagedObjectContext:managedContext)
//            let cdModifierOption = NSManagedObject(entity: entityModifierOption!, insertIntoManagedObjectContext: managedContext)
//            
//            cdModifierOption.setValue(modifierOption.guid, forKey: "guid")
//            cdModifierOption.setValue(modifierOption.id, forKey: "id")
//            cdModifierOption.setValue(modifierOption.code, forKey: "code")
//            cdModifierOption.setValue(modifierOption.defaultSelect, forKey: "defaultSelect")
//            cdModifierOption.setValue(modifierOption.image, forKey: "image")
//            cdModifierOption.setValue(modifierOption.modifierId, forKey: "modifierId")
//            cdModifierOption.setValue(modifierOption.modifierGuid, forKey: "modifierGuid")
//            cdModifierOption.setValue(modifierOption.price, forKey: "price")
//            cdModifierOption.setValue(modifierOption.selected, forKey: "selected")
//            
//            setModifierOptions.addObject(cdModifierOption)
//        }
        
        let setNames = cdModifier.mutableSetValueForKey("names")
        for name in modifier.names{
            
            name.guid = NSUUID().UUIDString
            name.refId = modifier.id
            name.refTable = Table.Modifier
            
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
                    productId: (cdModifier.valueForKey("productId") as? String),
                    productGuid: (cdModifier.valueForKey("productGuid") as? String)
                )
                modifier.modifierOptions = ModifierOptionModel.getModifierOption(modifier)
                
                let cdNames = cdModifier.mutableSetValueForKey("names")
                for cdName in cdNames{
                    let name = Name.init(
                        guid: (cdName.valueForKey("guid") as? String),
                        languageId: (cdName.valueForKey("languageId") as? String),
                        name: (cdName.valueForKey("name") as? String),
                        refId: (cdName.valueForKey("refId") as? String),
                        refGuid: (cdName.valueForKey("refGuid") as? String),
                        refTable: (cdName.valueForKey("refTable") as? String)
                    )
                    
                    modifier.names.append(name)
                }
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
                    productId: (cdModifier.valueForKey("productId") as? String),
                    productGuid: (cdModifier.valueForKey("productGuid") as? String)
                )
                ModifierOptionModel.deleteModifierOption(modifier)
                managedContext.deleteObject(cdModifier)
            }
            try managedContext.save()
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
                    productId: (cdModifier.valueForKey("productId") as? String),
                    productGuid: (cdModifier.valueForKey("productGuid") as? String)
                )
                ModifierOptionModel.deleteModifierOption(modifier)
                managedContext.deleteObject(cdModifier)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
