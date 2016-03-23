//
//  CartModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/15/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class CartModel: NSObject {

    class func create(cart:Cart) -> Cart{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Cart", inManagedObjectContext:managedContext)
        let cdCart = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        cart.guid = NSUUID().UUIDString
        
        cdCart.setValue(cart.guid, forKey: "guid")
        cdCart.setValue(cart.notes, forKey: "notes")
        cdCart.setValue(cart.status, forKey: "status")
        cdCart.setValue(cart.subtotal, forKey: "subtotal")
        cdCart.setValue(cart.tax, forKey: "tax")
        cdCart.setValue(cart.delivery, forKey: "delivery")
        cdCart.setValue(cart.total, forKey: "total")
        cdCart.setValue(cart.customerId, forKey: "customerId")
        cdCart.setValue(cart.customerAddressId, forKey: "customerAddressId")
        cdCart.setValue(cart.storeId, forKey: "storeId")
        cdCart.setValue(cart.priceId, forKey: "priceId")
        cdCart.setValue(cart.quantity, forKey: "quantity")
        cdCart.setValue(cart.address, forKey: "address")
        cdCart.setValue(cart.addressDetail, forKey: "addressDetail")
        cdCart.setValue(cart.long, forKey: "long")
        cdCart.setValue(cart.lat, forKey: "lat")
        cdCart.setValue(cart.recipient, forKey: "recipient")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return cart
    }
    
    class func update(cart:Cart) -> Cart{ //not all field will be update
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "status = %@", Status.Pending)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            if (cdCarts.count > 0){
                let cdCart = cdCarts.first!
                
                cdCart.setValue(cart.notes, forKey: "notes")
                cdCart.setValue(cart.status, forKey: "status")
                cdCart.setValue(cart.customerAddressId, forKey: "customerAddressId")
                cdCart.setValue(cart.address, forKey: "address")
                cdCart.setValue(cart.addressDetail, forKey: "addressDetail")
                cdCart.setValue(cart.long, forKey: "long")
                cdCart.setValue(cart.lat, forKey: "lat")
                cdCart.setValue(cart.recipient, forKey: "recipient")
                
                try cdCart.managedObjectContext?.save()
            }
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return cart
    }
    
    class func addCartItem(cartItem:CartItem){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "status = %@", Status.Pending)

        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            if (cdCarts.count > 0){
                let cdCart = cdCarts.first!
                let setItems = cdCart.mutableSetValueForKey("cartItems")
                let cartGuid = cdCart.valueForKey("guid") as? String
                
                let subtotalString = cdCart.valueForKey("subtotal") as? String
                let deliveryString = cdCart.valueForKey("delivery") as? String
                var quantity = cdCart.valueForKey("quantity") as? Int
                
                let subtotal = NSDecimalNumber.init(string:subtotalString).decimalNumberByAdding(NSDecimalNumber.init(string:cartItem.total))
                let tax = subtotal.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:10)).decimalNumberByDividingBy(NSDecimalNumber.init(integer:100))
                let delivery = NSDecimalNumber.init(string:deliveryString)
                let total = subtotal.decimalNumberByAdding(tax).decimalNumberByAdding(delivery)
                quantity = quantity! + cartItem.quantity!
                
                cdCart.setValue(subtotal.stringValue, forKey: "subtotal")
                cdCart.setValue(tax.stringValue, forKey: "tax")
                cdCart.setValue(delivery.stringValue, forKey: "delivery")
                cdCart.setValue(total.stringValue, forKey: "total")
                cdCart.setValue(quantity, forKey: "quantity")
                
                //create cart item, and add to cart
                let entity =  NSEntityDescription.entityForName("CartItem", inManagedObjectContext:managedContext)
                let cdCartItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                cartItem.guid = NSUUID().UUIDString
                
                cdCartItem.setValue(cartItem.guid, forKey: "guid")
                cdCartItem.setValue(cartGuid, forKey: "cartGuid")
                cdCartItem.setValue(cartItem.productId, forKey: "productId")
                cdCartItem.setValue(cartItem.quantity, forKey: "quantity")
                cdCartItem.setValue(cartItem.price, forKey: "price")
                cdCartItem.setValue(cartItem.name, forKey: "name")
                cdCartItem.setValue(cartItem.total, forKey: "total")
                
                let setModifiers = cdCartItem.mutableSetValueForKey("cartModifiers")
                for cartModifier in cartItem.cartModifiers{
                    let entity =  NSEntityDescription.entityForName("CartModifier", inManagedObjectContext:managedContext)
                    let cdCartModifier = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                    
                    cartModifier.guid = NSUUID().UUIDString
                    
                    cdCartModifier.setValue(cartModifier.guid, forKey: "guid")
                    cdCartModifier.setValue(cartGuid, forKey: "cartGuid")
                    cdCartModifier.setValue(cartItem.guid, forKey: "cartItemGuid")
                    cdCartModifier.setValue(cartModifier.modifierId, forKey: "modifierId")
                    cdCartModifier.setValue(cartModifier.modifierOptionId, forKey: "modifierOptionId")
                    cdCartModifier.setValue(cartModifier.quantity, forKey: "quantity")
                    cdCartModifier.setValue(cartModifier.name, forKey: "name")
                    
                    setModifiers.addObject(cdCartModifier)
                }
                
                setItems.addObject(cdCartItem)
                //end create cart item
                try cdCart.managedObjectContext?.save()
            }
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func removeCartItem(cartItem:CartItem){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "status = %@", Status.Pending)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            if (cdCarts.count > 0){
                let cdCart = cdCarts.first!
                let setItems = cdCart.mutableSetValueForKey("cartItems")
                
                let subtotalString = cdCart.valueForKey("subtotal") as? String
                let deliveryString = cdCart.valueForKey("delivery") as? String
                var quantity = cdCart.valueForKey("quantity") as? Int
                
                let subtotal = NSDecimalNumber.init(string:subtotalString).decimalNumberBySubtracting(NSDecimalNumber.init(string:cartItem.total))
                let tax = subtotal.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:10)).decimalNumberByDividingBy(NSDecimalNumber.init(integer:100))
                let delivery = NSDecimalNumber.init(string:deliveryString)
                let total = subtotal.decimalNumberByAdding(tax).decimalNumberByAdding(delivery)
                quantity = quantity! - cartItem.quantity!
                
                cdCart.setValue(subtotal.stringValue, forKey: "subtotal")
                cdCart.setValue(tax.stringValue, forKey: "tax")
                cdCart.setValue(delivery.stringValue, forKey: "delivery")
                cdCart.setValue(total.stringValue, forKey: "total")
                cdCart.setValue(quantity, forKey: "quantity")
                
                let predicate = NSPredicate.init(format: "guid != %@", cartItem.guid!)
                setItems.filterUsingPredicate(predicate)
                
                try cdCart.managedObjectContext?.save()
            }
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func getPendingCart() -> Cart{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "status = %@", Status.Pending)
        
        let cart:Cart = Cart.init()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            if (cdCarts.count > 0){
            let cdCart = cdCarts.first!
                cart.guid = (cdCart.valueForKey("guid") as? String)!
                cart.notes = (cdCart.valueForKey("notes") as? String)!
                cart.status = (cdCart.valueForKey("status") as? String)!
                cart.subtotal = (cdCart.valueForKey("subtotal") as? String)!
                cart.tax = (cdCart.valueForKey("tax") as? String)!
                cart.delivery = (cdCart.valueForKey("delivery") as? String)!
                cart.total = (cdCart.valueForKey("total") as? String)!
                cart.customerId = (cdCart.valueForKey("customerId") as? String)!
                cart.customerAddressId = (cdCart.valueForKey("customerAddressId") as? String)!
                cart.storeId = (cdCart.valueForKey("storeId") as? String)!
                cart.priceId = (cdCart.valueForKey("priceId") as? String)!
                cart.quantity = (cdCart.valueForKey("quantity") as? Int)!
                cart.address = (cdCart.valueForKey("address") as? String)!
                cart.addressDetail = (cdCart.valueForKey("addressDetail") as? String)!
                cart.long = (cdCart.valueForKey("long") as? Double)!
                cart.lat = (cdCart.valueForKey("lat") as? Double)!
                cart.recipient = (cdCart.valueForKey("recipient") as? String)!
                
                let cdCartItems = cdCart.mutableSetValueForKey("CartItems")
                for cdCartItem in cdCartItems{
                    let cartItem = CartItem.init(
                        guid: (cdCartItem.valueForKey("guid") as? String)!,
                        cartGuid: (cdCartItem.valueForKey("cartGuid") as? String)!,
                        productId: (cdCartItem.valueForKey("productId") as? String)!,
                        quantity: (cdCartItem.valueForKey("quantity") as? Int)!,
                        price: (cdCartItem.valueForKey("price") as? String)!,
                        name: (cdCartItem.valueForKey("name") as? String)!,
                        total: (cdCartItem.valueForKey("total") as? String)!
                    )
                    
                    let cdCartModifiers = cdCartItem.mutableSetValueForKey("cartModifiers")
                    for cdCartModifier in cdCartModifiers{
                        let cartModifier = CartModifier.init(
                            guid: (cdCartModifier.valueForKey("guid") as? String)!,
                            cartGuid: (cdCartModifier.valueForKey("cartGuid") as? String)!,
                            cartItemGuid: (cdCartModifier.valueForKey("cartItemGuid") as? String)!,
                            modifierId: (cdCartModifier.valueForKey("modifierId") as? String)!,
                            modifierOptionId: (cdCartModifier.valueForKey("modifierOptionId") as? String)!,
                            quantity: (cdCartModifier.valueForKey("quantity") as? Int)!,
                            name: (cdCartModifier.valueForKey("name") as? String)!
                        )
                        cartItem.cartModifiers.append(cartModifier)
                    }
                    
                    cart.cartItems.append(cartItem)
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return cart
    }
    
    class func getAllCart() -> [Cart] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        
        var carts:[Cart] = [Cart]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            for cdCart in cdCarts{
                let cart = Cart.init(
                    guid: (cdCart.valueForKey("guid") as? String)!,
                    notes: (cdCart.valueForKey("notes") as? String)!,
                    status: (cdCart.valueForKey("status") as? String)!,
                    subtotal: (cdCart.valueForKey("subtotal") as? String)!,
                    tax: (cdCart.valueForKey("tax") as? String)!,
                    delivery: (cdCart.valueForKey("delivery") as? String)!,
                    total: (cdCart.valueForKey("total") as? String)!,
                    customerId: (cdCart.valueForKey("customerId") as? String)!,
                    customerAddressId: (cdCart.valueForKey("customerAddressId") as? String)!,
                    storeId: (cdCart.valueForKey("storeId") as? String)!,
                    priceId: (cdCart.valueForKey("priceId") as? String)!,
                    quantity: (cdCart.valueForKey("quantity") as? Int)!,
                    address: (cdCart.valueForKey("address") as? String)!,
                    addressDetail: (cdCart.valueForKey("addressDetail") as? String)!,
                    long: (cdCart.valueForKey("long") as? Double)!,
                    lat: (cdCart.valueForKey("lat") as? Double)!,
                    recipient: (cdCart.valueForKey("recipient") as? String)!
                )
                carts.append(cart)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return carts
    }
    
    class func deletePendingCart(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "status = %@", Status.Pending)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            for cdCart in cdCarts{
                managedContext.deleteObject(cdCart)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    class func deleteAllCart(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            for cdCart in cdCarts{
                managedContext.deleteObject(cdCart)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
