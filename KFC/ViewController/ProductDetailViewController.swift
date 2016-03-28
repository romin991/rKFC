//
//  ProductDetailViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantityMinusButton: UIButton!
    @IBOutlet weak var quantityPlusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToShoppingCartButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shoppingCartBadgesView: UIView!
    @IBOutlet weak var shoppingCartBadgesLabel: UILabel!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chooseQuantityLabel: UILabel!
    
    var product : Product!
    var category : Category!
    var modifiers : [Modifier]!
    var drawerDelegate:DrawerDelegate?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshImageView", name: NotificationKey.ImageItemDownloaded, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNotification()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CustomView.custom(self.quantityView, borderColor: self.quantityView.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.addToShoppingCartButton, borderColor: self.addToShoppingCartButton.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        if (self.product != nil){
            self.refreshImageView()
            self.navigationTitleLabel.text = self.product.names.filter{$0.languageId == self.languageId}.first?.name
            self.titleLabel.text = self.product.names.filter{$0.languageId == self.languageId}.first?.name
            self.subtitleLabel.text = self.product.notes.filter{$0.languageId == self.languageId}.first?.name
        }
        
        //change label language
        self.chooseQuantityLabel.text = ShoppingCart.ChooseQuantity[self.languageId]
        self.addToShoppingCartButton.setTitle(ShoppingCart.AddToCart[self.languageId], forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let cart:Cart = CartModel.getPendingCart()
        self.shoppingCartBadgesLabel.text = "\(cart.quantity!)"
    }
    
    func refreshImageView(){
        if (self.productImage != nil && self.product != nil){
            let path = CommonFunction.generatePathAt(Path.ProductImage, filename: product.id!)
            let data = NSFileManager.defaultManager().contentsAtPath(path)
            if (data != nil) {
                self.productImage.image = UIImage.init(data: data!)
            } else {
                self.productImage.image = nil
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func shoppingCartButtonClicked(sender: AnyObject) {
        let cartViewController:ShoppingCartViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingCartViewController") as? ShoppingCartViewController)!
        cartViewController.drawerDelegate = self.drawerDelegate
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    @IBAction func quantityMinusButtonClicked(sender: AnyObject) {
        if (Int(self.quantityLabel.text!)! > 1){
            self.quantityLabel.text = "\(Int(self.quantityLabel.text!)! - 1)"
            self.product.quantity = Int(self.quantityLabel.text!)!
            self.tableView.reloadData()
        }
    }
    
    @IBAction func quantityPlusButtonClicked(sender: AnyObject) {
        self.quantityLabel.text = "\(Int(self.quantityLabel.text!)! + 1)"
        self.product.quantity = Int(self.quantityLabel.text!)!
        self.tableView.reloadData()
    }
    
    @IBAction func addToShoppingCartButtonClicked(sender: AnyObject) {
        //get item quantity
        //get item id
        //add to shopping cart database
        //go to shopping cart view
        
        let cart : Cart = CartModel.getPendingCart()
        
        var savedCartItem:CartItem?
        let filteredCartItem = cart.cartItems.filter{$0.productId == self.product.id}
        let filteredSingleSelectModifier = self.modifiers.filter{$0.multipleSelect == false}
        
        for tempCartItem in filteredCartItem{
            var valid = true
            for tempModifier in filteredSingleSelectModifier{
                let filteredSelectedModifierOption = tempModifier.modifierOptions.filter{$0.selected == true}
                for tempModifierOption in filteredSelectedModifierOption{
                    let results = tempCartItem.cartModifiers.filter{$0.modifierId == tempModifier.id && $0.modifierOptionId == tempModifierOption.id}
                    if (results.isEmpty == true) {
                        valid = false
                    }
                }
            }
            if (valid == true){
                savedCartItem = tempCartItem
                break
            }
        }
        
        if (savedCartItem != nil){
            CartModel.removeCartItem(savedCartItem!)
            
            for modifier in self.modifiers{
                for modifierOption in modifier.modifierOptions{
                    if (modifierOption.quantity != 0){
                        let results = savedCartItem!.cartModifiers.filter{$0.modifierId == modifier.id && $0.modifierOptionId == modifierOption.id}
                        if (results.isEmpty == false) {
                            let cartModifier = results.first
                            
                            cartModifier?.quantity = (cartModifier?.quantity)! + modifierOption.quantity
                        } else {
                            let cartModifier:CartModifier = CartModifier.init(
                                guid: nil,
                                cartGuid: nil,
                                cartItemGuid: nil,
                                modifierId: modifier.id,
                                modifierOptionId: modifierOption.id,
                                quantity: modifierOption.quantity
                            )
                            cartModifier.names = modifierOption.names
                            
                            savedCartItem?.cartModifiers.append(cartModifier)
                            savedCartItem?.price = NSDecimalNumber.init(string:savedCartItem?.price).decimalNumberByAdding(NSDecimalNumber.init(string:modifierOption.price)).stringValue
                        }
                    }
                }
            }
            
            savedCartItem?.quantity = (savedCartItem?.quantity)! + self.product.quantity
            let total:NSDecimalNumber = NSDecimalNumber.init(string: savedCartItem?.price).decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:savedCartItem!.quantity!))
            savedCartItem?.total = total.stringValue
            
            CartModel.addCartItem(savedCartItem!)
            
        } else {

            var price:NSDecimalNumber = NSDecimalNumber.init(longLong: 0)
            
            var cartModifiers:[CartModifier] = [CartModifier]()
            for modifier in self.modifiers{
                for modifierOption in modifier.modifierOptions{
                    if (modifierOption.quantity != 0){
                        let cartModifier:CartModifier = CartModifier.init(
                            guid: nil,
                            cartGuid: nil,
                            cartItemGuid: nil,
                            modifierId: modifier.id,
                            modifierOptionId: modifierOption.id,
                            quantity: modifierOption.quantity
                        )
                        cartModifier.names = modifierOption.names
                        
                        let modifierPrice:NSDecimalNumber = NSDecimalNumber.init(string: modifierOption.price)
                        price = price.decimalNumberByAdding(modifierPrice)
                        
                        cartModifiers.append(cartModifier)
                    }
                }
            }
            
            let total:NSDecimalNumber = price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:self.product.quantity))
            
            let cartItem:CartItem = CartItem.init(
                guid: nil,
                cartGuid: nil,
                productId: self.product.id,
                quantity: self.product.quantity,
                price: price.stringValue,
                total: total.stringValue
            )
            cartItem.names = self.product.names
            cartItem.cartModifiers = cartModifiers
            
            CartModel.addCartItem(cartItem)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var totalHeight = 18
        totalHeight += 38
        
        let modifier = self.modifiers[indexPath.row]
        totalHeight += modifier.modifierOptions.count * 38
        
        self.contentViewHeightConstraint.constant = 366.0 + tableView.contentSize.height
        
        return CGFloat(totalHeight)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modifiers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ModifierTableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! ModifierTableViewCell
        cell.tableView.delegate = cell;
        cell.tableView.dataSource = cell;
        
        let modifier = self.modifiers[indexPath.row]
        cell.modifier = modifier
        cell.quantityDidChange(self.product.quantity)
        cell.resetToDefault()
        cell.refreshCurrentQuantity()
        cell.refresh();
        cell.validateModifier()
    
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
