//
//  SearchAddressViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/25/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import GoogleMaps
import MBProgressHUD

protocol SearchAddressDelegate{
    func navigateTo(address: Address)
}

class SearchAddressViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, FavoriteAddressDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var addresses:[Address] = [Address]()
    var searchResult:[Address] = [Address]()
    var delegate:SearchAddressDelegate?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.searchField.attributedPlaceholder = NSAttributedString(string: self.searchField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        
        let user:User = UserModel.getUser()
        self.addresses = user.addresses
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            if (user.username != ""){
                LoginModel.getAddressList(user, completion: { (status, message, addresses) -> Void in
                    if (addresses != nil) {
                        user.addresses = addresses!
                        UserModel.updateUser(user)
                        
                        self.addresses = addresses!
                        self.tableView.reloadData()
                    }
                })
            }
        }
        
        //set languages
        self.searchField.attributedPlaceholder = NSAttributedString.init(string: Wording.Profile.Address[self.languageId]!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        self.tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //get text field
        //request google, search for address
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        MainModel.addressToLongLat(textField.text!) { (status, message, addresses) -> Void in
            //get the result, show on tableview.
            if (status == Status.Success){
                self.searchResult = addresses
            } else {
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: Wording.Common.OK[self.languageId], style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            self.tableView.reloadData()
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    func isSearching() -> Bool{
        if (self.searchField.isFirstResponder() || self.searchField.text != ""){
            return true
        } else {
            return false
        }
    }
    
//MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if ((self.isSearching() && self.searchResult.count > 0 ) || self.addresses.count > 0){
            //pop navigation controller
            self.navigationController?.popViewControllerAnimated(true)
        
            //get selected data (address, and longlat)
            let address:Address
            if (self.isSearching()){
                address = self.searchResult[indexPath.row]
            } else {
                address = self.addresses[indexPath.row]
            }
        
            //call delegate
            self.delegate?.navigateTo(address)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isSearching()){
            if (self.searchResult.count == 0){
                return 1
            } else {
                return self.searchResult.count
            }
        } else {
            return self.addresses.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        if (self.isSearching()){
            if (self.searchResult.count == 0){
                cell.mainTitleLabel?.text = Wording.Map.NotFound[self.languageId]
                cell.favoriteButton.hidden = true
                cell.address = nil
            } else {
                let address:Address = self.searchResult[indexPath.row]
                cell.mainTitleLabel?.text = address.address
                cell.favoriteButton.hidden = false
                cell.favoriteButton.selected = address.favorite == true ? true : false
                cell.address = address
            }
        } else {
            let address:Address = self.addresses[indexPath.row]
            cell.mainTitleLabel?.text = address.address
            cell.favoriteButton.hidden = false
            cell.favoriteButton.selected = address.favorite == true ? true : false
            cell.address = address
        }
        cell.favoriteAddressDelegate = self
        
        return cell
    }
    
    func favoriteButtonClicked(address: Address?, favoriteButton: UIButton?) {
        if (address != nil) {
            let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            activityIndicator.mode = MBProgressHUDMode.Indeterminate;
            activityIndicator.labelText = "Loading";
            
            LoginModel.addFavoriteAddress(address!) { (status, message) -> Void in
                if (status == Status.Success){
                    favoriteButton?.selected = true
                    address?.favorite = true
                    
                } else {
                    let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: Wording.Common.OK[self.languageId], style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }
    }
}
