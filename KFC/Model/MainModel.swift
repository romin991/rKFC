//
//  MainModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/25/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import Alamofire
import GoogleMaps
import SwiftyJSON
import CoreData

class MainModel: NSObject {
    
    class func longLatToAddress(position: CLLocationCoordinate2D, completion: (status: String, message:String, address: String?) -> Void){
        GMSGeocoder.init().reverseGeocodeCoordinate(position) { (response, error) -> Void in
            if ((error) != nil){
                completion(status: Status.Error, message:(error?.localizedDescription)!, address: nil)
            } else {
                let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
                completion(status: Status.Success, message:Wording.Common.OK[languageId]!, address: response?.firstResult()?.lines?[0])
            }
        }
    }
    
    class func addressToLongLat(address: String, completion: (status: String, message:String, addresses: Array<Address>) -> Void){
        //TODO: change this using GMS GoogleMaps SDK For iOS
        
        var addresses:[Address] = [Address]()
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: ["address": address])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let results = json["results"].array
                        if (results != nil){
                            for result in results!{
                                let long = result["geometry"]["location"]["lng"].double ?? 0
                                let lat = result["geometry"]["location"]["lat"].double ?? 0
                                addresses.append(Address.init(address: result["formatted_address"].string ?? "", addressDetail:"", long: long, lat: lat, recipient: ""))
                            }
                        }
                        completion(status:Status.Success, message:json["status"].string ?? "", addresses: addresses)
                    } else {
                        //need return something
                        completion(status:Status.Error, message:"Not a valid JSON", addresses: addresses)
                    }
                    break;
                case .Failure(let error):
                    //need return something
                    completion(status:Status.Error, message:error.localizedDescription, addresses: addresses)
                    break;
                }
                
        }
    }
    
    class func getStoreByLocation(position: CLLocationCoordinate2D, completion: (status: String, message:String, store: Store?) -> Void){
        let parameters:[String:AnyObject] = [
            "lat": position.latitude,
            "lng": position.longitude,
            "source" : "MOB"
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/GetStoreByLocation", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let status:String = json["result"]["status"].string ?? "Not Found"
                        
                        if (status == "found"){
                            //parse data and save to database
                            var store:Store = Store.init(
                                code: json["result"]["store"]["code"].string ,
                                name: json["result"]["store"]["name"].string,
                                id: json["result"]["store"]["id"].string,
                                long: json["result"]["store"]["lng"].string,
                                lat: json["result"]["store"]["lat"].string,
                                priceId: json["result"]["store"]["price_id"].string,
                                delivery: json["result"]["store"]["delivery_charge"].string,
                                deliveryTax: json["result"]["store"]["delivery_charge_tax_percent"].string,
                                tax: json["result"]["store"]["tax_percent"].string,
                                ppn: json["result"]["store"]["ppn_percent"].string,
                                isBreakfast: json["result"]["store"]["is_breakfast"].string == "1" ? true : false,
                                breakfastStart: json["result"]["store"]["breakfast_start"].string,
                                breakfastEnd: json["result"]["store"]["breakfast_end"].string
                            )
                            store = StoreModel.save(store)
                            
                            let categoriesJSON = json["result"]["store"]["productCatalogs"]["productCatalog"].array
                            if (categoriesJSON != nil){
                                for categoryJSON in categoriesJSON! {
                                    var category = Category.init(
                                        guid: nil,
                                        id: categoryJSON["id"].string,
                                        image: categoryJSON["image"].string
                                    )
                                    category.names = HelperModel.parseNames(categoryJSON["categoryNames"]["categoryName"].array!)
                                    category = CategoryModel.create(category)
                                    
                                    let productsJSON = categoryJSON["products"]["product"].array
                                    if (productsJSON != nil) {
                                        for productJSON in productsJSON! {
                                            let product = Product.init(
                                                guid: nil,
                                                id: productJSON["id"].string,
                                                categoryId: category.id,
                                                categoryGuid: category.guid,
                                                image: productJSON["image"].string,
                                                price: productJSON["price"].string,
                                                taxable: productJSON["taxable"].string! == "1" ? true : false,
                                                ppn: productJSON["ppn"].string! == "1" ? true : false
                                                
                                            )
                                            product.names = HelperModel.parseNames(productJSON["names"]["name"].array ?? [])
                                            product.notes = HelperModel.parseNames(productJSON["descriptions"]["description"].array ?? [])
                                            ProductModel.create(product)
                                        }
                                        
                                    }
                                }
                            }
                            
                            AdsModel.deleteAdsByType(AdsType.Store)
                            PromoModel.getStorePromo({ (status, message) -> Void in
                                let categories = CategoryModel.getAllCategory()
                                
                                
                                    
                                    CategoryModel.downloadAllCategoryImage(categories)
                                    ProductModel.downloadAllProductImageFromCategory(categories)
                            
                                
                                completion(status: Status.Success, message:"found", store: store)
                            })
                        } else {
                            completion(status: Status.Error, message:status, store: nil)
                        }
                    } else {
                        completion(status: Status.Error, message:"Not a valid JSON", store: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status:Status.Error, message:error.localizedDescription, store: nil)
                    break;
                }
                
        }
    }
    
    class func getProductDetail(product:Product, store:Store, completion: (status: String, message:String, modifiers: [Modifier]) -> Void){
        let parameters = [
            "productId": product.id!,
            "priceId": store.priceId!
        ]
        
        var modifiers = [Modifier]()
        Alamofire.request(.POST, NSString.init(format: "%@/GetProductDetail", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        //clear data
                        ModifierModel.deleteModifier(product)
                        
                        //parse data and save to database
                        let json = JSON(value)
                        print("json \(json)")
                        let modifiersJSON = json["additionCategories"]["additionCategory"].array
                        if (modifiersJSON != nil){
                            for modifierJSON in modifiersJSON! {
                                var modifier:Modifier = Modifier.init(
                                    guid: nil,
                                    id: modifierJSON["id"].string,
                                    amount: modifierJSON["amount"].string,
                                    minimumSelect: Int(modifierJSON["minimum_select"].string!),
                                    maximumSelect: Int(modifierJSON["maximum_select"].string!),
                                    multipleSelect: modifierJSON["multiple_select"].string == "1" ? true : false,
                                    productId: product.id,
                                    productGuid: product.guid)
                                modifier.names = HelperModel.parseNames(modifierJSON["additionCategoryNames"]["additionCategoryName"].array ?? [])
                                modifier = ModifierModel.create(modifier)
                                
                                let modifierOptionsJSON = modifierJSON["productAdditions"]["productAddition"].array
                                var modifierOptions = [ModifierOption]()
                                if (modifierOptionsJSON != nil){
                                    for modifierOptionJSON in modifierOptionsJSON!{
                                        let modifierOption : ModifierOption = ModifierOption.init(
                                            guid: nil,
                                            id: modifierOptionJSON["id"].string,
                                            code: modifierOptionJSON["code"].string,
                                            defaultSelect: modifierOptionJSON["default"].string == "1" ? true : false,
                                            image: modifierOptionJSON["image"].null != nil ? "" : modifierOptionJSON["image"].string ,
                                            modifierId: modifier.id,
                                            modifierGuid: modifier.guid,
                                            price: modifierOptionJSON["price"].string,
                                            taxable: modifierOptionJSON["taxable"].string == "1" ? true : false,
                                            ppn: modifierOptionJSON["ppn"].string == "1" ? true : false
                                        )
                                        modifierOption.names = HelperModel.parseNames(modifierOptionJSON["additionNames"]["additionName"].array ?? [])
                                        ModifierOptionModel.create(modifierOption)
                                        modifierOptions.append(modifierOption)
                                    }
                                }
                                
                                modifier.modifierOptions = modifierOptions
                                modifiers.append(modifier)
                            }
                        }
                        
                        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
                        completion(status:Status.Success, message:Wording.Common.OK[languageId]!, modifiers: modifiers)
                    } else {
                        completion(status:Status.Error, message:"Not a valid JSON", modifiers: modifiers)
                    }
                    break;
                case .Failure(let error):
                    completion(status:Status.Error, message:error.localizedDescription, modifiers: modifiers)
                    break;
                }
                
        }
    }
}
