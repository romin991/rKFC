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
        let parameters:[String:AnyObject] = [
            "type" : user.type!,
            "value" : user.username!,
            "password" : user.password!,
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
                                    recipient: addressJSON["recipient"].string
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
    
    class func logout(){
        CategoryModel.deleteAllCategory()
        ProductModel.deleteAllProduct()
        ModifierModel.deleteAllModifier()
        ModifierOptionModel.deleteAllModifierOption()
        CartModel.deleteAllNotPendingCart()
        CartModel.deletePendingCart()
        UserModel.deleteAllUser()
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
                            
                            user.fullname = customerJSON["fullname"].string
                            user.handphone = customerJSON["handphone"].string
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
            "gender" : user.gender! == Gender.Male[languageId]! ? "M" : "F",
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
}
