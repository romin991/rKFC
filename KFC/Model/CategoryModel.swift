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
        cdCategory.setValue(category.name, forKey: "name")
        
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
                    id: (cdCategory.valueForKey("id") as? String),
                    name: (cdCategory.valueForKey("name") as? String)
                )
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
