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
//                            cart.status = Status.Outgoing
//                            CartModel.update(cart)
                            CartModel.deletePendingCart()
                            
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
                            
                            let dateformatter = NSDateFormatter.init()
                            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            
                            let transJSON = json["trans"].array!
                            for tranJSON in transJSON{
                            
                                let cart:Cart = Cart.init(
                                    guid: nil,
                                    notes: nil,
                                    status: tranJSON["trans_detail"]["status"].string,
                                    subtotal: tranJSON["trans_detail"]["total_amount"].string,
                                    tax: tranJSON["trans_detail"]["total_tax"].string,
                                    delivery: tranJSON["trans_detail"]["delivery_charge"].string,
                                    total: tranJSON["trans_detail"]["total_sales"].string,
                                    customerId: tranJSON["trans_detail"]["customer_id"].string,
                                    customerAddressId: tranJSON["trans_detail"]["customer_address_id"].string,
                                    storeId: nil,
                                    priceId: nil,
                                    quantity: 0,
                                    address: tranJSON["trans_detail"]["customer_address"].string,
                                    addressDetail: nil,
                                    long: nil,
                                    lat: nil,
                                    recipient: tranJSON["trans_detail"]["customer_address_recipient"].string,
                                    transId: tranJSON["trans_detail"]["trans_id"].string,
                                    transNo: tranJSON["trans_detail"]["trans_no"].string,
                                    transDate: dateformatter.dateFromString(NSString.init(format:"%@ %@", tranJSON["trans_date"].string!, tranJSON["trans_time"].string!) as String)
                                )
                                
                                var quantity = 0
                                let listsJSON = tranJSON["trans_detail"]["list"].array!
                                for listJSON in listsJSON{
                                    let cartItem = CartItem.init(
                                        guid: nil,
                                        cartGuid: nil,
                                        productId: listJSON["product_id"].string,
                                        quantity: Int(listJSON["quantity"].string!),
                                        price: "0",
                                        total: "0"
                                    )
                                    cartItem.names = HelperModel.parseNames(listJSON["product_names"]["product_name"].array!)
                                    
                                    quantity += cartItem.quantity!
                                    
                                    var price = NSDecimalNumber.init(string: "0")
                                    let detailListsJSON = listJSON["detail_list"].array!
                                    for detailListJSON in detailListsJSON{
                                        let cartModifier = CartModifier.init(
                                            guid: nil,
                                            cartGuid: nil,
                                            cartItemGuid: nil,
                                            modifierId: detailListJSON["product_addition_category_id"].string,
                                            modifierOptionId: detailListJSON["product_addition_id"].string,
                                            quantity: Int(detailListJSON["quantity"].string!)
                                        )
                                        cartModifier.names = HelperModel.parseNames(detailListJSON["additionNames"]["additionName"].array!)
                                        
                                        price = price.decimalNumberByAdding(NSDecimalNumber.init(string: detailListJSON["price"].string))
                                        cartItem.cartModifiers.append(cartModifier)
                                    }
                                    
                                    cartItem.price = price.stringValue
                                    cartItem.total = price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(long:cartItem.quantity!)).stringValue
                                    cart.cartItems.append(cartItem)
                                }
                                
                                cart.quantity = quantity
                                CartModel.create(cart)
                            }
                            
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
