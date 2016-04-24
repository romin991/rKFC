//
//  OnlinePaymentViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class OnlinePaymentViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    var payment:Payment?
    var drawerDelegate:DrawerDelegate?
    var cart:Cart?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.cart = CartModel.getPendingCart()
        
        let param:String = NSString.init(format: "trans_id=%@&payment_sub_info=%@", (self.cart?.transId)!, (self.cart?.paymentSubInfo)!) as String
        
        let urlRequest = NSMutableURLRequest.init(URL: NSURL.init(string: NSString.init(format: "%@/GetPaymentForm", ApiKey.BaseURL) as String)!)
        urlRequest.HTTPMethod = "POST"
        urlRequest.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        self.webView.loadRequest(urlRequest)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showSuccessMessage(){
        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        let message = Wording.Main.YourOrderHasBeenSent[languageId]
        let alert: UIAlertController = UIAlertController(title: Status.Success, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootViewController!.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: UIWebView
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        
        if (urlString == self.payment?.successURL){
            //set as complete, redirect to home
            OrderModel.orderComplete()
            self.drawerDelegate?.selectMenu(Menu.Home)
            self.drawerDelegate?.showOrderDetail(self.cart!)
            self.showSuccessMessage()
            
        } else if (urlString == self.payment?.failedURL){
            let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
            let alert: UIAlertController = UIAlertController(title: Status.Error, message: Wording.Warning.PaymentFailed[languageId], preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: Wording.Common.NO[languageId], style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                OrderModel.orderComplete()
                self.drawerDelegate?.selectMenu(Menu.Home)
                self.drawerDelegate?.showOrderDetail(self.cart!)
                self.showSuccessMessage()
                
            }))
            alert.addAction(UIAlertAction(title: Wording.Common.YES[languageId], style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        let alert: UIAlertController = UIAlertController(title: Status.Error, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
