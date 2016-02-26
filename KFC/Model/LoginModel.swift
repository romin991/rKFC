//
//  LoginModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/24/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import Alamofire

class LoginModel: NSObject {

    class func loginWithBlock(completion: (result: Bool, message: String) -> Void){
//        Alamofire.request(.GET, "https://google.com", parameters: ["foo": "bar"])
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
                completion(result: true, message: "");
//        }
    }
}
