//
//  HistoryViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/29/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var shoppingCartBadgesView: UIView!
    @IBOutlet weak var shoppingCartBadgesLabel: UILabel!
    
    var drawerDelegate:DrawerDelegate?
    var carts:[Cart] = [Cart]()
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        CartModel.deleteAllNotPendingCart()
        OrderModel.getOrderList { (status, message) -> Void in
            if (status == Status.Success){
                self.carts = CartModel.getAllNotPendingCart()
                self.tableView.reloadData()
            } else {
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cartButtonClicked(sender: AnyObject) {
        let cartViewController:ShoppingCartViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingCartViewController") as? ShoppingCartViewController)!
        cartViewController.drawerDelegate = self.drawerDelegate
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    @IBAction func leftMenuButtonClicked(sender: AnyObject) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.openLeftMenu()
        }
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cart = self.carts[indexPath.row]
        self.performSegueWithIdentifier("HistorySegue", sender: cart)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : HistoryTableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        let cart:Cart = self.carts[indexPath.row]
        
        let orderNumberString = NSString.init(format:"Order #%@", cart.transNo!) as String
        let mutableAttributedString = NSMutableAttributedString.init(string: orderNumberString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 6))
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 191.0/255.0, green: 58.0/255.0, blue: 56.0/255.0, alpha: 1.0), range: NSRange(location: 6, length: orderNumberString.characters.count - 6))
        
        cell.orderNumberLabel.text = mutableAttributedString.string
        cell.totalLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart.total))
        
        let dateFormatter : NSDateFormatter = NSDateFormatter.init()
        dateFormatter.calendar = NSCalendar.init(identifier: NSCalendarIdentifierISO8601)
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 25200)
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        cell.orderDateLabel.text = dateFormatter.stringFromDate(cart.transDate!)
        cell.statusLabel.text = cart.status
        
        var subtitle:String = ""
        for cartItem in cart.cartItems{
            subtitle = subtitle.stringByAppendingFormat("%i x %@, ", cartItem.quantity!, (cartItem.names.filter{$0.languageId == self.languageId}.first?.name)!)
        }
        if (subtitle.characters.count > 2){
            subtitle = subtitle.substringToIndex(subtitle.endIndex.advancedBy(-2))
        }
        cell.orderDetailLabel.text = subtitle
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "HistorySegue"){
            if let cart = sender as? Cart{
                let historyDetailViewController:HistoryDetailViewController = segue.destinationViewController as! HistoryDetailViewController
                historyDetailViewController.drawerDelegate = self.drawerDelegate
                historyDetailViewController.cart = cart
            }
        }
    }

}
