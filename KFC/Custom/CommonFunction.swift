//
//  CommonFunction.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/8/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

class CommonFunction: NSObject {

    //MARK: save and load images
    class func generatePathAt(directory:String, filename:String) -> String{
        let directory:NSString = NSString.init(format: "/%@", directory)
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        var path = (documentsFolderPath as NSString).stringByAppendingPathComponent(directory as String)
        if (!NSFileManager.defaultManager().fileExistsAtPath(path)){
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        let filename:NSString = NSString.init(format: "/%@", filename)
        path = (path as NSString).stringByAppendingPathComponent(filename as String)
        
        return path
    }
    
    class func removeData(directory:String, filename:String){
        let path = CommonFunction.generatePathAt(directory, filename: filename)
        if (NSFileManager.defaultManager().fileExistsAtPath(path)){
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    class func saveData(data:NSData, directory:String, filename:String){
        let path = CommonFunction.generatePathAt(directory, filename: filename)
        data.writeToFile(path, atomically: true)
    }
    
    //MARK: format and unformat currency
    class func formatCurrency(decimalNumber:NSDecimalNumber) -> String{
        return formatCurrency(decimalNumber, showAsNegative: false)
    }
    
    class func formatCurrency(var decimalNumber:NSDecimalNumber, showAsNegative:Bool) -> String{
        let currencyFormatter = NSNumberFormatter.init()
        currencyFormatter.formatterBehavior = NSNumberFormatterBehavior.BehaviorDefault
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyDecimalSeparator = ","
        currencyFormatter.decimalSeparator = ","
        currencyFormatter.currencyGroupingSeparator = "."
        currencyFormatter.groupingSeparator = "."
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.currencySymbol = "Rp "
        currencyFormatter.roundingMode = NSNumberFormatterRoundingMode.RoundHalfUp
        currencyFormatter.negativePrefix = NSString.init(format: "(%@", currencyFormatter.currencySymbol) as String
        currencyFormatter.negativeSuffix = ")"
        if (showAsNegative == true){
            decimalNumber = decimalNumber.decimalNumberByMultiplyingBy(NSDecimalNumber.init(mantissa: 1, exponent: 0, isNegative: true))
        }
        let result = currencyFormatter.stringFromNumber(decimalNumber)
        return result != nil ? result! : ""
    }
    
    class func clearStringFromCurrency(unclearedString:String) -> String{
        return unclearedString .stringByReplacingOccurrencesOfString(".", withString: "")
            .stringByReplacingOccurrencesOfString(",", withString: "")
            .stringByReplacingOccurrencesOfString("Rp ", withString: "")
    }
    
    class func getRounder() -> NSDecimalNumberHandler {
        let round:NSDecimalNumberHandler = NSDecimalNumberHandler.init(roundingMode: NSRoundingMode.RoundPlain, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        return round
    }
    
    class func resizeImage(image:UIImage, size:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

