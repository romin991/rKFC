//
//  ProductModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class ProductModel: NSObject {

    class func create(product:Product) -> Product{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Product", inManagedObjectContext:managedContext)
        let cdProduct = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        product.guid = NSUUID().UUIDString
        
        cdProduct.setValue(product.guid, forKey: "guid")
        cdProduct.setValue(product.id, forKey: "id")
        cdProduct.setValue(product.categoryId, forKey: "categoryId")
        cdProduct.setValue(product.categoryGuid, forKey: "categoryGuid")
        cdProduct.setValue(product.image, forKey: "image")
        cdProduct.setValue(product.price, forKey: "price")
        cdProduct.setValue(product.taxable, forKey: "taxable")
        
        let setNames = cdProduct.mutableSetValueForKey("names")
        for name in product.names{
            
            name.guid = NSUUID().UUIDString
            name.refId = product.id
            name.refTable = Table.Product
            
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
        
        let setNotes = cdProduct.mutableSetValueForKey("notes")
        for note in product.notes{
            note.guid = NSUUID().UUIDString
            note.refId = product.id
            note.refTable = Table.Product
            
            let entityName =  NSEntityDescription.entityForName("Name", inManagedObjectContext:managedContext)
            let cdNote = NSManagedObject(entity: entityName!, insertIntoManagedObjectContext: managedContext)
            
            cdNote.setValue(note.guid, forKey: "guid")
            cdNote.setValue(note.languageId, forKey: "languageId")
            cdNote.setValue(note.name, forKey: "name")
            cdNote.setValue(note.refId, forKey: "refId")
            cdNote.setValue(note.refTable, forKey: "refTable")
            
            setNotes.addObject(cdNote)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return product
    }
    
    class func downloadAllProductImage(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Product")

        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdProducts = results as! [NSManagedObject]
            for cdProduct in cdProducts{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let imageURL = cdProduct.valueForKey("image") as? String
                    let filename = cdProduct.valueForKey("id") as? String
                    if (imageURL != nil && imageURL != "" && filename != nil && filename != "") {
                        let data = NSData.init(contentsOfURL: NSURL.init(string: imageURL!)!)
                        if (data != nil){
                            CommonFunction.saveData(data!, directory: Path.ProductImage, filename: filename!)
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.ImageItemDownloaded, object: nil)
                        })
                    }
                })
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    class func getProductByCartItem(cartItem:CartItem) -> Product{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id = %@", cartItem.productId!)
        
        var product : Product = Product.init()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdProducts = results as! [NSManagedObject]
            if (cdProducts.count != 0){
                let cdProduct = cdProducts.first!
                product = Product.init(
                    guid: (cdProduct.valueForKey("guid") as? String),
                    id: (cdProduct.valueForKey("id") as? String),
                    categoryId: (cdProduct.valueForKey("categoryId") as? String),
                    categoryGuid: (cdProduct.valueForKey("categoryGuid") as? String),
                    image: (cdProduct.valueForKey("image") as? String),
                    price: (cdProduct.valueForKey("price") as? String),
                    taxable: (cdProduct.valueForKey("taxable") as? Bool))
                
                let cdNames = cdProduct.mutableSetValueForKey("names")
                for cdName in cdNames{
                    let name = Name.init(
                        guid: (cdName.valueForKey("guid") as? String),
                        languageId: (cdName.valueForKey("languageId") as? String),
                        name: (cdName.valueForKey("name") as? String),
                        refId: (cdName.valueForKey("refId") as? String),
                        refGuid: (cdName.valueForKey("refGuid") as? String),
                        refTable: (cdName.valueForKey("refTable") as? String)
                    )
                    
                    product.names.append(name)
                }
                
                let cdNotes = cdProduct.mutableSetValueForKey("notes")
                for cdNote in cdNotes{
                    let note = Name.init(
                        guid: (cdNote.valueForKey("guid") as? String),
                        languageId: (cdNote.valueForKey("languageId") as? String),
                        name: (cdNote.valueForKey("name") as? String),
                        refId: (cdNote.valueForKey("refId") as? String),
                        refGuid: (cdNote.valueForKey("refGuid") as? String),
                        refTable: (cdNote.valueForKey("refTable") as? String)
                    )
                    
                    product.notes.append(note)
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return product
    }
    
    class func getProductByCategory(category:Category) -> [Product]{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "categoryId = %@", category.id!)
        
        var products : [Product] = [Product]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdProducts = results as! [NSManagedObject]
            for cdProduct in cdProducts{
                let product = Product.init(
                    guid: (cdProduct.valueForKey("guid") as? String),
                    id: (cdProduct.valueForKey("id") as? String),
                    categoryId: (cdProduct.valueForKey("categoryId") as? String),
                    categoryGuid: (cdProduct.valueForKey("categoryGuid") as? String),
                    image: (cdProduct.valueForKey("image") as? String),
                    price: (cdProduct.valueForKey("price") as? String),
                    taxable: (cdProduct.valueForKey("taxable") as? Bool))
                
                let cdNames = cdProduct.mutableSetValueForKey("names")
                for cdName in cdNames{
                    let name = Name.init(
                        guid: (cdName.valueForKey("guid") as? String),
                        languageId: (cdName.valueForKey("languageId") as? String),
                        name: (cdName.valueForKey("name") as? String),
                        refId: (cdName.valueForKey("refId") as? String),
                        refGuid: (cdName.valueForKey("refGuid") as? String),
                        refTable: (cdName.valueForKey("refTable") as? String)
                    )
                    
                    product.names.append(name)
                }
                
                let cdNotes = cdProduct.mutableSetValueForKey("notes")
                for cdNote in cdNotes{
                    let note = Name.init(
                        guid: (cdNote.valueForKey("guid") as? String),
                        languageId: (cdNote.valueForKey("languageId") as? String),
                        name: (cdNote.valueForKey("name") as? String),
                        refId: (cdNote.valueForKey("refId") as? String),
                        refGuid: (cdNote.valueForKey("refGuid") as? String),
                        refTable: (cdNote.valueForKey("refTable") as? String)
                    )
                    
                    product.notes.append(note)
                }
                
                products.append(product)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return products
        
    }
    
    class func deleteAllProduct() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Product")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdProducts = results as! [NSManagedObject]
            for cdProduct in cdProducts{
                let filename = cdProduct.valueForKey("id") as? String
                if (filename != nil && filename != "") {
                    CommonFunction.removeData(Path.ProductImage, filename: filename!)
                }
                managedContext.deleteObject(cdProduct)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
