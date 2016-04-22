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
    static let ImageAdsDownloaded = "ImageAdsDownloaded"
    static let ImageItemDownloaded = "ImageItemDownloaded"
    static let ImageCategoryDownloaded = "ImageCategoryDownloaded"
    static let ImagePaymentDownloaded = "ImagePaymentDownloaded"
    static let LanguageChanged = "LanguageChanged"
}
    
struct Path {
    static let ProductImage = "productImage"
    static let CategoryImage = "categoryImage"
    static let AdsImage = "adsImage"
    static let PaymentImage = "paymentImage"
}

struct Status {
    static let Success = "Success"
    static let Error = "Error"
    static let Pending = "Pending"
    static let Valid = "Valid"
    static let Invalid = "Invalid"
    
    //need to make it the same as server
    static let InProgress = "IN PROGRESS"
    static let Completed = "COMPLETED"
}

struct StatusDetail{
    static let NewOrder = "NEW"
    static let SentToStore = "ORD"
    static let OrderReject = "CAN"
    static let OrderConfirm = "CNF"
    static let PackedOrder = "PCK"
    static let OrderSent = "DLV"
    static let Complete = "CLS"
    static let FakeOrder = "BAD"
}

struct PaymentInfo {
    static let COD = "COD"
    static let Online = "ONLINE"
}

struct LanguageID {
    static let Indonesia = "ID"
    static let English = "EN"
}

struct Gender {
    static let Male = "M"
    static let Female = "F"
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
    static let Feedback = "Feedback"
}

struct AdsType {
    static let General = "General"
    static let Store = "Store"
}

struct Menu {
    static let Main = "Main"
    static let History = "History"
    static let Menu = "Menu"
    static let ChangeLanguage = "Change Language"
    static let Account = "Account"
    static let Promo = "Promo"
    static let Logout = "Logout"
    static let Login = "Login"
    static let Toc = "Term And Condition"
}

struct Color {
    static let Green = UIColor.init(red: 184.0/255.0, green: 233.0/255.0, blue: 134.0/255.0, alpha: 1.0)
    static let Yellow = UIColor.init(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 1.0)
    static let Red = UIColor.init(red: 191.0/255.0, green: 58.0/255.0, blue: 56.0/255.0, alpha: 1.0)
}


//below this line need to localized
struct Wording {
    struct Common {
        static let YES:[String:String] = [LanguageID.Indonesia : "Ya", LanguageID.English : "YES"]
        static let NO:[String:String] = [LanguageID.Indonesia : "Tidak", LanguageID.English : "NO"]
        static let Save:[String:String] = [LanguageID.Indonesia : "Simpan", LanguageID.English : "Save"]
        static let OK:[String:String] = [LanguageID.Indonesia : "OK", LanguageID.English : "OK"]
        static let Cancel:[String:String] = [LanguageID.Indonesia : "Batal", LanguageID.English : "Cancel"]
        static let Alert:[String:String] = [LanguageID.Indonesia : "Peringatan", LanguageID.English : "Alert"]
        static let Send:[String:String] = [LanguageID.Indonesia : "Kirim", LanguageID.English : "Send"]
    }
    
    struct Gender {
        static let Male:[String:String] = [LanguageID.Indonesia : "Pria", LanguageID.English : "Male"]
        static let Female:[String:String] = [LanguageID.Indonesia : "Wanita", LanguageID.English : "Female"]
    }
    
    struct History {
        static let OrderHistoryDetail:[String:String] = [LanguageID.Indonesia : "Detil Riwayat Pemesanan", LanguageID.English : "Order History Detail"]
        static let OrderNumber:[String:String] = [LanguageID.Indonesia : "Nomer Pesanan", LanguageID.English : "Order Number"]
        static let Order:[String:String] = [LanguageID.Indonesia : "Pesanan", LanguageID.English : "Order"]
        static let RateThisOrder:[String:String] = [LanguageID.Indonesia : "Beri penilaian anda terhadap layanan pesan antar KFC", LanguageID.English : "Rate this order"]
        static let WriteYourReviewHere:[String:String] = [LanguageID.Indonesia : "Tuliskan pendapat anda di sini", LanguageID.English : "Write your review here"]
    }
    
    struct Menu {
        static let Main:[String:String] = [LanguageID.Indonesia : "Tentukan Lokasi", LanguageID.English : "Set Location"]
        static let History:[String:String] = [LanguageID.Indonesia : "Riwayat Pemesanan", LanguageID.English : "Order History"]
        static let Menu:[String:String] = [LanguageID.Indonesia : "Menu", LanguageID.English : "Menu"]
        static let ChangeLanguage:[String:String] = [LanguageID.Indonesia : "Ubah Bahasa", LanguageID.English : "Change Language"]
        static let Account:[String:String] = [LanguageID.Indonesia : "Akun", LanguageID.English : "Account"]
        static let Promo:[String:String] = [LanguageID.Indonesia : "Promo", LanguageID.English : "Promo"]
        static let Logout:[String:String] = [LanguageID.Indonesia : "Keluar", LanguageID.English : "Logout"]
        static let Login:[String:String] = [LanguageID.Indonesia : "Masuk", LanguageID.English : "Login"]
        static let Toc:[String:String] = [LanguageID.Indonesia : "Syarat Dan Ketentuan", LanguageID.English : "Term And Condition"]
    }
    
