//
//  LoginModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/24/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginModel: NSObject {
    
    class func register(user:User, completion: (status: String, message: String, user:User? ) -> Void){
        
        let parameters:[String:AnyObject] = [
            "language_id": user.languageId!,
            "fullname" : user.fullname!,
            "handphone" : user.handphone!,
            "email" : user.username!,
            "password" : user.password!,
            "confirm_password" : user.confirmPassword!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/Register", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            completion(status: Status.Success, message: message, user: user)
                        } else {
                            completion(status: Status.Error, message: message, user: nil)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", user: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, user: nil)
                    break;
                }
                
        }
    }
    
    class func validate(user:User, completion: (status: String, message: String) -> Void){
        
        let parameters:[String:AnyObject] = [
            "email" : user.username!,
            "verification_code" : user.verificationCode!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/VerifyRegistrant", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid json object"
                        
                        if (status == "T"){
                            completion(status: Status.Success, message: message)
                        } else {
                            completion(status: Status.Error, message: message)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object")
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription)
                    break;
                }
                
        }
    }
    
    class func forgotPassword(email:String, completion: (status: String, message: String) -> Void){
        
        let parameters:[String:AnyObject] = [
            "email" : email
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/ForgotPassword", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            completion(status: Status.Success, message: message)
                        } else {
                            completion(status: Status.Error, message: message)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object")
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription)
                    break;
                }
                
        }
    }

    class func login(user:User, completion: (status: String?, message: String?, user:User?) -> Void){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let parameters:[String:AnyObject] = [
            "type" : user.type!,
            "value" : user.username!,
            "password" : user.password!,
            "source" : "IOS",
            "registration_id" : appDelegate.token ?? ""
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/Login", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            var user:User = User.init()
                            user.customerId = json["customer"]["customer_id"].string
                            user.languageId = json["customer"]["language_id"].string
                            user.fullname = json["customer"]["fullname"].string
                            user.handphone = json["customer"]["handphone"].string
                            user.username = json["customer"]["email"].string
                            
                            let cart = CartModel.getPendingCart()
                            cart.customerId = user.customerId
                            cart.recipient = user.fullname
                            CartModel.update(cart)
                            
                            self.getAddressList(user, completion: { (status, message, addresses) -> Void in
                                if (status == Status.Success){
                                    user.addresses = addresses!
                                    user = UserModel.updateUser(user)
                                    
                                    NSUserDefaults.standardUserDefaults().setObject(user.languageId, forKey: "LanguageId")
                                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.LanguageChanged, object: nil)
                                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.Login, object: nil)
                                    
                                    completion(status: Status.Success, message: message, user:user)
                                } else {
                                    completion(status: Status.Error, message: message, user: nil)
                                }
                            })
                        } else {
                            completion(status: Status.Error, message: message, user:nil)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", user:nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, user:nil)
                    break;
                }
                
        }
    }
    
    class func loginWithFacebook(){
        
    }
    
    class func getAddressList(user:User, completion: (status: String, message:String, addresses:[Address]?) -> Void){
        let parameters : [String:AnyObject] = [
            "customer_id" : user.customerId!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/GetAddressList", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            var addresses: [Address] = [Address]()
                            let addressesJSON = json["address"].array ?? []
                            for addressJSON in addressesJSON{
                                let address:Address = Address.init(
                                    guid: nil,
                                    id: addressJSON["id"].string,
                                    address: addressJSON["address"].string,
                                    addressDetail: addressJSON["address_detail"].string,
                                    long: Double(addressJSON["lng"].string ?? "0"),
                                    lat: Double(addressJSON["lat"].string ?? "0"),
                                    recipient: addressJSON["recipient"].string,
                                    favorite: addressJSON["is_favorite"].string == "1" ? true: false
                                )
                                
                                addresses.append(address)
                            }
                            
                            completion(status: Status.Success, message: message, addresses: addresses)
                        } else {
                            completion(status: Status.Error, message: message, addresses: nil)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", addresses: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, addresses: nil)
                    break;
                }
                
        }
    }
    
    class func addFavoriteAddress(address:Address, completion: (status: String, message:String) -> Void){
        let parameters : [String:AnyObject] = [
            "customer_address_id" : address.id!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/AddFavoriteAddress", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            completion(status: Status.Success, message: message)
                        } else {
                            completion(status: Status.Error, message: message)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object")
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription)
                    break;
                }
                
        }
    }
    
    class func logout(user:User, completion: (status: String?, message: String?) -> Void){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let parameters : [String:AnyObject] = [
            "customer_id" : user.customerId!,
            "source" : "IOS",
            "registration_id" : appDelegate.token ?? "-"
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/Logout", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            CategoryModel.deleteAllCategory()
                            ProductModel.deleteAllProduct()
                            ModifierModel.deleteAllModifier()
                            ModifierOptionModel.deleteAllModifierOption()
                            CartModel.deleteAllNotPendingCart()
                            CartModel.deletePendingCart()
                            UserModel.deleteAllUser()
                            
                            completion(status: Status.Success, message: message)
                        } else {
                            completion(status: Status.Error, message: message)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object")
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription)
                    break;
                }
                
        }
    }
    
    class func getProfile(user:User, completion: (status: String, message:String, user:User?) -> Void){
        let parameters : [String:AnyObject] = [
            "customer_id" : user.customerId!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/GetProfile", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            let user:User = UserModel.getUser()
                            let customerJSON = json["customer"]
                            
                            let dateformatter = NSDateFormatter.init()
                            dateformatter.dateFormat = "yyyy-MM-dd"
                            
                            user.fullname = customerJSON["fullname"].string
                            user.handphone = customerJSON["handphone"].string
                            user.birthdate = dateformatter.dateFromString(customerJSON["birthdate"].string ?? "")
                            user.username = customerJSON["email"].string
                            user.languageId = customerJSON["language_id"].string
                            user.gender = customerJSON["gender"].string == "M" ? Wording.Gender.Male[user.languageId!] : Wording.Gender.Female[user.languageId!]
                            UserModel.updateUser(user)
                            
                            completion(status: Status.Success, message: message, user: user)
                        } else {
                            completion(status: Status.Error, message: message, user: nil)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", user: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, user: nil)
                    break;
                }
                
        }
    }
    
    class func updateProfile(user:User, completion: (status: String, message:String, user:User?) -> Void){
        let dateformatter = NSDateFormatter.init()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        let languageId = (NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as? String)!
        
        let parameters : [String:AnyObject] = [
            "customer_id" : user.customerId!,
            "email" : user.username!,
            "handphone" : user.handphone!,
            "fullname" : user.fullname!,
            "gender" : user.gender! == Wording.Gender.Male[languageId]! ? "M" : "F",
            "birthdate" : dateformatter.stringFromDate(user.birthdate!),
            "password" : user.password!,
            "confirm_password" : user.confirmPassword!
            
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/UpdateProfile", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            completion(status: Status.Success, message: message, user: user)
                        } else {
                            completion(status: Status.Error, message: message, user: nil)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", user: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, user: nil)
                    break;
                }
                
        }
    }
    
    class func updateLanguage(user:User, completion: (status: String, message:String, user:User?) -> Void){
        let parameters : [String:AnyObject] = [
            "customer_id" : user.customerId!,
            "language_id" : user.languageId!
            
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/UpdateLanguage", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            completion(status: Status.Success, message: message, user: user)
                        } else {
                            completion(status: Status.Error, message: message, user: nil)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", user: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, user: nil)
                    break;
                }
                
        }
    }
}
