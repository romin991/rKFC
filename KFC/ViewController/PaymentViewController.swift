//
//  PaymentViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class PaymentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var payments = PaymentModel.getAllPayment()
    var cart:Cart?
    var drawerDelegate:DrawerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cart = CartModel.getPendingCart()
        
        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        self.navigationTitleLabel.text = Wording.ShoppingCart.Payment[languageId]
        self.subtitleLabel.text = Wording.ShoppingCart.TotalAmountToBePaid[languageId]
        
        self.grandTotalLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart?.total))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: UICollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.payments.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.collectionView.frame.size.width / 2.0, 88)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier( "Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        let payment = self.payments[indexPath.row]
        cell.titleLabel?.text = payment.name
        
        let path = CommonFunction.generatePathAt(Path.PaymentImage, filename: (payment.image?.guid!)!)
        let data = NSFileManager.defaultManager().contentsAtPath(path)
        if (data != nil) {
            cell.imageView?.image = UIImage.init(data: data!)
        } else {
            cell.imageView?.image = nil
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let payment = self.payments[indexPath.row]
        self.cart?.paymentInfo = payment.paymentInfo
        self.cart?.paymentSubInfo = payment.paymentSubInfo
        
        if (payment.paymentInfo == PaymentInfo.COD){
            if (self.cart?.transId != nil && self.cart?.transId != ""){
                OrderModel.getPaymentForm(self.cart!, completion: { (status, message) -> Void in
                    if (status == Status.Success){
                        OrderModel.orderComplete()
                        self.drawerDelegate?.selectMenu(Menu.Promo)
                        
                    } else {
                        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
                        let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                })
                
            } else {
                //call send order
                //set as complete
                self.sendOrder({ (status, message) -> Void in
                    if (status == Status.Success){
                        OrderModel.orderComplete()
                        self.drawerDelegate?.selectMenu(Menu.Promo)
                    }
                })
            }
            
        } else {
            //send order without completing
            //throw to next view controller including payment object
            self.sendOrder({ (status, message) -> Void in
                if (status == Status.Success){
                    self.performSegueWithIdentifier("OnlinePaymentSegue", sender: payment)
                }
            })
            
        }
    }
    
    func sendOrder(completion: (status: String, message:String) -> Void) {
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        OrderModel.addAddressAndSendOrder(self.cart!) { (status, message, cart) -> Void in
            let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
            
            self.cart = cart
            if (status == Status.Error){
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            completion(status: status, message: message)
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "OnlinePaymentSegue"){
            if let payment = sender as? Payment {
                let onlinePaymentViewController:OnlinePaymentViewController = segue.destinationViewController as! OnlinePaymentViewController
                onlinePaymentViewController.drawerDelegate = self.drawerDelegate
                onlinePaymentViewController.payment = payment
            }
        }
        
    }

}
