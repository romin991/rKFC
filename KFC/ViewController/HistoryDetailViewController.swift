//
//  HistoryDetailViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/29/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var deliveryValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderNumberValueLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var shoppingCartBadgesView: UIView!
    @IBOutlet weak var shoppingCartBadgesLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var drawerDelegate:DrawerDelegate?
    var cart:Cart?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    //for calculating height
    var maxWidth = CGFloat(290)
    let subtitleFont = UIFont.init(name: "HelveticaNeue", size: 11)
    let titleFont = UIFont.init(name: "HelveticaNeue", size: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.borderView.layer.shadowColor = UIColor.blackColor().CGColor
        self.borderView.layer.shadowOpacity = 0.5
        self.borderView.layer.shadowRadius = 4.0
        self.borderView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        self.borderView.layer.masksToBounds = false
        
        self.orderNumberValueLabel.text = NSString.init(format:"#%@", (cart?.transNo)!) as String
        self.taxValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart?.tax))
        self.deliveryValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart?.delivery))
        self.totalValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart?.total))
        self.addressLabel.text = cart?.address
        self.statusLabel.text = cart?.status
        
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        self.statusLabel.adjustsFontSizeToFitWidth = true
        
        self.maxWidth = self.view.frame.size.width - 140
    }
    
    override func viewDidLayoutSubviews() {
        let addressHeight = NSString.init(string: self.addressLabel.text!).boundingRectWithSize(CGSizeMake(self.addressLabel.frame.size.width, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.addressLabel.font!], context: nil).height
        
        self.contentViewHeightConstraint.constant = CGFloat(242 - 15 + addressHeight + self.tableView.contentSize.height)
        self.contentView.layoutIfNeeded()
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
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cartItem:CartItem = self.cart!.cartItems[indexPath.row]
        
        var subtitle:String = ""
        for cartModifier in cartItem.cartModifiers{
            subtitle = subtitle.stringByAppendingFormat("%i x %@, ", cartModifier.quantity!, (cartModifier.names.filter{$0.languageId == self.languageId}.first?.name)!)
        }
        if (subtitle.characters.count > 2){
            subtitle = subtitle.substringToIndex(subtitle.endIndex.advancedBy(-2))
        }
        
        let title = cartItem.names.filter{$0.languageId == self.languageId}.first?.name
        
        let subtitleHeight = subtitle == "" ? 0 : NSString.init(string: subtitle).boundingRectWithSize(CGSizeMake(self.maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.subtitleFont!], context: nil).height
        let titleHeight = NSString.init(string: title!).boundingRectWithSize(CGSizeMake(self.maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.titleFont!], context: nil).height
        
        let height = ceil(subtitleHeight) + ceil(titleHeight) + 52
        
        return height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cart!.cartItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let cartItem:CartItem = self.cart!.cartItems[indexPath.row]
        
        let price:NSDecimalNumber = NSDecimalNumber.init(string: cartItem.price)
        
        var subtitle:String = ""
        for cartModifier in cartItem.cartModifiers{
            subtitle = subtitle.stringByAppendingFormat("%i x %@, ", cartModifier.quantity!, (cartModifier.names.filter{$0.languageId == self.languageId}.first?.name)!)
        }
        if (subtitle.characters.count > 2){
            subtitle = subtitle.substringToIndex(subtitle.endIndex.advancedBy(-2))
        }
        
        cell.mainTitleLabel.text = cartItem.names.filter{$0.languageId == self.languageId}.first?.name
        cell.priceLabel.text = NSString.init(format: "%i x %@", cartItem.quantity!, CommonFunction.formatCurrency(price)) as String
        cell.subtotalLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cartItem.total))
        cell.subtitleLabel.text = subtitle
        
        let path = CommonFunction.generatePathAt(Path.ProductImage, filename: cartItem.productId!)
        let data = NSFileManager.defaultManager().contentsAtPath(path)
        if (data != nil) {
            cell.imageBackground?.image = UIImage.init(data: data!)
        } else {
            cell.imageBackground?.image = nil
        }
        
        
        return cell
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
