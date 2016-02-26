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

class MainModel: NSObject {
    
    class func longLatToAddress(position: CLLocationCoordinate2D, completion: (status: String, address: String?) -> Void){
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: ["latlng": String(format: "%f, %f", arguments: [position.latitude, position.longitude])])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        completion(status: json["status"].string!, address: json["results"][0]["formatted_address"].string)
                    } else {
                        completion(status: "Not a valid JSON", address: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: error.localizedDescription, address: nil)
                    break;
                }
                
        }
    }
    
    class func addressToLongLat(address: String, completion: (status: String, addresses: Array<Address>) -> Void){
        var addresses:[Address] = [Address]()
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: ["address": address])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let results = json["results"].array!
                        for result in results{
                            let long = result["geometry"]["location"]["lng"].double!
                            let lat = result["geometry"]["location"]["lat"].double!
                            addresses.append(Address.init(address: address, long: long, lat: lat))
                        }
                        completion(status: json["status"].string!, addresses: addresses)
                    } else {
                        //need return something
                        completion(status: "Not a valid JSON", addresses: addresses)
                    }
                    break;
                case .Failure(let error):
                    //need return something
                    completion(status: error.localizedDescription, addresses: addresses)
                    break;
                }
                
        }
    }
    
    class func getStoreByLocation(position: CLLocationCoordinate2D, completion: (status: String, store: Store?) -> Void){
        //TODO: remove this when API Fixed
        var customPosition = position
        customPosition.longitude = 106.799796
        customPosition.latitude = -6.250463
        
        Alamofire.request(.POST, "http://103.43.44.222:9763/services/store/GetStoreByLocation", parameters: ["lat": customPosition.latitude, "lng": customPosition.longitude], encoding: ParameterEncoding.URL, headers: ["Accept" : "application/json"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("json \(json)")
                        let store:Store = Store.init(
                            code: json["result"]["store"]["code"].string! ,
                            name: json["result"]["store"]["name"].string!,
                            id: json["result"]["store"]["id"].string!,
                            long: json["result"]["store"]["lng"].string!,
                            lat: json["result"]["store"]["lat"].string!)
                        completion(status: json["result"]["status"].string!, store: store)
                    } else {
                        completion(status: "Not a valid JSON", store: nil)
                    }
                    break;
                case .Failure(let error):
                    completion(status: error.localizedDescription, store: nil)
                    break;
                }
                
        }
    }
}
