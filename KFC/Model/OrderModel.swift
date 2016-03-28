//
//  OrderModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/18/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderModel: NSObject {
    
    class func addAddressAndSendOrder(cart:Cart, completion: (status: String, message:String) -> Void){
        if (cart.customerAddressId == ""){
            let address:Address = Address.init(address: cart.address, addressDetail: cart.addressDetail, long: cart.long, lat: cart.lat, recipient: cart.recipient)
            self.addAddress(address, completion: { (status, message, address) -> Void in
                if (status == Status.Success){
                    cart.customerAddressId = address?.id
                    
                    self.sendOrder(cart, completion: { (status, message) -> Void in
                        completion(status: status, message: message)
                    })
                } else {
                    completion(status: status, message: message)
                }
            })
        } else {
            self.sendOrder(cart, completion: { (status, message) -> Void in
                completion(status: status, message: message)
            })
        }
    }
    
    class func addAddress(address:Address, completion: (status: String, message:String, address:Address?) -> Void){
        let user: User = UserModel.getUser()
        
        let parameters:[String:AnyObject] = [
            "customer_id" : user.customerId!,
            "recipient" : address.recipient!,
            "address" : address.address!,
            "address_detail" : address.addressDetail!,
            "lat" : address.lat!,
            "lng" : address.long!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/AddAddress", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string!
                        let message:String = json["message"].string!
                        
                        if (status == "T"){
                            let customerAddressId:String = json["customer_address_id"].string!
                            address.id = customerAddressId
                            
                            completion(status: Status.Success, message: message, address: address)
                        } else {
                            completion(status: Status.Error, message: message, address: nil)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", address: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, address: nil)
                    break;
                }
                
        }
    }

    class func sendOrder(cart:Cart, completion: (status: String, message:String) -> Void){
        let cartItemParams : NSMutableArray = NSMutableArray()
        for cartItem in cart.cartItems{
            let cartModifierParams : NSMutableArray = NSMutableArray()
            for cartModifier in cartItem.cartModifiers{
                let cartModifierParam:[String:AnyObject] = [
                    "addition_category_id" : cartModifier.modifierId!,
                    "addition_id" : cartModifier.modifierOptionId!,
                    "quantity" : cartModifier.quantity!
                ]
                cartModifierParams.addObject(cartModifierParam)
            }
            
            let cartItemParam:[String:AnyObject] = [
                "product_id" : cartItem.productId!,
                "quantity" : cartItem.quantity!,
                "detail" : cartModifierParams
            ]
            cartItemParams.addObject(cartItemParam)
        }
        
        let cartParameter:[String:AnyObject] = [
            "store_id" : cart.storeId!,
            "price_id" : cart.priceId!,
            "customer_id" : cart.customerId!,
            "customer_address_id" : cart.customerAddressId!,
            "payment_info" : "COD",
            "payment_sub_info" : "CASH",
            "notes" : cart.notes!,
            "source" : "MOB",
            "trans" : cartItemParams
        ]
        
        var jsonData:NSData?
        do{
            jsonData = try NSJSONSerialization.dataWithJSONObject(cartParameter, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print("Could not parse \(error), \(error.userInfo)")
        }
        
        let parameters:[String:AnyObject] = [
            "data" : (jsonData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/SendOrder", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string!
                        let message:String = json["message"].string!
                        
                        if (status == "T"){
                            cart.status = Status.Outgoing
                            CartModel.update(cart)
                            
                            let newPendingCart:Cart = Cart.init()
                            newPendingCart.status = Status.Pending
                            newPendingCart.storeId = cart.storeId
                            newPendingCart.priceId = cart.priceId
                            newPendingCart.customerId = cart.customerId
                            
                            newPendingCart.customerAddressId = cart.customerAddressId
                            newPendingCart.address = cart.address
                            newPendingCart.addressDetail = cart.addressDetail
                            newPendingCart.long = cart.long
                            newPendingCart.lat = cart.lat
                            newPendingCart.recipient = cart.recipient
                            CartModel.create(newPendingCart)
                            
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
    
    class func getOrderList(completion: (status: String, message:String) -> Void){
        let user:User = UserModel.getUser()
        
        let parameters:[String:AnyObject] = [
            "customer_id" : user.customerId!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/GetOrderHistory", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
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
    
    class func getOrderDetail(transId:String, transDate:NSDate, completion: (status: String, message: String) -> Void){
        let parameters:[String:AnyObject] = [
            "trans_id" : transId
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/GetOrderDetail", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string!
                        let message:String = json["message"].string!
                        
                        if (status == "T"){
                            var orderStatus:String = Status.Delivered
                            if (json["trans"]["status"].string! == "ON PROGRESS"){
                                orderStatus = Status.Outgoing
                            }
                            
                            let cart:Cart = Cart.init(
                                guid: nil,
                                notes: nil,
                                status: orderStatus,
                                subtotal: json["trans"]["total_amount"].string!,
                                tax: json["trans"]["total_tax"].string!,
                                delivery: json["trans"]["delivery_charge"].string!,
                                total: json["trans"]["total_sales"].string!,
                                customerId: json["trans"]["customer_id"].string!,
                                customerAddressId: json["trans"]["customer_address_id"].string!,
                                storeId: nil,
                                priceId: nil,
                                quantity: 0,
                                address: json["trans"]["customer_address"].string!,
                                addressDetail: nil,
                                long: 0,
                                lat: 0,
                                recipient: json["trans"]["customer_address_recipient"].string!,
                                transId: json["trans"]["trans_id"].string!,
                                transNo: json["trans"]["trans_no"].string!,
                                transDate: transDate
                            )
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
    
}
