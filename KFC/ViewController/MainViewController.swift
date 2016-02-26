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
    
    var currentPosition: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        self.mapView.myLocationEnabled = true
        self.mapView.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func markerButtonClicked(sender: AnyObject) {
        //show activity indicator
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        //TODO: request server
        MainModel.getStoreByLocation(self.currentPosition!) { (status, store) -> Void in
            //TODO: if found, refresh store view => that means show it
            if (status == "found"){
                let alert: UIAlertController = UIAlertController(title: "KFC Store Found", message: store?.name, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            //TODO: else nothing happen
            
            //remove activity indicator
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    @IBAction func searchAddressButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("SearchAddressSegue", sender: nil)
    }
    
    func updateAddressLabelWithPosition(position: GMSCameraPosition){
        self.currentPosition = position.target
        
        //request google service, convert long lat to address
        MainModel.longLatToAddress(position.target) { (status, address) -> Void in
            var resultText:String
            if (status == "OK") {
                resultText = address!
            } else {
                resultText = "No Address Found"
            }
            
            //display address to address field
            self.addressLabel.text = resultText
            
            //refresh marker width
            let size: CGSize = resultText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)])
            let preferredWidth: CGFloat = size.width + 20
            self.markerWidth.constant = preferredWidth > self.view.frame.size.width ? self.view.frame.size.width : preferredWidth
        }
        
    }
    
//MARK: SearchAddressDelegate
    func navigateTo(address: Address) {
        //create GMSCamera based on new long lat
        let target:CLLocationCoordinate2D = CLLocationCoordinate2DMake(address.lat, address.long)
        let camera = GMSCameraUpdate.setTarget(target, zoom: 10)
        
        //set mapView camera with new camera
        self.mapView.animateWithCameraUpdate(camera)
        
        //set current position with new camera
        self.currentPosition = target
        
        //TODO: refresh store view => thats means close store view
        
    }
    
//MARK: GMSMapViewDelegate
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        self.updateAddressLabelWithPosition(position)
        
        //TODO: need to refresh store view. => thats means close store view
        
    }
    
//MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let camera = GMSCameraPosition.cameraWithLatitude(manager.location!.coordinate.latitude,
            longitude: manager.location!.coordinate.longitude, zoom: 10)
        self.currentPosition = camera.target;
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
