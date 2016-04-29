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
        cdCart.setValue(cart.deliveryTax, forKey: "deliveryTax")
        cdCart.setValue(cart.rounding, forKey: "rounding")
        cdCart.setValue(cart.ppn, forKey: "ppn")
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
        cdCart.setValue(cart.transId, forKey: "transId")
        cdCart.setValue(cart.transNo, forKey: "transNo")
        cdCart.setValue(cart.transDate, forKey: "transDate")
        cdCart.setValue(cart.paymentInfo, forKey: "paymentInfo")
        cdCart.setValue(cart.paymentSubInfo, forKey: "paymentSubInfo")
        cdCart.setValue(cart.statusDetail, forKey: "statusDetail")
        cdCart.setValue(cart.feedbackRating, forKey: "feedbackRating")
        cdCart.setValue(cart.feedbackAnswerId, forKey: "feedbackAnswerId")
        cdCart.setValue(cart.feedbackNotes, forKey: "feedbackNotes")
        
        let setItems = cdCart.mutableSetValueForKey("cartItems")
        for cartItem in cart.cartItems{
            //create cart item, and add to cart
            let entity =  NSEntityDescription.entityForName("CartItem", inManagedObjectContext:managedContext)
            let cdCartItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            cartItem.guid = NSUUID().UUIDString
            
            cdCartItem.setValue(cartItem.guid, forKey: "guid")
            cdCartItem.setValue(cart.guid, forKey: "cartGuid")
            cdCartItem.setValue(cartItem.productId, forKey: "productId")
            cdCartItem.setValue(cartItem.categoryId, forKey: "categoryId")
            cdCartItem.setValue(cartItem.quantity, forKey: "quantity")
            cdCartItem.setValue(cartItem.price, forKey: "price")
            cdCartItem.setValue(cartItem.tax, forKey: "tax")
            cdCartItem.setValue(cartItem.ppn, forKey: "ppn")
            cdCartItem.setValue(cartItem.subtotal, forKey: "subtotal")
            cdCartItem.setValue(cartItem.total, forKey: "total")
            
            let setNames = cdCartItem.mutableSetValueForKey("names")
            for name in cartItem.names{
                
                name.guid = NSUUID().UUIDString
                name.refGuid = cartItem.guid
                name.refTable = Table.CartItem
                
                let entityName =  NSEntityDescription.entityForName("Name", inManagedObjectContext:managedContext)
                let cdName = NSManagedObject(entity: entityName!, insertIntoManagedObjectContext: managedContext)
                
                cdName.setValue(name.guid, forKey: "guid")
                cdName.setValue(name.languageId, forKey: "languageId")
                cdName.setValue(name.name, forKey: "name")
                cdName.setValue(name.refId, forKey: "refId")
                cdName.setValue(name.refTable, forKey: "refTable")
                
                setNames.addObject(cdName)
            }
            
            let setModifiers = cdCartItem.mutableSetValueForKey("cartModifiers")
            for cartModifier in cartItem.cartModifiers{
                let entity =  NSEntityDescription.entityForName("CartModifier", inManagedObjectContext:managedContext)
                let cdCartModifier = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                cartModifier.guid = NSUUID().UUIDString
                
                cdCartModifier.setValue(cartModifier.guid, forKey: "guid")
                cdCartModifier.setValue(cart.guid, forKey: "cartGuid")
                cdCartModifier.setValue(cartItem.guid, forKey: "cartItemGuid")
                cdCartModifier.setValue(cartModifier.modifierId, forKey: "modifierId")
                cdCartModifier.setValue(cartModifier.modifierOptionId, forKey: "modifierOptionId")
                cdCartModifier.setValue(cartModifier.quantity, forKey: "quantity")
                
                let setNames = cdCartModifier.mutableSetValueForKey("names")
                for name in cartModifier.names{
                    
                    name.guid = NSUUID().UUIDString
                    name.refGuid = cartModifier.guid
                    name.refTable = Table.CartModifier
                    
                    let entityName =  NSEntityDescription.entityForName("Name", inManagedObjectContext:managedContext)
                    let cdName = NSManagedObject(entity: entityName!, insertIntoManagedObjectContext: managedContext)
                    
                    cdName.setValue(name.guid, forKey: "guid")
                    cdName.setValue(name.languageId, forKey: "languageId")
                    cdName.setValue(name.name, forKey: "name")
                    cdName.setValue(name.refId, forKey: "refId")
                    cdName.setValue(name.refTable, forKey: "refTable")
                    
                    setNames.addObject(cdName)
                }
                
                setModifiers.addObject(cdCartModifier)
            }
            
            setItems.addObject(cdCartItem)
        }
        
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
                
                cdCart.setValue(cart.customerId, forKey: "customerId")
                cdCart.setValue(cart.recipient, forKey: "recipient")
                cdCart.setValue(cart.notes, forKey: "notes")
                cdCart.setValue(cart.status, forKey: "status")
                cdCart.setValue(cart.customerAddressId, forKey: "customerAddressId")
                cdCart.setValue(cart.address, forKey: "address")
                cdCart.setValue(cart.addressDetail, forKey: "addressDetail")
                cdCart.setValue(cart.long, forKey: "long")
                cdCart.setValue(cart.lat, forKey: "lat")
                cdCart.setValue(cart.recipient, forKey: "recipient")
                cdCart.setValue(cart.transId, forKey: "transId")
                cdCart.setValue(cart.transNo, forKey: "transNo")
                cdCart.setValue(cart.transDate, forKey: "transDate")
                cdCart.setValue(cart.paymentInfo, forKey: "paymentInfo")
                cdCart.setValue(cart.paymentSubInfo, forKey: "paymentSubInfo")
                cdCart.setValue(cart.statusDetail, forKey: "statusDetail")
                cdCart.setValue(cart.feedbackRating, forKey: "feedbackRating")
                cdCart.setValue(cart.feedbackAnswerId, forKey: "feedbackAnswerId")
                cdCart.setValue(cart.feedbackNotes, forKey: "feedbackNotes")
                
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
                let store = StoreModel.getSelectedStore()
                
                let cdCart = cdCarts.first!
                let setItems = cdCart.mutableSetValueForKey("cartItems")
                let cartGuid = cdCart.valueForKey("guid") as? String
                
                let subtotalString = cdCart.valueForKey("subtotal") as? String
                let ppnString = cdCart.valueForKey("ppn") as? String
                let taxString = cdCart.valueForKey("tax") as? String
                var quantity = cdCart.valueForKey("quantity") as? Int
                
                let rounder = CommonFunction.getRounder()
                
                let subtotal = NSDecimalNumber.init(string:subtotalString).decimalNumberByAdding(NSDecimalNumber.init(string:cartItem.subtotal)).decimalNumberByRoundingAccordingToBehavior(rounder)
                let tax = NSDecimalNumber.init(string:taxString).decimalNumberByAdding(NSDecimalNumber.init(string:cartItem.tax)).decimalNumberByRoundingAccordingToBehavior(rounder)
                let ppn = NSDecimalNumber.init(string:ppnString).decimalNumberByAdding(NSDecimalNumber.init(string:cartItem.ppn)).decimalNumberByRoundingAccordingToBehavior(rounder)
                let delivery = NSDecimalNumber.init(string:store.delivery).decimalNumberByRoundingAccordingToBehavior(rounder)
                let deliveryTax = NSDecimalNumber.init(string:store.deliveryTax).decimalNumberByDividingBy(NSDecimalNumber.init(long: 100)).decimalNumberByMultiplyingBy(delivery).decimalNumberByRoundingAccordingToBehavior(rounder)
                var total = subtotal.decimalNumberByAdding(tax).decimalNumberByAdding(delivery).decimalNumberByAdding(ppn).decimalNumberByAdding(deliveryTax)
                
                let hundredRounder = NSDecimalNumberHandler.init(roundingMode: NSRoundingMode.RoundPlain, scale: -2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
                var rounding = total
                total = total.decimalNumberByRoundingAccordingToBehavior(hundredRounder)
                rounding = total.decimalNumberBySubtracting(rounding)
                
                quantity = quantity! + cartItem.quantity!
                
                cdCart.setValue(subtotal.stringValue, forKey: "subtotal")
                cdCart.setValue(tax.stringValue, forKey: "tax")
                cdCart.setValue(ppn.stringValue, forKey: "ppn")
                cdCart.setValue(delivery.stringValue, forKey: "delivery")
                cdCart.setValue(deliveryTax.stringValue, forKey: "deliveryTax")
                cdCart.setValue(rounding.stringValue, forKey: "rounding")
                cdCart.setValue(total.stringValue, forKey: "total")
                cdCart.setValue(quantity, forKey: "quantity")
                
                //create cart item, and add to cart
                let entity =  NSEntityDescription.entityForName("CartItem", inManagedObjectContext:managedContext)
                let cdCartItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                cartItem.guid = NSUUID().UUIDString
                
                cdCartItem.setValue(cartItem.guid, forKey: "guid")
                cdCartItem.setValue(cartGuid, forKey: "cartGuid")
                cdCartItem.setValue(cartItem.productId, forKey: "productId")
                cdCartItem.setValue(cartItem.categoryId, forKey: "categoryId")
                cdCartItem.setValue(cartItem.quantity, forKey: "quantity")
                cdCartItem.setValue(cartItem.price, forKey: "price")
                cdCartItem.setValue(cartItem.tax, forKey: "tax")
                cdCartItem.setValue(cartItem.ppn, forKey: "ppn")
                cdCartItem.setValue(cartItem.subtotal, forKey: "subtotal")
                cdCartItem.setValue(cartItem.total, forKey: "total")
                
                let setNames = cdCartItem.mutableSetValueForKey("names")
                for name in cartItem.names{
                    
                    name.guid = NSUUID().UUIDString
                    name.refGuid = cartItem.guid
                    name.refTable = Table.CartItem
                    
                    let entityName =  NSEntityDescription.entityForName("Name", inManagedObjectContext:managedContext)
                    let cdName = NSManagedObject(entity: entityName!, insertIntoManagedObjectContext: managedContext)
                    
                    cdName.setValue(name.guid, forKey: "guid")
                    cdName.setValue(name.languageId, forKey: "languageId")
                    cdName.setValue(name.name, forKey: "name")
                    cdName.setValue(name.refId, forKey: "refId")
                    cdName.setValue(name.refTable, forKey: "refTable")
                    
                    setNames.addObject(cdName)
                }
                
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
                    
                    let setNames = cdCartModifier.mutableSetValueForKey("names")
                    for name in cartModifier.names{
                        
                        name.guid = NSUUID().UUIDString
                        name.refGuid = cartModifier.guid
                        name.refTable = Table.CartModifier
                        
                        let entityName =  NSEntityDescription.entityForName("Name", inManagedObjectContext:managedContext)
                        let cdName = NSManagedObject(entity: entityName!, insertIntoManagedObjectContext: managedContext)
                        
                        cdName.setValue(name.guid, forKey: "guid")
                        cdName.setValue(name.languageId, forKey: "languageId")
                        cdName.setValue(name.name, forKey: "name")
                        cdName.setValue(name.refId, forKey: "refId")
                        cdName.setValue(name.refTable, forKey: "refTable")
                        
                        setNames.addObject(cdName)
                    }
                    
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
                let taxString = cdCart.valueForKey("tax") as? String
                let ppnString = cdCart.valueForKey("ppn") as? String
                let deliveryString = cdCart.valueForKey("delivery") as? String
                let deliveryTaxString = cdCart.valueForKey("deliveryTax") as? String
                var quantity = cdCart.valueForKey("quantity") as? Int
                
                let rounder = CommonFunction.getRounder()
                
                let subtotal = NSDecimalNumber.init(string:subtotalString).decimalNumberBySubtracting(NSDecimalNumber.init(string:cartItem.subtotal)).decimalNumberByRoundingAccordingToBehavior(rounder)
                let tax = NSDecimalNumber.init(string:taxString).decimalNumberBySubtracting(NSDecimalNumber.init(string:cartItem.tax)).decimalNumberByRoundingAccordingToBehavior(rounder)
                let ppn = NSDecimalNumber.init(string:ppnString).decimalNumberBySubtracting(NSDecimalNumber.init(string:cartItem.ppn)).decimalNumberByRoundingAccordingToBehavior(rounder)
                let delivery = NSDecimalNumber.init(string:deliveryString).decimalNumberByRoundingAccordingToBehavior(rounder)
                let deliveryTax = NSDecimalNumber.init(string:deliveryTaxString).decimalNumberByRoundingAccordingToBehavior(rounder)
                var total = subtotal.decimalNumberByAdding(tax).decimalNumberByAdding(delivery).decimalNumberByAdding(ppn).decimalNumberByAdding(deliveryTax)
                
                let hundredRounder = NSDecimalNumberHandler.init(roundingMode: NSRoundingMode.RoundPlain, scale: -2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
                var rounding = total
                total = total.decimalNumberByRoundingAccordingToBehavior(hundredRounder)
                rounding = total.decimalNumberBySubtracting(rounding)
                
                quantity = quantity! - cartItem.quantity!
                
                cdCart.setValue(subtotal.stringValue, forKey: "subtotal")
                cdCart.setValue(tax.stringValue, forKey: "tax")
                cdCart.setValue(delivery.stringValue, forKey: "delivery")
                cdCart.setValue(deliveryTax.stringValue, forKey: "deliveryTax")
                cdCart.setValue(tax.stringValue, forKey: "tax")
                cdCart.setValue(ppn.stringValue, forKey: "ppn")
                cdCart.setValue(rounding.stringValue, forKey: "rounding")
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
    
    class func isPendingCartNotEmpty() -> Bool{ //fast checking without return the data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "status = %@", Status.Pending)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            if (cdCarts.count > 0){
                let cdCart = cdCarts.first!
                if (cdCart.valueForKey("quantity") as? Int > 0) {
                    return true
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return false
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
                cart.deliveryTax = (cdCart.valueForKey("deliveryTax") as? String)!
                cart.ppn = (cdCart.valueForKey("ppn") as? String)!
                cart.subtotal = (cdCart.valueForKey("subtotal") as? String)!
                cart.tax = (cdCart.valueForKey("tax") as? String)!
                cart.delivery = (cdCart.valueForKey("delivery") as? String)!
                cart.rounding = (cdCart.valueForKey("rounding") as? String)!
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
                cart.transId = (cdCart.valueForKey("transId") as? String)!
                cart.transNo = (cdCart.valueForKey("transNo") as? String)!
                cart.transDate = (cdCart.valueForKey("transDate") as? NSDate)!
                cart.paymentInfo = (cdCart.valueForKey("paymentInfo") as? String)!
                cart.paymentSubInfo = (cdCart.valueForKey("paymentSubInfo") as? String)!
                cart.statusDetail = (cdCart.valueForKey("statusDetail") as? String)!
                cart.feedbackRating = (cdCart.valueForKey("feedbackRating") as? String)!
                cart.feedbackAnswerId = (cdCart.valueForKey("feedbackAnswerId") as? String)!
                cart.feedbackNotes = (cdCart.valueForKey("feedbackNotes") as? String)!
                
                let cdCartItems = cdCart.mutableSetValueForKey("cartItems")
                for cdCartItem in cdCartItems{
                    let cartItem = CartItem.init(
                        guid: (cdCartItem.valueForKey("guid") as? String)!,
                        cartGuid: (cdCartItem.valueForKey("cartGuid") as? String),
                        productId: (cdCartItem.valueForKey("productId") as? String),
                        categoryId: (cdCartItem.valueForKey("categoryId") as? String),
                        quantity: (cdCartItem.valueForKey("quantity") as? Int),
                        price: (cdCartItem.valueForKey("price") as? String),
                        tax: (cdCartItem.valueForKey("tax") as? String),
                        ppn: (cdCartItem.valueForKey("ppn") as? String),
                        subtotal: (cdCartItem.valueForKey("subtotal") as? String),
                        total: (cdCartItem.valueForKey("total") as? String)
                    )
                    
                    let cdNames = cdCartItem.mutableSetValueForKey("names")
                    for cdName in cdNames{
                        let name = Name.init(
                            guid: (cdName.valueForKey("guid") as? String),
                            languageId: (cdName.valueForKey("languageId") as? String),
                            name: (cdName.valueForKey("name") as? String),
                            refId: (cdName.valueForKey("refId") as? String),
                            refGuid: (cdName.valueForKey("refGuid") as? String),
                            refTable: (cdName.valueForKey("refTable") as? String)
                        )
                        
                        cartItem.names.append(name)
                    }
                    
                    let cdCartModifiers = cdCartItem.mutableSetValueForKey("cartModifiers")
                    for cdCartModifier in cdCartModifiers{
                        let cartModifier = CartModifier.init(
                            guid: (cdCartModifier.valueForKey("guid") as? String),
                            cartGuid: (cdCartModifier.valueForKey("cartGuid") as? String),
                            cartItemGuid: (cdCartModifier.valueForKey("cartItemGuid") as? String),
                            modifierId: (cdCartModifier.valueForKey("modifierId") as? String),
                            modifierOptionId: (cdCartModifier.valueForKey("modifierOptionId") as? String),
                            quantity: (cdCartModifier.valueForKey("quantity") as? Int)
                        )
                        
                        let cdNames = cdCartModifier.mutableSetValueForKey("names")
                        for cdName in cdNames{
                            let name = Name.init(
                                guid: (cdName.valueForKey("guid") as? String),
                                languageId: (cdName.valueForKey("languageId") as? String),
                                name: (cdName.valueForKey("name") as? String),
                                refId: (cdName.valueForKey("refId") as? String),
                                refGuid: (cdName.valueForKey("refGuid") as? String),
                                refTable: (cdName.valueForKey("refTable") as? String)
                            )
                            
                            cartModifier.names.append(name)
                        }
                        
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
    
    class func getAllInProgressCart() -> [Cart]{
        return self.getCartsWithPredicate(NSPredicate(format: "status != %@ && statusDetail != %@", Status.Pending, StatusDetail.Complete))
    }
    
    class func getAllCompletedCart() -> [Cart] {
        return self.getCartsWithPredicate(NSPredicate(format: "status != %@ && statusDetail == %@", Status.Pending, StatusDetail.Complete))
    }
    
    class func getCartsWithPredicate(predicate:NSPredicate) -> [Cart]{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = predicate
        
        let sorter = NSSortDescriptor.init(key: "transDate", ascending: false)
        fetchRequest.sortDescriptors = [sorter]
        
        var carts:[Cart] = [Cart]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdCarts = results as! [NSManagedObject]
            for cdCart in cdCarts{
                let cart = Cart.init(
                    guid: (cdCart.valueForKey("guid") as? String),
                    notes: (cdCart.valueForKey("notes") as? String),
                    status: (cdCart.valueForKey("status") as? String),
                    subtotal: (cdCart.valueForKey("subtotal") as? String),
                    ppn: (cdCart.valueForKey("ppn") as? String),
                    deliveryTax: (cdCart.valueForKey("deliveryTax") as? String),
                    rounding: (cdCart.valueForKey("rounding") as? String),
                    tax: (cdCart.valueForKey("tax") as? String),
                    delivery: (cdCart.valueForKey("delivery") as? String),
                    total: (cdCart.valueForKey("total") as? String),
                    customerId: (cdCart.valueForKey("customerId") as? String),
                    customerAddressId: (cdCart.valueForKey("customerAddressId") as? String),
                    storeId: (cdCart.valueForKey("storeId") as? String),
                    priceId: (cdCart.valueForKey("priceId") as? String),
                    quantity: (cdCart.valueForKey("quantity") as? Int),
                    address: (cdCart.valueForKey("address") as? String),
                    addressDetail: (cdCart.valueForKey("addressDetail") as? String),
                    long: (cdCart.valueForKey("long") as? Double),
                    lat: (cdCart.valueForKey("lat") as? Double),
                    recipient: (cdCart.valueForKey("recipient") as? String),
                    transId: (cdCart.valueForKey("transId") as? String),
                    transNo: (cdCart.valueForKey("transNo") as? String),
                    transDate: (cdCart.valueForKey("transDate") as? NSDate),
                    paymentInfo: (cdCart.valueForKey("paymentInfo") as? String),
                    paymentSubInfo: (cdCart.valueForKey("paymentSubInfo") as? String),
                    statusDetail: (cdCart.valueForKey("statusDetail") as? String),
                    feedbackRating: (cdCart.valueForKey("feedbackRating") as? String),
                    feedbackAnswerId: (cdCart.valueForKey("feedbackAnswerId") as? String),
                    feedbackNotes: (cdCart.valueForKey("feedbackNotes") as? String)
                )
                
                let cdCartItems = cdCart.mutableSetValueForKey("cartItems")
                for cdCartItem in cdCartItems{
                    let cartItem = CartItem.init(
                        guid: (cdCartItem.valueForKey("guid") as? String)!,
                        cartGuid: (cdCartItem.valueForKey("cartGuid") as? String),
                        productId: (cdCartItem.valueForKey("productId") as? String),
                        categoryId: (cdCartItem.valueForKey("categoryId") as? String),
                        quantity: (cdCartItem.valueForKey("quantity") as? Int),
                        price: (cdCartItem.valueForKey("price") as? String),
                        tax: (cdCartItem.valueForKey("tax") as? String),
                        ppn: (cdCartItem.valueForKey("ppn") as? String),
                        subtotal: (cdCartItem.valueForKey("subtotal") as? String),
                        total: (cdCartItem.valueForKey("total") as? String)
                    )
                    
                    let cdNames = cdCartItem.mutableSetValueForKey("names")
                    for cdName in cdNames{
                        let name = Name.init(
                            guid: (cdName.valueForKey("guid") as? String),
                            languageId: (cdName.valueForKey("languageId") as? String),
                            name: (cdName.valueForKey("name") as? String),
                            refId: (cdName.valueForKey("refId") as? String),
                            refGuid: (cdName.valueForKey("refGuid") as? String),
                            refTable: (cdName.valueForKey("refTable") as? String)
                        )
                        
                        cartItem.names.append(name)
                    }
                    
                    let cdCartModifiers = cdCartItem.mutableSetValueForKey("cartModifiers")
                    for cdCartModifier in cdCartModifiers{
                        let cartModifier = CartModifier.init(
                            guid: (cdCartModifier.valueForKey("guid") as? String),
                            cartGuid: (cdCartModifier.valueForKey("cartGuid") as? String),
                            cartItemGuid: (cdCartModifier.valueForKey("cartItemGuid") as? String),
                            modifierId: (cdCartModifier.valueForKey("modifierId") as? String),
                            modifierOptionId: (cdCartModifier.valueForKey("modifierOptionId") as? String),
                            quantity: (cdCartModifier.valueForKey("quantity") as? Int)
                        )
                        
                        let cdNames = cdCartModifier.mutableSetValueForKey("names")
                        for cdName in cdNames{
                            let name = Name.init(
                                guid: (cdName.valueForKey("guid") as? String),
                                languageId: (cdName.valueForKey("languageId") as? String),
                                name: (cdName.valueForKey("name") as? String),
                                refId: (cdName.valueForKey("refId") as? String),
                                refGuid: (cdName.valueForKey("refGuid") as? String),
                                refTable: (cdName.valueForKey("refTable") as? String)
                            )
                            
                            cartModifier.names.append(name)
                        }
                        
                        cartItem.cartModifiers.append(cartModifier)
                    }
                    
                    cart.cartItems.append(cartItem)
                }
                
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
    
    class func deleteAllNotPendingCart(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "status != %@", Status.Pending)
        
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
