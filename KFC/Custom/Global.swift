//
//  Global.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

struct ApiKey {
    static let BaseURL = "http://alfarisi.id:8280/fiona"
    static let Google = "AIzaSyDL2_fjawveP2tkRDgtk3mT6sDErddQ-a8"
}

struct NotificationKey {
    static let ImageItemDownloaded = "ImageItemDownloaded"
}
    
struct Path {
    static let ProductImage = "productImage"
}

struct Menu {
    static let Main = "Set Location"
    static let History = "Order History"
    static let Menu = "Menu"
    static let ChangeLanguage = "Language"
    static let Account = "Account"
    static let Promo = "Promo"
    static let Logout = "Logout"
}

struct Status {
    static let Success = "Success"
    static let Error = "Error"
    static let Pending = "Pending"
    static let Outgoing = "Outgoing"
    static let Delivered = "Delivered"
    static let Valid = "Valid"
    static let Invalid = "Invalid"
}

struct LanguageID {
    static let Indonesia = "ID"
    static let English = "EN"
}

struct LoginType {
    static let Email = "email"
    static let Google = "google"
    static let Facebook = "facebook"
    static let Twitter = "twitter"
}

struct Gender {
    static let Male = "Male"
    static let Female = "Female"
}