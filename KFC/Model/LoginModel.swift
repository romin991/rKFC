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
    
    class func register(user:User, completion: (status: String, message: String) -> Void){
        
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
                        let status:String = json["status"].string!
                        let message:String = json["message"].string!
                        
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
                        let status:String = json["status"].string!
                        let message:String = json["message"].string!
                        
                        if (status == "T"){
                            var user:User = User.init()
                            user.customerId = json["customer"]["customer_id"].string!
                            user.languageId = json["customer"]["language_id"].string!
                            user.fullname = json["customer"]["fullname"].string!
                            user.handphone = json["customer"]["handphone"].string!
                            user.username = json["customer"]["email"].string!
                            
                            self.getAddressList(user, completion: { (status, message, addresses) -> Void in
                                if (status == Status.Success){
                                    user.addresses = addresses!
                                    user = UserModel.create(user)
                                    
                                    NSUserDefaults.standardUserDefaults().setObject(user.languageId, forKey: "LanguageId")
                                    
                                    StoreModel.save(Store.init())
                                    
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
                        let status:String = json["status"].string!
                        let message:String = json["message"].string!
                        
                        if (status == "T"){
                            var addresses: [Address] = [Address]()
                            let addressesJSON = json["address"].array!
                            for addressJSON in addressesJSON{
                                let address:Address = Address.init(
                                    guid: nil,
                                    id: addressJSON["id"].string!,
                                    address: addressJSON["address"].string!,
                                    addressDetail: addressJSON["address_detail"].string!,
                                    long: Double(addressJSON["lng"].string!),
                                    lat: Double(addressJSON["lat"].string!),
                                    recipient: addressJSON["recipient"].string!
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
        CartModel.deleteAllCart()
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
                        let status:String = json["status"].string!
                        let message:String = json["message"].string!
                        
                        if (status == "T"){
                            let user:User = UserModel.getUser()
                            let customerJSON = json["customer"].dictionary!
                            
//                            user.fullname = customerJSON["fullname"]
//                            user.gender = customerJSON["gender"]
//                            user.handphone = customerJSON["handphone"]
//                            user.birthdate = customerJSON["birthdate"] as? String!
                            
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
