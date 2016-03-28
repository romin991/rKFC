//
//  CategoryModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class CategoryModel: NSObject {

    class func create(category:Category) -> Category{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let entity =  NSEntityDescription.entityForName("Category", inManagedObjectContext:managedContext)
        let cdCategory = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        category.guid = NSUUID().UUIDString
        
        cdCategory.setValue(category.guid, forKey: "guid")
        cdCategory.setValue(category.id, forKey: "id")
        
        let setNames = cdCategory.mutableSetValueForKey("names")
        for name in category.names{
        
            name.guid = NSUUID().UUIDString
            name.refId = category.id
            name.refTable = Table.Category
            
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
        
        return category
    }
    
    class func getAllCategory() -> [Category] {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        var categories : [Category] = [Category]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCategories = results as! [NSManagedObject]
            for cdCategory in cdCategories{
                let category = Category.init(
                    guid: (cdCategory.valueForKey("guid") as? String),
                    id: (cdCategory.valueForKey("id") as? String)
                )
                
                let cdNames = cdCategory.mutableSetValueForKey("names")
                for cdName in cdNames{
                    let name = Name.init(
                        guid: (cdName.valueForKey("guid") as? String),
                        languageId: (cdName.valueForKey("languageId") as? String),
                        name: (cdName.valueForKey("name") as? String),
                        refId: (cdName.valueForKey("refId") as? String),
                        refGuid: (cdName.valueForKey("refGuid") as? String),
                        refTable: (cdName.valueForKey("refTable") as? String)
                    )
                    
                    category.names.append(name)
                }

                categories.append(category)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return categories
    }
    
    class func deleteAllCategory(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCategories = results as! [NSManagedObject]
            for cdCategory in cdCategories{
                managedContext.deleteObject(cdCategory)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
