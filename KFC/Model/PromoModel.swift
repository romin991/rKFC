//
//  AdsModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/3/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PromoModel: NSObject {
    
    class func getGeneralPromo(completion: (status: String, message: String) -> Void){
        Alamofire.request(.GET, NSString.init(format: "%@/GeneralPromoList", ApiKey.BaseURL) as String, parameters: nil, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let promosJSON = json["Promo"]["List"].array ?? []
                        
                        for promoJSON in promosJSON{
                            let image = Image.init(
                                guid: nil,
                                imageURL: promoJSON["image"].string ?? "",
                                imagePath: Path.AdsImage,
                                imageDownloaded: false
                            )
                            
                            let ads = Ads.init(
                                guid: nil,
                                id: promoJSON["id"].string ?? "",
                                message: promoJSON["message"].string ?? "",
                                title: promoJSON["title"].string ?? "",
                                type: AdsType.General,
                                image: image
                            )
                            
                            AdsModel.create(ads);
                        }
                        
                        ImageModel.downloadImage()
                        
                        completion(status: Status.Success, message: "")
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
    
    class func getStorePromo(completion: (status: String, message: String) -> Void){
        let store = StoreModel.getSelectedStore()
        
        let parameters : [String:AnyObject] = [
            "storeId" : store.id!,
        ]
        
        Alamofire.request(.POST, NSString.init(format: "%@/StorePromoList", ApiKey.BaseURL) as String, parameters: parameters, encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let promosJSON = json["Promo"]["List"].array ?? []
                        
                        for promoJSON in promosJSON{
                            let image = Image.init(
                                guid: nil,
                                imageURL: promoJSON["image"].string ?? "",
                                imagePath: Path.AdsImage,
                                imageDownloaded: false
                            )
                            
                            let ads = Ads.init(
                                guid: nil,
                                id: promoJSON["id"].string ?? "",
                                message: promoJSON["message"].string ?? "",
                                title: promoJSON["title"].string ?? "",
                                type: AdsType.Store,
                                image: image
                            )
                            
                            AdsModel.create(ads);
                        }
                        
                        ImageModel.downloadImage()
                        
                        completion(status: Status.Success, message: "")
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
