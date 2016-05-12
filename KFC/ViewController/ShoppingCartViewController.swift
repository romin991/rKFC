//
//  ShoppingCartViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var keepShoppingButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var subtotalValueLabel: UILabel!
    @IBOutlet weak var pb1ValueLabel: UILabel!
    @IBOutlet weak var deliveryValueLabel: UILabel!
    @IBOutlet weak var deliveryTaxValueLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var roundingValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var pb1Label: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var deliveryTaxLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var roundingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
//    @IBOutlet weak var tax: UILabel!
//    @IBOutlet weak var delivery: UILabel!
//    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtotalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pb1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deliveryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deliveryTaxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var taxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var roundingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalHeightConstraint: NSLayoutConstraint!
    
    var drawerDelegate:DrawerDelegate?
    var cart:Cart = Cart.init()
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    //for calculating height
    let subtitleFont = UIFont.init(name: "HelveticaNeue", size: 11)
    let titleFont = UIFont.init(name: "HelveticaNeue", size: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.cart = CartModel.getPendingCart()
//        self.cartItems = CartItemModel.getCartItem(cart)
        
        self.keepShoppingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.checkoutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        CustomView.custom(self.keepShoppingButton, borderColor: self.keepShoppingButton.titleColorForState(UIControlState.Normal)!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.checkoutButton, borderColor: self.checkoutButton.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
//        self.buttonView.layer.shadowColor = UIColor.blackColor().CGColor
//        self.buttonView.layer.shadowOpacity = 0.5
//        self.buttonView.layer.shadowRadius = 16.0
//        self.buttonView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
//        self.buttonView.layer.masksToBounds = false
        
        //change language label
        self.subtotalLabel.text = Wording.ShoppingCart.Subtotal[self.languageId]
        self.pb1Label.text = Wording.ShoppingCart.Pb1[self.languageId]
        self.deliveryLabel.text = Wording.ShoppingCart.Delivery[self.languageId]
        self.deliveryTaxLabel.text = Wording.ShoppingCart.DeliveryTax[self.languageId]
        self.taxLabel.text = Wording.ShoppingCart.Tax[self.languageId]
        self.roundingLabel.text = Wording.ShoppingCart.Rounding[self.languageId]
        self.totalLabel.text = Wording.ShoppingCart.Total[self.languageId]
        
        self.titleLabel.text = Wording.ShoppingCart.OrderSummary[self.languageId]
        self.keepShoppingButton.setTitle(Wording.ShoppingCart.KeepShopping[self.languageId], forState: UIControlState.Normal)
        self.checkoutButton.setTitle(Wording.ShoppingCart.Checkout[self.languageId], forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //this is need to be done here!
        self.refreshCalculation()
        //end
    }
    
    override func viewWillLayoutSubviews() {
       self.refreshView()
    }
    
    func refreshCalculation(){
        self.cart = CartModel.getPendingCart()
        
        self.subtotalValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.subtotal))
        self.pb1ValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.tax))
        self.deliveryValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.delivery))
        self.deliveryTaxValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.deliveryTax))
        self.taxValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.ppn))
        self.roundingValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.rounding))
        self.totalValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.total))
        
        self.refreshView()
        
        self.tableView.reloadData()
    }
    
    func refreshView(){
        self.subtotalHeightConstraint.constant = self.cart.subtotal == "0" ? 0 : 20
        self.pb1HeightConstraint.constant = self.cart.tax == "0" ? 0 : 20
        self.deliveryHeightConstraint.constant = self.cart.delivery == "0" ? 0 : 20
        self.deliveryTaxHeightConstraint.constant = self.cart.deliveryTax == "0" ? 0 : 20
        self.taxHeightConstraint.constant = self.cart.ppn == "0" ? 0 : 20
        self.roundingHeightConstraint.constant = self.cart.rounding == "0" ? 0 : 20
        self.totalHeightConstraint.constant = self.cart.total == "0" ? 0 : 20
        
        let totalHeight = self.subtotalHeightConstraint.constant + self.pb1HeightConstraint.constant + self.deliveryHeightConstraint.constant + self.deliveryTaxHeightConstraint.constant + self.taxHeightConstraint.constant + self.roundingHeightConstraint.constant + self.totalHeightConstraint.constant
        
        self.buttonViewHeightConstraint.constant = totalHeight == 0 ? 0 : totalHeight + 74
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func validate() -> String{
        var message = ""
        for cartItem in self.cart.cartItems{
            if (cartItem.categoryId! == ImportantID.Breakfast){
                let store = StoreModel.getSelectedStore()
                if (store.isBreakfast != false){
                    let now = NSDate()
                    let dateFormatter = NSDateFormatter.init()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let nowStringForDate = dateFormatter.stringFromDate(now)
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZZZZZ"
                    let breakfastStart = dateFormatter.dateFromString(NSString.init(format: "%@ %@", nowStringForDate, store.breakfastStart!) as String)
                    let breakfastEnd = dateFormatter.dateFromString(NSString.init(format: "%@ %@", nowStringForDate, store.breakfastEnd!) as String)
                    
                    if (now.compare(breakfastStart!) == NSComparisonResult.OrderedAscending || now.compare(breakfastEnd!) == NSComparisonResult.OrderedDescending){
                        dateFormatter.dateFormat = "HH aa"
                        
                        message = NSString.init(format: "%@ %@ - %@", Wording.Warning.BreakfastFailed[self.languageId]!, dateFormatter.stringFromDate(breakfastStart!), dateFormatter.stringFromDate(breakfastEnd!)) as String
                    }
                } else {
                    message = Wording.Warning.BreakfastNotAvailable[self.languageId]!
                }
            }
        }
        
        return message
    }

    @IBAction func checkoutButtonClicked(sender: AnyObject) {
        let validateMessage = self.validate()
        if (self.cart.customerId == ""){
            let loginViewController:LoginViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController)!
            loginViewController.drawerDelegate = self.drawerDelegate
            self.navigationController?.pushViewController(loginViewController, animated: true)
            
        } else if (self.cart.cartItems.count == 0){
            let message = Wording.Warning.EmptyCart[self.languageId]
            let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if (validateMessage != ""){
            let alert: UIAlertController = UIAlertController(title: Status.Error, message: validateMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            self.performSegueWithIdentifier("CheckoutSegue", sender: nil)
        }
    }
    
    @IBAction func keepShoppingButtonClicked(sender: AnyObject) {
        self.drawerDelegate?.selectMenu(Menu.Menu)
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cartItem:CartItem = self.cart.cartItems[indexPath.row]
        
        var subtitle:String = ""
        for cartModifier in cartItem.cartModifiers{
            subtitle = subtitle.stringByAppendingFormat("%@, ", cartModifier.names.filter{$0.languageId == self.languageId}.first?.name ?? "")
        }
        if (subtitle.characters.count > 2){
            subtitle = subtitle.substringToIndex(subtitle.endIndex.advancedBy(-2))
        }
        
        let title = cartItem.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
        
        let maximumWidthForSubtitle:CGFloat = self.tableView.frame.size.width - 75
        let maximumWidthForTitle:CGFloat = 245
        
        let subtitleHeight = subtitle == "" ? 0 : NSString.init(string: subtitle).boundingRectWithSize(CGSizeMake(maximumWidthForSubtitle, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.subtitleFont!], context: nil).height
        let titleHeight = NSString.init(string: title).boundingRectWithSize(CGSizeMake(maximumWidthForTitle, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.titleFont!], context: nil).height
        
        let height = ceil(subtitleHeight) + ceil(titleHeight) + 16
        
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cartItem:CartItem = self.cart.cartItems[indexPath.row]
        self.performSegueWithIdentifier("CartItemSegue", sender: cartItem)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            let wantToDeleteCartItem = self.cart.cartItems[indexPath.row]
            CartModel.removeCartItem(wantToDeleteCartItem)
            let index:Int = self.cart.cartItems.indexOf(wantToDeleteCartItem)!
            self.cart.cartItems.removeAtIndex(index)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.refreshCalculation()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cart.cartItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell
        cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let cartItem:CartItem = self.cart.cartItems[indexPath.row]
        
        var subtitle:String = ""
        for cartModifier in cartItem.cartModifiers{
            subtitle = subtitle.stringByAppendingFormat("%@, ", cartModifier.names.filter{$0.languageId == self.languageId}.first?.name ?? "")
        }
        if (subtitle.characters.count > 2){
            subtitle = subtitle.substringToIndex(subtitle.endIndex.advancedBy(-2))
        }
        
        cell.mainTitleLabel.text = cartItem.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
        cell.quantityLabel.text = NSString.init(format: "%i x", cartItem.quantity!) as String
        cell.subtotalLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cartItem.subtotal))
        cell.subtitleLabel.text = subtitle
        cell.subtotalLabel.sizeToFit()

        let path = CommonFunction.generatePathAt(Path.ProductImage, filename: cartItem.productId!)
        let data = NSFileManager.defaultManager().contentsAtPath(path)
        if (data != nil) {
            cell.imageBackground?.image = UIImage.init(data: data!)
        } else {
            cell.imageBackground?.image = nil
        }

        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "CartItemSegue"){
            if let cartItem = sender as? CartItem {
                let shoppingCartItemViewController:ShoppingCartItemViewController = segue.destinationViewController as! ShoppingCartItemViewController
                shoppingCartItemViewController.product = ProductModel.getProductByCartItem(cartItem)
                shoppingCartItemViewController.category = CategoryModel.getCategoryByCartItem(cartItem)
                shoppingCartItemViewController.modifiers = ModifierModel.getModifier(shoppingCartItemViewController.product)
                shoppingCartItemViewController.cartItem = cartItem
            }
        } else if (segue.identifier == "CheckoutSegue"){
            let checkoutViewController:CheckoutViewController = segue.destinationViewController as! CheckoutViewController
            checkoutViewController.drawerDelegate = self.drawerDelegate
        }
    }

}
