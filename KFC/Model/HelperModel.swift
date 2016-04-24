//
//  HelperModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/24/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import SwiftyJSON

class HelperModel: NSObject {
    
    class func parseNames(objects:[JSON]) -> [Name]{
        var names:[Name] = [Name]()
        for object in objects{
            let name = Name.init(
                guid: nil,
                languageId: object["language_id"].string ?? object["languageId"].string ?? "",
                name: object["content"].string ?? "",
                refId: nil,
                refGuid: nil,
                refTable: nil
            )
            names.append(name)
        }
        return names
    }
    
    class func parseNames2(objects:[JSON]) -> [Name]{
        var names:[Name] = [Name]()
        for object in objects{
            for key in (object.dictionaryObject?.keys)!{
                let name = Name.init(
                    guid: nil,
                    languageId: key,
                    name: object.dictionaryObject![key] as? String,
                    refId: nil,
                    refGuid: nil,
                    refTable: nil
                )
                names.append(name)
            }
        }
        return names
    }

}
