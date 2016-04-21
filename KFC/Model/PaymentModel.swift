//
//  PaymentModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class PaymentModel: NSObject {

    class func create(payment:Payment) -> Payment{
        
        let (_, cdImage) = ImageModel.create(payment.image!)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Payment", inManagedObjectContext:managedContext)
        let cdPayment = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        payment.guid = NSUUID().UUIDString
        
        cdPayment.setValue(payment.guid, forKey: "guid")
        cdPayment.setValue(payment.paymentInfo, forKey: "paymentInfo")
        cdPayment.setValue(payment.paymentSubInfo, forKey: "paymentSubInfo")
        cdPayment.setValue(payment.name, forKey: "name")
        cdPayment.setValue(payment.successURL, forKey: "successURL")
        cdPayment.setValue(payment.failedURL, forKey: "failedURL")
        cdPayment.setValue(cdImage, forKey: "image")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return payment
    }
    
    class func getAllPayment() -> [Payment] {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        
        var paymentList : [Payment] = [Payment]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdPaymentList = results as! [NSManagedObject]
            for cdPayment in cdPaymentList{
                let cdImage = cdPayment.valueForKey("image")
                
                let image = Image.init(
                    guid: cdImage?.valueForKey("guid") as? String,
                    imageURL: cdImage?.valueForKey("imageURL") as? String,
                    imagePath: cdImage?.valueForKey("imagePath") as? String,
                    imageDownloaded: cdImage?.valueForKey("imageDownloaded") as? Bool
                )
                
                let payment = Payment.init(
                    guid: (cdPayment.valueForKey("guid") as? String),
                    paymentInfo: (cdPayment.valueForKey("paymentInfo") as? String),
                    paymentSubInfo: (cdPayment.valueForKey("paymentSubInfo") as? String),
                    name: (cdPayment.valueForKey("name") as? String),
                    image: image,
                    successURL: (cdPayment.valueForKey("successURL") as? String),
                    failedURL: (cdPayment.valueForKey("failedURL") as? String)
                )
                
                paymentList.append(payment)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return paymentList
    }
    
    class func deleteAllPayment(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdPaymentList = results as! [NSManagedObject]
            for cdPayment in cdPaymentList{
                managedContext.deleteObject(cdPayment)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