    struct Map {
        static let SetLocation:[String:String] = [LanguageID.Indonesia : "Tentukan Lokasi", LanguageID.English : "Set Location"]
        static let Search:[String:String] = [LanguageID.Indonesia : "Cari", LanguageID.English : "Search"]
        static let TypeAddress:[String:String] = [LanguageID.Indonesia : "Ketik Alamat", LanguageID.English : "TypeAddress"]
        static let ChooseDeliveryAddress:[String:String] = [LanguageID.Indonesia : "Pilih Alamat Pengiriman", LanguageID.English : "Choose Delivery Address"]
        static let NotFound:[String:String] = [LanguageID.Indonesia : "Alamat tidak ditemukan", LanguageID.English : "Address not found"]
    }
    
    struct Warning {
        static let ClearShoppingCart:[String:String] = [
            LanguageID.Indonesia : "Jika anda ingin memilih lokasi yang baru, semua keranjang belanja anda akan dihapus. Apakah anda yakin ingin melanjutkan?",
            LanguageID.English : "If you want to set new location, all cart will be deleted. Are you sure want to continue?"
        ]
        static let EmptyCart:[String:String] = [LanguageID.Indonesia : "Keranjang belanja anda kosong", LanguageID.English : "Your cart is empty"]
        static let Sorry:[String:String] = [LanguageID.Indonesia : "Maaf", LanguageID.English : "Sorry"]
        static let LocationOutOfRange:[String:String] = [
            LanguageID.Indonesia : "Lokasi anda belum dapat dilayani oleh outlet kami. Silahkan menghubungi 14022 untuk bantuan. Terima Kasih",
            LanguageID.English : "No store found for your location. Please call 14022 for help. Thank You"
        ]
        static let AddressCannotEmpty:[String:String] = [
            LanguageID.Indonesia : "Field alamat harus diisi",
            LanguageID.English : "Address field cannot be empty"
        ]
        static let AddressDetailCannotEmpty:[String:String] = [
            LanguageID.Indonesia : "Field detil alamat harus diisi",
            LanguageID.English : "Address detail field cannot be empty"
        ]
        static let PaymentFailed:[String:String] = [
            LanguageID.Indonesia : "Pembayaran anda tidak berhasil, apakah Anda ingin memilih metode pembayaran yang lain?",
            LanguageID.English : "Your payment is failed, do you want to choose another payment method?"
        ]
    }
    
    struct Profile {
        static let Email:[String:String] = [LanguageID.Indonesia : "Email", LanguageID.English : "Email"]
        static let Name:[String:String] = [LanguageID.Indonesia : "Nama", LanguageID.English : "Name"]
        static let Password:[String:String] = [LanguageID.Indonesia : "Kata Sandi", LanguageID.English : "Password"]
        static let ConfirmPassword:[String:String] = [LanguageID.Indonesia : "Ulangi Password", LanguageID.English : "Confirm Password"]
        static let Birthdate:[String:String] = [LanguageID.Indonesia : "Tanggal Lahir", LanguageID.English : "Birthdate"]
        static let PhoneNumber:[String:String] = [LanguageID.Indonesia : "Telepon Seluler", LanguageID.English : "Handphone"]
        static let Address:[String:String] = [LanguageID.Indonesia : "Alamat", LanguageID.English : "Address"]
        static let Language:[String:String] = [LanguageID.Indonesia : "Pilih Bahasa", LanguageID.English : "Language"]
        static let Gender:[String:String] = [LanguageID.Indonesia : "Jenis Kelamin", LanguageID.English : "Gender"]
    }
    
