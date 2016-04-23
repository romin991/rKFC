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
    var sectionTitle:[String] = [String]()
    var dataSource:[String:[Cart]] = [String:[Cart]]()
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)

        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        CartModel.deleteAllNotPendingCart()
        OrderModel.getOrderList { (status, message) -> Void in
            if (status == Status.Success){
                self.carts = CartModel.getAllNotPendingCart()
                
                let month = NSDateFormatter.init()
                month.dateFormat = "MMMM yyyy"
                
                var selectedCart:Cart?
                for cart in self.carts{
                    let monthString = month.stringFromDate(cart.transDate!)
                    if (!self.sectionTitle.contains(monthString)) {
                        self.sectionTitle.append(monthString)
                    }
                    if (!self.dataSource.keys.contains(monthString)){
                        self.dataSource[monthString] = [Cart]()
                    }
                    self.dataSource[monthString]?.append(cart)
                    
                    if (cart.statusDetail == "CLS" && cart.feedbackRating == "0" && selectedCart == nil){
                        selectedCart = cart
                    }
                }
                
                if (selectedCart != nil){
                    self.performSegueWithIdentifier("FeedbackSegue", sender: selectedCart)
                }
                
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
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let monthString = self.sectionTitle[section]
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height))
        view.backgroundColor = UIColor.clearColor()
        
        let label = UILabel.init(frame: CGRect.init(x: self.tableView.frame.size.width / 2 - 60, y: 10, width: 120, height: 15))
        label.font = UIFont.init(name: "HelveticaNeue", size: 14)
        label.textAlignment = NSTextAlignment.Center
        label.text = monthString
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.grayColor()
        
        CustomView.custom(label, borderColor: label.backgroundColor!, cornerRadius: 7, roundingCorners: UIRectCorner.AllCorners, borderWidth: 0)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cart:Cart = self.carts[indexPath.row]
        
        var subtitle:String = ""
        for cartItem in cart.cartItems{
            subtitle = subtitle.stringByAppendingFormat("%i x %@, ", cartItem.quantity!, cartItem.names.filter{$0.languageId == self.languageId}.first?.name ?? "")
        }
        if (subtitle.characters.count > 2){
            subtitle = subtitle.substringToIndex(subtitle.endIndex.advancedBy(-2))
        }
        
        let subtitleHeight = NSString.init(string: subtitle).boundingRectWithSize(CGSizeMake(self.tableView.frame.size.width - 50, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.init(name: "HelveticaNeue", size: 12)!], context: nil).height
        
        return subtitleHeight + 144
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cart = self.carts[indexPath.row]
        self.performSegueWithIdentifier("HistorySegue", sender: cart)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionTitle.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let monthString = self.sectionTitle[section]
        return self.dataSource[monthString]?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : HistoryTableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        let monthString = self.sectionTitle[indexPath.section]
        let cart:Cart = self.dataSource[monthString]![indexPath.row]
        
        let orderLabel = Wording.History.Order[self.languageId]
        let orderNumberString = NSString.init(format:"%@ #%@", orderLabel!, cart.transNo!) as String
        let orderNumberAttributedString = NSMutableAttributedString.init(string: orderNumberString)
        orderNumberAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: (orderLabel?.characters.count)!))
        orderNumberAttributedString.addAttribute(NSForegroundColorAttributeName, value: Color.Red, range: NSRange(location: (orderLabel?.characters.count)!, length: orderNumberString.characters.count - (orderLabel?.characters.count)!))
        orderNumberAttributedString.addAttribute(NSFontAttributeName, value: UIFont.init(name: "HelveticaNeue", size: 14)!, range: NSRange(location: 0,length: orderNumberString.characters.count))
        
        cell.orderNumberLabel.attributedText = orderNumberAttributedString
        cell.totalLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart.total))
        
        let dateFormatter : NSDateFormatter = NSDateFormatter.init()
        dateFormatter.calendar = NSCalendar.init(identifier: NSCalendarIdentifierISO8601)
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 25200)
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        cell.orderDateLabel.text = dateFormatter.stringFromDate(cart.transDate!)
        
        var color = Color.Yellow
        if (cart.statusDetail == StatusDetail.Complete) {
            color = Color.Green
        }
        
        let statusAttributedString = NSMutableAttributedString.init(string: cart.status!)
        statusAttributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: 0, length: (cart.status?.characters.count)!))
        
        cell.statusLabel.attributedText = statusAttributedString
        
        var subtitle:String = ""
        for cartItem in cart.cartItems{
            subtitle = subtitle.stringByAppendingFormat("%i x %@, ", cartItem.quantity!, cartItem.names.filter{$0.languageId == self.languageId}.first?.name ?? "")
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
        if (segue.identifier == "FeedbackSegue"){
            if let cart = sender as? Cart{
                let feedbackViewController:FeedbackViewController = segue.destinationViewController as! FeedbackViewController
                feedbackViewController.selectedCart = cart
            }
        }
    }

}
