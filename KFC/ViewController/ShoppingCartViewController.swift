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
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var drawerDelegate:DrawerDelegate?
    var cart:Cart = Cart.init()
//    var cartItems:[CartItem] = [CartItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.cart = CartModel.getPendingCart()
//        self.cartItems = CartItemModel.getCartItem(cart)
        
        self.keepShoppingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.checkoutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        CustomView.custom(self.keepShoppingButton, borderColor: self.keepShoppingButton.titleColorForState(UIControlState.Normal)!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.checkoutButton, borderColor: self.checkoutButton.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        self.buttonView.layer.shadowColor = UIColor.blackColor().CGColor
        self.buttonView.layer.shadowOpacity = 0.5
        self.buttonView.layer.shadowRadius = 16.0
        self.buttonView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.buttonView.layer.masksToBounds = false
        
        self.taxLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.tax))
        self.deliveryChargeLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.delivery))
        self.totalLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.cart.total))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.cart = CartModel.getPendingCart()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func checkoutButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("CheckoutSegue", sender: nil)
    }
    
    @IBAction func keepShoppingButtonClicked(sender: AnyObject) {
        self.drawerDelegate?.selectMenu(Menu.Menu)
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
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
        let price:NSDecimalNumber = NSDecimalNumber.init(string: cartItem.price)
        
        var subtitle:String = ""
        for cartModifier in cartItem.cartModifiers{
            subtitle = subtitle.stringByAppendingFormat("%i %@, ", cartModifier.quantity!, cartModifier.name!)
        }
        if (subtitle.characters.count > 2){
            subtitle = subtitle.substringToIndex(subtitle.endIndex.advancedBy(-2))
        }
        
        cell.mainTitleLabel.text = cartItem.name
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "CartItemSegue"){
            if let cartItem = sender as? CartItem {
                let shoppingCartItemViewController:ShoppingCartItemViewController = segue.destinationViewController as! ShoppingCartItemViewController
                shoppingCartItemViewController.product = ProductModel.getProductByCartItem(cartItem)
                shoppingCartItemViewController.modifiers = ModifierModel.getModifier(shoppingCartItemViewController.product)
                shoppingCartItemViewController.cartItem = cartItem
            }
        }
    }

}