    struct Login {
        static let NewUser:[String:String] = [LanguageID.Indonesia : "Pengguna Baru?", LanguageID.English : "New User?"]
        static let RegisterHere:[String:String] = [LanguageID.Indonesia : "Daftar di sini", LanguageID.English : "Register Here"]
        static let Register:[String:String] = [LanguageID.Indonesia : "Daftar", LanguageID.English : "Register"]
        static let Skip:[String:String] = [LanguageID.Indonesia : "Lewati", LanguageID.English : "Skip"]
        static let ForgotPassword:[String:String] = [LanguageID.Indonesia : "Lupa Kata Sandi?", LanguageID.English : "Forgot Password?"]
        static let Login:[String:String] = [LanguageID.Indonesia : "Masuk", LanguageID.English : "Login"]
        static let LoginHere:[String:String] = [LanguageID.Indonesia : "Masuk Di Sini", LanguageID.English : "Login Here"]
        static let EditProfile:[String:String] = [LanguageID.Indonesia : "Ubah Profile", LanguageID.English : "Edit Profile"]
        static let ChooseYourLanguage:[String:String] = [LanguageID.Indonesia : "Pilih Bahasa Anda", LanguageID.English : "Choose Your Language"]
        static let AlreadyHaveAnAccount:[String:String] = [LanguageID.Indonesia : "Sudah memiliki akun?", LanguageID.English : "Already Have an Account?"]
        static let Validation:[String:String] = [LanguageID.Indonesia : "Validasi", LanguageID.English : "Validation"]
        static let OneStepCloser:[String:String] = [LanguageID.Indonesia : "Satu Langkah Lebih Dekat", LanguageID.English : "One Step Closer"]
        static let InputValidationCode:[String:String] = [LanguageID.Indonesia : "Masukkan Kode Validasi", LanguageID.English : "Input Validation Code"]
        static let FindYourAccount:[String:String] = [LanguageID.Indonesia : "Temukan Akun Anda", LanguageID.English : "Find Your Account"]
    }
    
    struct Main {
        static let Welcome:[String:String] = [LanguageID.Indonesia : "Selamat Datang", LanguageID.English : "Welcome"]
        static let OrderNow:[String:String] = [LanguageID.Indonesia : "Pesan Sekarang", LanguageID.English : "Order Now"]
        static let YouAreNotLoggedIn:[String:String] = [LanguageID.Indonesia : "Anda belum masuk", LanguageID.English : "You are not logged in"]
        static let HereIsYourShoppingCart:[String:String] = [LanguageID.Indonesia : "Keranjang belanja Anda di sini. Klik setelah selesai belanja", LanguageID.English : "Here is your shopping cart. Click when done shopping"]
    }
    
    struct Status{
        static let OnProgress:[String:String] = [LanguageID.Indonesia : "Proses", LanguageID.English : "On Progress"]
        static let Completed:[String:String] = [LanguageID.Indonesia : "Selesai", LanguageID.English : "Completed"]
    }
    
    struct ShoppingCart {
        static let DeliveryTax:[String:String] = [LanguageID.Indonesia : "Pajak Biaya Antar", LanguageID.English : "Delivery Tax"]
        static let Rounding:[String:String] = [LanguageID.Indonesia : "Pembulatan", LanguageID.English : "Rounding"]
        static let Pb1:[String:String] = [LanguageID.Indonesia : "Pajak Restoran", LanguageID.English : "PB1"]
        static let Tax:[String:String] = [LanguageID.Indonesia : "Pajak", LanguageID.English : "Tax"]
        static let Delivery:[String:String] = [LanguageID.Indonesia : "Biaya Antar", LanguageID.English : "Delivery"]
        static let Total:[String:String] = [LanguageID.Indonesia : "Total", LanguageID.English : "Total"]
        static let KeepShopping:[String:String] = [LanguageID.Indonesia : "Lanjutkan Belanja", LanguageID.English : "Keep Shopping"]
        static let Checkout:[String:String] = [LanguageID.Indonesia : "Bayar", LanguageID.English : "Checkout"]
        static let Cart:[String:String] = [LanguageID.Indonesia : "Keranjang Belanja", LanguageID.English : "Shopping Cart"]
        static let OrderSummary:[String:String] = [LanguageID.Indonesia : "Ringkasan Pemesanan", LanguageID.English : "Order Summary"]
        static let AddToCart:[String:String] = [LanguageID.Indonesia : "Tambahkan ke dalam keranjang", LanguageID.English : "Add to cart"]
        static let ChooseQuantity:[String:String] = [LanguageID.Indonesia : "Pilih Jumlah", LanguageID.English : "Choose Quantity"]
        
        static let Address:[String:String] = [LanguageID.Indonesia : "Alamat", LanguageID.English : "Address"]
        static let AddressDetail:[String:String] = [LanguageID.Indonesia : "Detil Alamat", LanguageID.English : "Address Detail"]
        static let Notes:[String:String] = [LanguageID.Indonesia : "Catatan", LanguageID.English : "Notes"]
        static let AddAdditionalNotes:[String:String] = [LanguageID.Indonesia : "Tambahkan catatan", LanguageID.English : "Add your additional notes"]
        static let ChoosePayment:[String:String] = [LanguageID.Indonesia : "Pilih metode pembayaran", LanguageID.English : "Choose your payment method"]
        static let DeliveryAddress:[String:String] = [LanguageID.Indonesia : "Alamat Pengiriman", LanguageID.English : "Delivery Address"]
        static let Payment:[String:String] = [LanguageID.Indonesia : "Pembayaran", LanguageID.English : "Payment"]
        static let TotalAmountToBePaid:[String:String] = [LanguageID.Indonesia : "Total harga yang harus dibayarkan", LanguageID.English : "Total amount to be paid"]
    }
}
