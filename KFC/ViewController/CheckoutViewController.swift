//
//  CheckoutViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/18/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class CheckoutViewController: UIViewController {
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var addressDetailTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var dokuPayButton: UIButton!
    @IBOutlet weak var codButton: UIButton!
    
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var choosePaymentLabel: UILabel!
    
    var cart:Cart?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CustomView.custom(self.dokuPayButton, borderColor: self.dokuPayButton.titleColorForState(UIControlState.Normal)!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.codButton, borderColor: self.codButton.titleColorForState(UIControlState.Normal)!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        self.cart = CartModel.getPendingCart()
        self.addressField.text = self.cart?.address
        self.addressDetailTextField.text = self.cart?.addressDetail
        
        //change language label
        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        
        self.navigationTitleLabel.text = Wording.ShoppingCart.Checkout[languageId]
        self.addressLabel.text = Wording.ShoppingCart.Address[languageId]
        self.addressField.placeholder = Wording.ShoppingCart.Address[languageId]
        self.addressDetailLabel.text = Wording.ShoppingCart.AddressDetail[languageId]
        self.addressDetailTextField.placeholder = Wording.ShoppingCart.AddressDetail[languageId]
        self.notesLabel.text = Wording.ShoppingCart.Notes[languageId]
        self.notesTextField.placeholder = Wording.ShoppingCart.AddAdditionalNotes[languageId]
        self.choosePaymentLabel.text = Wording.ShoppingCart.ChoosePayment[languageId]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func dokuPayButtonClicked(sender: AnyObject) {
        
    }

    @IBAction func codButtonClicked(sender: AnyObject) {
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        if (self.addressField.text != ""){
            self.cart?.address = self.addressField.text
        }
        if (self.addressDetailTextField.text != ""){
            self.cart?.addressDetail = self.addressDetailTextField.text
        }
        if (self.notesTextField.text != ""){
            self.cart?.notes = self.notesTextField.text
        }
        
        OrderModel.addAddressAndSendOrder(self.cart!) { (status, message) -> Void in
            let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
            
            if (status == Status.Success){
                let lastViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
                self.navigationController?.popToViewController(lastViewController!, animated: true)
                
                let alert: UIAlertController = UIAlertController(title: Status.Success, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
                lastViewController!.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
