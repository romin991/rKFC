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
    
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var cart:Cart?
    var drawerDelegate:DrawerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cart = CartModel.getPendingCart()
        self.addressField.text = self.cart?.address
        self.addressDetailTextField.text = self.cart?.addressDetail
        
        //change language label
        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        self.sendButton.setTitle(Wording.Common.Send[languageId], forState: UIControlState.Normal)
        
        self.navigationTitleLabel.text = Wording.ShoppingCart.DeliveryAddress[languageId]
        self.addressLabel.text = Wording.ShoppingCart.Address[languageId]
        self.addressField.placeholder = Wording.ShoppingCart.Address[languageId]
        self.addressDetailLabel.text = Wording.ShoppingCart.AddressDetail[languageId]
        self.addressDetailTextField.placeholder = Wording.ShoppingCart.AddressDetail[languageId]
        self.notesLabel.text = Wording.ShoppingCart.Notes[languageId]
        self.notesTextField.placeholder = Wording.ShoppingCart.AddAdditionalNotes[languageId]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func sendButtonClicked(sender: AnyObject) {
        self.sendButton.enabled = false
        
        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        if (self.addressField.text == ""){
            let alert: UIAlertController = UIAlertController(title: Status.Error, message: Wording.Warning.AddressCannotEmpty[languageId], preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: { () -> Void in
                self.sendButton.enabled = true
            })
            
        } else if (self.addressDetailTextField.text == ""){
            let alert: UIAlertController = UIAlertController(title: Status.Error, message: Wording.Warning.AddressDetailCannotEmpty[languageId], preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: { () -> Void in
                self.sendButton.enabled = true
            })
            
        } else {
            self.cart?.address = self.addressField.text
            self.cart?.addressDetail = self.addressDetailTextField.text
            self.cart?.notes = self.notesTextField.text
            
            CartModel.update(self.cart!)
            
            PaymentModel.deleteAllPayment()
            OrderModel.getPaymentChannel({ (status, message) -> Void in
                if (status == Status.Success){
                    self.performSegueWithIdentifier("PaymentSegue", sender: nil)
                    self.sendButton.enabled = true
                } else {
                    let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: { () -> Void in
                        self.sendButton.enabled = true
                    })
                }
            })
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "PaymentSegue"){
            let paymentViewController:PaymentViewController = segue.destinationViewController as! PaymentViewController
            paymentViewController.drawerDelegate = self.drawerDelegate
        }
    }

}
