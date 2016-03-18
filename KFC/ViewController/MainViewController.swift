//
//  MainViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/24/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MBProgressHUD

class MainViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, SearchAddressDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerWidth: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var markerPopover: UIView!
    @IBOutlet weak var storeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressTextField: UISearchBar!
    @IBOutlet weak var addressStoreLabel: UILabel!
    @IBOutlet weak var shoppingCartBadgesView: UIView!
    @IBOutlet weak var shoppingCartBadgesLabel: UILabel!
    
    var currentPosition: CLLocation?
    let locationManager = CLLocationManager()
    var drawerDelegate:DrawerDelegate?
    var selectedAddress:Address?
    var selectedStore:Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        self.mapView.myLocationEnabled = true
        self.mapView.delegate = self;
        
        CustomView.custom(self.markerPopover, borderColor: self.markerPopover.backgroundColor!, cornerRadius: 10, roundingCorners: UIRectCorner.AllCorners, borderWidth: 0)
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        self.addressTextField.backgroundImage = UIImage.init()
        
        self.hideStoreView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let cart:Cart = CartModel.getPendingCart()
        self.shoppingCartBadgesLabel.text = "\(cart.quantity!)"
    }
    
    func showStoreView(){
        self.storeViewHeight.constant = 140
    }
    
    func hideStoreView(){
        self.storeViewHeight.constant = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftMenuButtonClicked(sender: AnyObject) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.openLeftMenu()
        }
    }
    
    @IBAction func shoppingCartButtonClicked(sender: AnyObject) {
        let cartViewController:ShoppingCartViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingCartViewController") as? ShoppingCartViewController)!
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    @IBAction func markerButtonClicked(sender: AnyObject) {
        //show activity indicator
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        MainModel.getStoreByLocation((self.currentPosition?.coordinate)!) { (status, message, store) -> Void in
            if (status == Status.Success){
                self.selectedStore = store
                self.addressStoreLabel.text = store?.name
                
                //initiate pending cart
                let user:User = UserModel.getUser()
                
                let cart:Cart = Cart.init()
                cart.status = Status.Pending
                cart.storeId = self.selectedStore!.id
                cart.priceId = self.selectedStore!.priceId
                cart.customerId = user.customerId
                
                if (self.selectedAddress != nil && self.selectedAddress?.id != ""){
                    cart.customerAddressId = self.selectedAddress?.id
                    cart.address = self.selectedAddress?.address
                    cart.addressDetail = self.selectedAddress?.addressDetail
                    cart.long = self.selectedAddress?.long
                    cart.lat = self.selectedAddress?.lat
                    cart.recipient = self.selectedAddress?.recipient
                } else {
                    cart.address = self.addressTextField.text
                    cart.addressDetail = ""
                    cart.long = self.currentPosition?.coordinate.longitude
                    cart.lat = self.currentPosition?.coordinate.latitude
                    cart.recipient = user.fullname
                }
                
                self.shoppingCartBadgesLabel.text = "\(cart.quantity!)"
                
                CartModel.create(cart)
                
                UIView.animateWithDuration(0.5, animations: {
                    self.showStoreView()
                })
            }
            
            //remove activity indicator
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    @IBAction func searchAddressButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("SearchAddressSegue", sender: nil)
    }
    
    func updateAddressLabelWithPosition(position: GMSCameraPosition){
        self.currentPosition = CLLocation.init(latitude: position.target.latitude, longitude: position.target.longitude)
        
        if (self.selectedAddress != nil){
            let distance : CLLocationDistance = (self.currentPosition?.distanceFromLocation(CLLocation.init(latitude: (self.selectedAddress?.lat)!, longitude: (self.selectedAddress?.long)!)))!
            if (distance > 50){
                self.selectedAddress = nil
            }
        }
        
        //request google service, convert long lat to address
        MainModel.longLatToAddress(position.target) { (status, message, address) -> Void in
            var resultText:String
            if (status == Status.Success && address != nil && address != "") {
                resultText = address!
            } else {
                resultText = "No Address Found"
            }
            
            //display address to address field
            self.addressLabel.text = resultText
            self.addressTextField.text = resultText
            
            //refresh marker width
            let size: CGSize = resultText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
            let preferredWidth: CGFloat = size.width + 68
            self.markerWidth.constant = preferredWidth > self.view.frame.size.width ? self.view.frame.size.width : preferredWidth
        }
        
    }
    
    @IBAction func KFCStoreButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("CategoryListSegue", sender: nil)
    }
    
//MARK: SearchAddressDelegate
    func navigateTo(address: Address) {
        //create GMSCamera based on new long lat
        let target:CLLocationCoordinate2D = CLLocationCoordinate2DMake(address.lat!, address.long!)
        let camera = GMSCameraUpdate.setTarget(target, zoom: 17)
        
        //set mapView camera with new camera
        self.mapView.animateWithCameraUpdate(camera)
        
        //set current position with new camera
        self.currentPosition = CLLocation.init(latitude: target.latitude, longitude: target.longitude)
        
        self.selectedAddress = address
        
        //TODO: refresh store view => thats means close store view
        UIView.animateWithDuration(0.5, animations: {
            self.hideStoreView()
        })
    }
    
//MARK: GMSMapViewDelegate
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        self.updateAddressLabelWithPosition(position)
        
        //TODO: need to refresh store view. => thats means close store view
        UIView.animateWithDuration(0.5, animations: {
            self.hideStoreView()
        })
    }
    
//MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let camera = GMSCameraPosition.cameraWithLatitude(manager.location!.coordinate.latitude,
            longitude: manager.location!.coordinate.longitude, zoom: 17)
        self.currentPosition = CLLocation.init(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude);
        self.mapView.camera = camera
    }
    
//MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SearchAddressSegue"){
            let searchAddressViewController:SearchAddressViewController = segue.destinationViewController as! SearchAddressViewController
            searchAddressViewController.delegate = self
        }
    }
    
}
