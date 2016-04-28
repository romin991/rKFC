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
    
    class func clearCart(){
        let cart = CartModel.getPendingCart()
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
    }
    
    class func getPaymentChannel(completion: (status: String, message:String) -> Void){
        Alamofire.request(.POST, NSString.init(format: "%@/GetPaymentChannel", ApiKey.BaseURL) as String, parameters: nil, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string!
                        let message:String = json["message"].string!
                        
                        if (status == "T"){
                            let successURL = json["payment_success_url"].string
                            let failedURL = json["payment_failed_url"].string
                            
                            let listsJSON = json["list"].array ?? []
                            for listJSON in listsJSON{
                                let paymentInfo = listJSON["code"].string ?? ""
                                let subInfoListsJSON = listJSON["list"].array ?? []
                                for subInfoListJSON in subInfoListsJSON{
                                    let image = Image.init(
                                        guid: nil,
                                        imageURL: subInfoListJSON["image"].string,
                                        imagePath: Path.PaymentImage,
                                        imageDownloaded: false
                                    )
                                    
                                    let payment = Payment.init(
                                        guid: nil,
                                        paymentInfo: paymentInfo,
                                        paymentSubInfo: subInfoListJSON["code"].string,
                                        name: subInfoListJSON["name"].string,
                                        image: image,
                                        successURL: successURL,
                                        failedURL: failedURL
                                    )
                                    
                                    PaymentModel.create(payment)
                                }
                            }
                            ImageModel.downloadImage()
                            
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
    
    class func getPaymentForm(cart:Cart, completion: (status: String, message:String) -> Void){
        let parameters:[String:AnyObject] = [
            "trans_id" : cart.transId!,
            "payment_sub_info" : cart.paymentSubInfo!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/GetPaymentForm", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
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
    
    class func addAddressAndSendOrder(cart:Cart, completion: (status: String, message:String, cart:Cart) -> Void){
        if (cart.customerAddressId == ""){
            let address:Address = Address.init(address: cart.address, addressDetail: cart.addressDetail, long: cart.long, lat: cart.lat, recipient: cart.recipient)
            self.addAddress(address, completion: { (status, message, address) -> Void in
                if (status == Status.Success){
                    cart.customerAddressId = address?.id
                    CartModel.update(cart)
                    
                    self.sendOrder(cart, completion: { (status, message, cart) -> Void in
                        completion(status: status, message: message, cart: cart)
                    })
                } else {
                    completion(status: status, message: message, cart: cart)
                }
            })
        } else {
            self.sendOrder(cart, completion: { (status, message, cart) -> Void in
                completion(status: status, message: message, cart: cart)
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
                            let customerAddressId:String = json["customer_address_id"].string ?? ""
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

    class func sendOrder(cart:Cart, completion: (status: String, message:String, cart:Cart) -> Void){
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
            "payment_info" : cart.paymentInfo!,
            "payment_sub_info" : cart.paymentSubInfo!,
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
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            cart.transId = json["trans_id"].string ?? ""
                            CartModel.update(cart)
                            
                            completion(status: Status.Success, message: message, cart: cart)
                        } else {
                            completion(status: Status.Error, message: message, cart: cart)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", cart: cart)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, cart: cart)
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
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            
                            let dateformatter = NSDateFormatter.init()
                            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            
                            let transJSON = json["trans"].array ?? []
                            for tranJSON in transJSON{
                            
                                let cart:Cart = Cart.init(
                                    guid: nil,
                                    notes: nil,
                                    status: tranJSON["trans_detail"]["status"].string,
                                    subtotal: tranJSON["trans_detail"]["total_amount"].string,
                                    ppn: nil,
                                    deliveryTax: nil,
                                    rounding: tranJSON["trans_detail"]["total_rounding"].string,
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
                                    transDate: dateformatter.dateFromString(NSString.init(format:"%@ %@", tranJSON["trans_date"].string ?? "", tranJSON["trans_time"].string!) as String),
                                    paymentInfo: nil,
                                    paymentSubInfo: nil,
                                    statusDetail: tranJSON["status_detail"].string,
                                    feedbackRating: tranJSON["feedback_rating"].string,
                                    feedbackAnswerId: nil,
                                    feedbackNotes: nil
                                )
                                
                                var quantity = 0
                                let listsJSON = tranJSON["trans_detail"]["list"].array ?? []
                                for listJSON in listsJSON{
                                    let cartItem = CartItem.init(
                                        guid: nil,
                                        cartGuid: nil,
                                        productId: listJSON["product_id"].string,
                                        categoryId: nil,
                                        quantity: Int(listJSON["quantity"].string ?? "0"),
                                        price: "0",
                                        tax: "0",
                                        ppn: "0",
                                        subtotal: "0",
                                        total: "0"
                                    )
                                    cartItem.names = HelperModel.parseNames(listJSON["product_names"]["product_name"].array ?? [])
                                    
                                    quantity += cartItem.quantity!
                                    
                                    var price = NSDecimalNumber.init(string: "0")
                                    let detailListsJSON = listJSON["detail_list"].array ?? []
                                    for detailListJSON in detailListsJSON{
                                        let cartModifier = CartModifier.init(
                                            guid: nil,
                                            cartGuid: nil,
                                            cartItemGuid: nil,
                                            modifierId: detailListJSON["product_addition_category_id"].string,
                                            modifierOptionId: detailListJSON["product_addition_id"].string,
                                            quantity: Int(detailListJSON["quantity"].string!)
                                        )
                                        cartModifier.names = HelperModel.parseNames(detailListJSON["additionNames"]["additionName"].array ?? [])
                                        
                                        price = price.decimalNumberByAdding(NSDecimalNumber.init(string: detailListJSON["price"].string))
                                        cartItem.cartModifiers.append(cartModifier)
                                    }
                                    
                                    cartItem.price = price.stringValue
                                    cartItem.total = price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(long:cartItem.quantity ?? 0)).stringValue
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
    
    class func getOrderDetail(cart:Cart, completion: (status: String, message:String, cart:Cart) -> Void){ //just use once when done payment, to get data like transNo
        let parameters:[String:AnyObject] = [
            "trans_id" : cart.transId!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/GetOrderDetail", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            cart.transNo = json["trans"]["trans_no"].string ?? ""
                            cart.status = json["trans"]["status"].string ?? ""
                            cart.statusDetail = json["trans"]["status_detail"].string ?? ""
                            cart.subtotal = json["trans"]["total_amount"].string ?? ""
                            cart.rounding = json["trans"]["total_rounding"].string ?? ""
                            cart.tax = json["trans"]["total_tax"].string ?? ""
                            cart.delivery = json["trans"]["delivery_charge"].string ?? ""
                            cart.total = json["trans"]["total_sales"].string ?? ""
                            cart.customerAddressId = json["trans"]["customer_address_id"].string ?? ""
                            cart.customerId = json["trans"]["customer_id"].string ?? ""
                            cart.address = json["trans"]["customer_address"].string ?? ""
                            cart.recipient = json["trans"]["customer_address_recipient"].string ?? ""
                            
                            cart.cartItems = [CartItem]()
                            
                            var quantity = 0
                            let listsJSON = json["trans"]["list"].array ?? []
                            for listJSON in listsJSON{
                                let cartItem = CartItem.init(
                                    guid: nil,
                                    cartGuid: nil,
                                    productId: listJSON["product_id"].string,
                                    categoryId: nil,
                                    quantity: Int(listJSON["quantity"].string ?? "0"),
                                    price: "0",
                                    tax: "0",
                                    ppn: "0",
                                    subtotal: "0",
                                    total: "0"
                                )
                                cartItem.names = HelperModel.parseNames(listJSON["product_names"]["product_name"].array ?? [])
                                
                                quantity += cartItem.quantity!
                                
                                var price = NSDecimalNumber.init(string: "0")
                                let detailListsJSON = listJSON["detail_list"].array ?? []
                                for detailListJSON in detailListsJSON{
                                    let cartModifier = CartModifier.init(
                                        guid: nil,
                                        cartGuid: nil,
                                        cartItemGuid: nil,
                                        modifierId: detailListJSON["product_addition_category_id"].string,
                                        modifierOptionId: detailListJSON["product_addition_id"].string,
                                        quantity: Int(detailListJSON["quantity"].string!)
                                    )
                                    cartModifier.names = HelperModel.parseNames(detailListJSON["additionNames"]["additionName"].array ?? [])
                                    
                                    price = price.decimalNumberByAdding(NSDecimalNumber.init(string: detailListJSON["price"].string))
                                    cartItem.cartModifiers.append(cartModifier)
                                }
                                
                                cartItem.price = price.stringValue
                                cartItem.total = price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(long:cartItem.quantity ?? 0)).stringValue
                                cart.cartItems.append(cartItem)
                            }
                            
                            cart.quantity = quantity
                            
                            completion(status: Status.Success, message: message, cart: cart)
                        } else {
                            completion(status: Status.Error, message: message, cart: cart)
                        }
                    } else {
                        completion(status: Status.Error, message: "Not a valid JSON object", cart: cart)
                    }
                    break;
                case .Failure(let error):
                    completion(status: Status.Error, message: error.localizedDescription, cart: cart)
                    break;
                }
                
        }
    }
    
    class func getFeedbackForm(completion: (status: String, message:String) -> Void){
        Alamofire.request(.POST, NSString.init(format: "%@/GetFeedbackForm", ApiKey.BaseURL) as String, parameters: nil, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["status"].string ?? "F"
                        let message:String = json["message"].string ?? "Not a valid JSON object"
                        
                        if (status == "T"){
                            let ratingListsJSON = json["rating_list"].array ?? []
                            for ratingListJSON in ratingListsJSON{
                                let questions = HelperModel.parseNames2(ratingListJSON["question"].array ?? [])
                                
                                let answerListsJSON = ratingListJSON["answer_list"].array ?? []
                                for answerListJSON in answerListsJSON{
                                    let feedback = Feedback.init(
                                        guid: nil,
                                        id: answerListJSON["id"].string,
                                        rating: NSString.init(format: "%li", ratingListJSON["rating"].int!) as String
                                    )
                                    
                                    feedback.questions = questions
                                    feedback.answers = HelperModel.parseNames2(answerListJSON["titles"].array ?? [])
                                    
                                    FeedbackModel.create(feedback)
                                }
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
    
    class func sendFeedback(cart:Cart, completion: (status: String, message:String) -> Void){
        let parameters:[String:AnyObject] = [
            "trans_id" : cart.transId!,
            "answer_id" : cart.feedbackAnswerId!,
            "notes" : cart.feedbackNotes!,
            "rating" : cart.feedbackRating!
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/SendFeedback", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
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
    
}
