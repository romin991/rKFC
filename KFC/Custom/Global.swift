//
//  Global.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation

struct ApiKey {
    static let BaseURL = "http://36.66.78.251:8280/fiona"
    static let Google = "AIzaSyDL2_fjawveP2tkRDgtk3mT6sDErddQ-a8"
}

struct NotificationKey {
    static let ImageItemDownloaded = "ImageItemDownloaded"
    static let ImageCategoryDownloaded = "ImageCategoryDownloaded"
    static let LanguageChanged = "LanguageChanged"
}
    
struct Path {
    static let ProductImage = "productImage"
    static let CategoryImage = "categoryImage"
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

struct Table{
    static let Category = "Category"
    static let Product = "Product"
    static let Modifier = "Modifier"
    static let ModifierOption = "ModifierOption"
    static let CartItem = "CartItem"
    static let CartModifier = "CartModifier"
}


//below this line need to localized
struct Common {
    static let Save:[String:String] = [LanguageID.Indonesia : "Simpan", LanguageID.English : "Save"]
    static let OK:[String:String] = [LanguageID.Indonesia : "OK", LanguageID.English : "OK"]
    static let Cancel:[String:String] = [LanguageID.Indonesia : "Batal", LanguageID.English : "Cancel"]
    static let Alert:[String:String] = [LanguageID.Indonesia : "Peringatan", LanguageID.English : "Alert"]
}

struct Gender {
    static let Male:[String:String] = [LanguageID.Indonesia : "Pria", LanguageID.English : "Male"]
    static let Female:[String:String] = [LanguageID.Indonesia : "Wanita", LanguageID.English : "Female"]
}

struct Menu {
    static let Main:[String:String] = [LanguageID.Indonesia : "Tentukan Lokasi", LanguageID.English : "Set Location"]
    static let History:[String:String] = [LanguageID.Indonesia : "Riwayat Pemesanan", LanguageID.English : "Order History"]
    static let Menu:[String:String] = [LanguageID.Indonesia : "Menu", LanguageID.English : "Menu"]
    static let ChangeLanguage:[String:String] = [LanguageID.Indonesia : "Ganti Bahasa", LanguageID.English : "Change Language"]
    static let Account:[String:String] = [LanguageID.Indonesia : "Account", LanguageID.English : "Account"]
    static let Promo:[String:String] = [LanguageID.Indonesia : "Promo", LanguageID.English : "Promo"]
    static let Logout:[String:String] = [LanguageID.Indonesia : "Keluar", LanguageID.English : "Logout"]
}

struct Map {
    static let ChooseAddress:[String:String] = [LanguageID.Indonesia : "Pilih Alamat", LanguageID.English : "Choose Address"]
    static let NotFound:[String:String] = [LanguageID.Indonesia : "Alamat tidak ditemukan", LanguageID.English : "Address not found"]
    static let WarningClearShoppingCart:[String:String] = [
        LanguageID.Indonesia : "Jika anda ingin memilih lokasi yang baru, semua keranjang belanja anda akan dihapus. Apakah anda yakin ingin melanjutkan?",
        LanguageID.English : "If you want to set new location, all cart will be deleted. Are you sure want to continue?"
    ]
}

struct Profile {
    static let Email:[String:String] = [LanguageID.Indonesia : "Email", LanguageID.English : "Email"]
    static let Name:[String:String] = [LanguageID.Indonesia : "Nama", LanguageID.English : "Name"]
    static let Password:[String:String] = [LanguageID.Indonesia : "Password", LanguageID.English : "Password"]
    static let ConfirmPassword:[String:String] = [LanguageID.Indonesia : "Ulangi Password", LanguageID.English : "Confirm Password"]
    static let Birthdate:[String:String] = [LanguageID.Indonesia : "Tanggal Lahir", LanguageID.English : "Birthdate"]
    static let PhoneNumber:[String:String] = [LanguageID.Indonesia : "Telepon", LanguageID.English : "Phone"]
    static let Address:[String:String] = [LanguageID.Indonesia : "Alamat", LanguageID.English : "Address"]
    static let Language:[String:String] = [LanguageID.Indonesia : "Pilih Bahasa", LanguageID.English : "Language"]
    static let Gender:[String:String] = [LanguageID.Indonesia : "Jenis Kelamin", LanguageID.English : "Gender"]
    static let EditProfile:[String:String] = [LanguageID.Indonesia : "Ubah Profile", LanguageID.English : "Edit Profile"]
}

struct ShoppingCart {
    static let Tax:[String:String] = [LanguageID.Indonesia : "Pajak", LanguageID.English : "Tax"]
    static let Delivery:[String:String] = [LanguageID.Indonesia : "Biaya Antar", LanguageID.English : "Delivery"]
    static let Total:[String:String] = [LanguageID.Indonesia : "Total", LanguageID.English : "Total"]
    static let KeepShopping:[String:String] = [LanguageID.Indonesia : "Lanjutkan Belanja", LanguageID.English : "Keep Shopping"]
    static let Checkout:[String:String] = [LanguageID.Indonesia : "Checkout", LanguageID.English : "Checkout"]
    static let Cart:[String:String] = [LanguageID.Indonesia : "Keranjang Belanja", LanguageID.English : "Your Cart"]
    static let OrderSummary:[String:String] = [LanguageID.Indonesia : "Ringkasan Pemesanan", LanguageID.English : "Order Summary"]
    static let AddToCart:[String:String] = [LanguageID.Indonesia : "Masukkan keranjang", LanguageID.English : "Add to cart"]
    static let ChooseQuantity:[String:String] = [LanguageID.Indonesia : "Kuantitas", LanguageID.English : "Choose Quantity"]
    
    static let Address:[String:String] = [LanguageID.Indonesia : "Alamat", LanguageID.English : "Address"]
    static let AddressDetail:[String:String] = [LanguageID.Indonesia : "Alamat Detail", LanguageID.English : "Detail Address"]
    static let Notes:[String:String] = [LanguageID.Indonesia : "Catatan", LanguageID.English : "Notes"]
    static let NotesPlaceholder:[String:String] = [LanguageID.Indonesia : "Tambahkan catatan", LanguageID.English : "Add your additional notes"]
    static let ChoosePayment:[String:String] = [LanguageID.Indonesia : "Pilih metode pembayaran", LanguageID.English : "Choose your payment method"]
}

