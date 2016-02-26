//
//  SearchAddressViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/25/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import GoogleMaps

protocol SearchAddressDelegate{
    func navigateTo(address: Address)
}

class SearchAddressViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var addresses:[Address] = [Address]()
    var delegate:SearchAddressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //get text field
        //request google, search for address
        MainModel.addressToLongLat(textField.text!) { (status, addresses) -> Void in
            //get the result, show on tableview.
            if (status == "OK"){
                self.addresses = addresses
                self.tableView.reloadData()
            }
        }
    }
    
//MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //pop navigation controller
        self.navigationController?.popViewControllerAnimated(true)
        
        //get selected data (address, and longlat)
        let address:Address = self.addresses[indexPath.row]
        
        //call delegate
        self.delegate?.navigateTo(address)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath)
        
        let address:Address = self.addresses[indexPath.row]
        cell.textLabel?.text = address.address
        
        return cell
    }
}
