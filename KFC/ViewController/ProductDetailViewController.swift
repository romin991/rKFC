//
//  ProductDetailViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, ModifierParentDelegate {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
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
    @IBOutlet weak var shoppingCartButton: UIButton!
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chooseQuantityLabel: UILabel!
    var totalRow : Int?
    var product : Product!
    var category : Category!
    var modifiers : [Modifier]!
    var drawerDelegate:DrawerDelegate?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    var baseHeight:CGFloat = 347.0
    
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
        
        totalRow = 0
        for modifier in self.modifiers {
            if modifier.modifierOptions.count > 1 {
                totalRow  = totalRow! + 1;
            }
        }
        // Do any additional setup after loading the view.
        
        CustomView.custom(self.quantityView, borderColor: self.quantityView.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        self.refreshImageView()
        self.navigationTitleLabel.text = self.product.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
        self.titleLabel.text = self.product.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
        self.subtitleLabel.text = self.product.notes.filter{$0.languageId == self.languageId}.first?.name ?? ""
        self.priceLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string: self.product.price))
        
        //change label language
        self.chooseQuantityLabel.text = Wording.ShoppingCart.ChooseQuantity[self.languageId]
        self.addToShoppingCartButton.setTitle(Wording.ShoppingCart.AddToCart[self.languageId], forState: UIControlState.Normal)
        
        //calculate scrollview contentView
        let maxWidth:CGFloat = self.view.frame.size.width - 40
        
        let subtitleHeight = NSString.init(string: self.subtitleLabel.text!).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.subtitleLabel.font!], context: nil).height
        let titleHeight = NSString.init(string: self.titleLabel.text!).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.titleLabel.font!], context: nil).height
        
        self.baseHeight = 347.0 + subtitleHeight + titleHeight
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let cart:Cart = CartModel.getPendingCart()
        self.shoppingCartBadgesLabel.text = "\(cart.quantity!)"
        if (cart.cartItems.count == 0) {
            self.shoppingCartButton.enabled = false
        } else {
            self.shoppingCartButton.enabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.contentViewHeightConstraint.constant = self.baseHeight + self.tableView.contentSize.height
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
    
    func validate() -> String{
        var message = ""
        for modifier in self.modifiers{
            if (modifier.status == Status.Invalid){
                message = NSString.init(format: "%@ %@", Wording.Warning.QuantityFailed[self.languageId]!, modifier.names.filter{$0.languageId == self.languageId}.first?.name ?? "") as String
            }
        }
        
        if (self.category.id! == ImportantID.Breakfast){ //breakfast menu category
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
        
        return message
    }
    
    @IBAction func addToShoppingCartButtonClicked(sender: AnyObject) {
        //validate
        //get item quantity
        //get item id
        //add to shopping cart database
        //go to shopping cart view
        
        let message = self.validate()
        
        if (message != ""){
            let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let cart : Cart = CartModel.getPendingCart()
            let store : Store = StoreModel.getSelectedStore()
            
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
                
                var price:NSDecimalNumber = NSDecimalNumber.init(longLong: 0)
                var tax:NSDecimalNumber = NSDecimalNumber.init(longLong: 0)
                var ppn:NSDecimalNumber = NSDecimalNumber.init(longLong: 0)
                
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
                                
                            }
                            
                            let modifierPrice:NSDecimalNumber = NSDecimalNumber.init(string: modifierOption.price)
                            var modifierPPN:NSDecimalNumber = NSDecimalNumber.init(long: 0)
                            var modifierTax:NSDecimalNumber = NSDecimalNumber.init(long: 0)
                            
                            if (modifierOption.taxable == true) {
                                modifierTax =  NSDecimalNumber.init(string: store.tax).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(modifierPrice)
                                tax = tax.decimalNumberByAdding(modifierTax)
                            }
                            if (modifierOption.ppn == true) {
                                modifierPPN = NSDecimalNumber.init(string: store.ppn).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(modifierPrice)
                                ppn = ppn.decimalNumberByAdding(modifierPPN)
                            }
                            
                            price = price.decimalNumberByAdding(modifierPrice)
                        }
                        else if(modifierOption.quantity == 0 && modifierOption.selected!)
                        {
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
                                    quantity: modifier.minimumSelect! * product.quantity
                                )
                                cartModifier.names = modifierOption.names
                                savedCartItem?.cartModifiers.append(cartModifier)
                                
                            }
                            
                            let modifierPrice:NSDecimalNumber = NSDecimalNumber.init(string: modifierOption.price)
                            var modifierPPN:NSDecimalNumber = NSDecimalNumber.init(long: 0)
                            var modifierTax:NSDecimalNumber = NSDecimalNumber.init(long: 0)
                            
                            if (modifierOption.taxable == true) {
                                modifierTax =  NSDecimalNumber.init(string: store.tax).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(modifierPrice)
                                tax = tax.decimalNumberByAdding(modifierTax)
                            }
                            if (modifierOption.ppn == true) {
                                modifierPPN = NSDecimalNumber.init(string: store.ppn).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(modifierPrice)
                                ppn = ppn.decimalNumberByAdding(modifierPPN)
                            }
                            
                            price = price.decimalNumberByAdding(modifierPrice)
                        }

                    }
                }
                
                let quantity = (savedCartItem?.quantity)! + self.product.quantity
                let subtotal:NSDecimalNumber = price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:quantity))
                tax = tax.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:quantity))
                ppn = ppn.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:quantity))
                
                let total:NSDecimalNumber = subtotal.decimalNumberByAdding(tax).decimalNumberByAdding(ppn)
                
                savedCartItem?.quantity = quantity
                savedCartItem?.subtotal = subtotal.stringValue
                savedCartItem?.tax = tax.stringValue
                savedCartItem?.ppn = ppn.stringValue
                savedCartItem?.total = total.stringValue
                
                CartModel.addCartItem(savedCartItem!)
                
            } else {
                
                var price:NSDecimalNumber = NSDecimalNumber.init(longLong: 0)
                var tax:NSDecimalNumber = NSDecimalNumber.init(longLong: 0)
                var ppn:NSDecimalNumber = NSDecimalNumber.init(longLong: 0)
                
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
                            var modifierPPN:NSDecimalNumber = NSDecimalNumber.init(long: 0)
                            var modifierTax:NSDecimalNumber = NSDecimalNumber.init(long: 0)
                            
                            if (modifierOption.taxable == true) {
                                modifierTax =  NSDecimalNumber.init(string: store.tax).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(modifierPrice)
                                tax = tax.decimalNumberByAdding(modifierTax)
                            }
                            if (modifierOption.ppn == true) {
                                modifierPPN = NSDecimalNumber.init(string: store.ppn).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(modifierPrice)
                                ppn = ppn.decimalNumberByAdding(modifierPPN)
                            }
                            
                            price = price.decimalNumberByAdding(modifierPrice)
                            
                            cartModifiers.append(cartModifier)
                        }
                        else if (modifierOption.quantity == 0 && modifierOption.selected!)
                        {
                            let cartModifier:CartModifier = CartModifier.init(
                                guid: nil,
                                cartGuid: nil,
                                cartItemGuid: nil,
                                modifierId: modifier.id,
                                modifierOptionId: modifierOption.id,
                                quantity: modifier.minimumSelect! * product.quantity
                            )
                            cartModifier.names = modifierOption.names
                            
                            let modifierPrice:NSDecimalNumber = NSDecimalNumber.init(string: modifierOption.price)
                            var modifierPPN:NSDecimalNumber = NSDecimalNumber.init(long: 0)
                            var modifierTax:NSDecimalNumber = NSDecimalNumber.init(long: 0)
                            
                            if (modifierOption.taxable == true) {
                                modifierTax =  NSDecimalNumber.init(string: store.tax).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(modifierPrice)
                                tax = tax.decimalNumberByAdding(modifierTax)
                            }
                            if (modifierOption.ppn == true) {
                                modifierPPN = NSDecimalNumber.init(string: store.ppn).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(modifierPrice)
                                ppn = ppn.decimalNumberByAdding(modifierPPN)
                            }
                            
                            price = price.decimalNumberByAdding(modifierPrice)
                            
                            cartModifiers.append(cartModifier)
                        }
                    }
                }
                
                let subtotal:NSDecimalNumber = price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:self.product.quantity))
                tax = tax.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:self.product.quantity))
                ppn = ppn.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:self.product.quantity))
                
                let total:NSDecimalNumber = subtotal.decimalNumberByAdding(tax).decimalNumberByAdding(ppn)
                
                let cartItem:CartItem = CartItem.init(
                    guid: nil,
                    cartGuid: nil,
                    productId: self.product.id,
                    categoryId: self.category.id,
                    quantity: self.product.quantity,
                    price: price.stringValue,
                    tax: tax.stringValue,
                    ppn: ppn.stringValue,
                    subtotal: subtotal.stringValue,
                    total: total.stringValue
                )
                cartItem.names = self.product.names
                cartItem.cartModifiers = cartModifiers
                
                CartModel.addCartItem(cartItem)
            }
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var totalHeight = 8
        totalHeight += 38
        
        let modifier = self.modifiers[indexPath.row]
        if modifier.modifierOptions.count > 1 {
            totalHeight += modifier.modifierOptions.count * 38
        }
        
        
    
        
        return CGFloat(totalHeight)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalRow!
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
        cell.modifierParentDelegate = self
    
        return cell
    }
    
    //MARK: ModifierParentDelegate
    func refreshPrice() {
        var price:NSDecimalNumber = NSDecimalNumber.init(longLong: 0)
        
        for modifier in self.modifiers{
            for modifierOption in modifier.modifierOptions{
                if (modifierOption.quantity != 0){
                    let modifierPrice:NSDecimalNumber = NSDecimalNumber.init(string: modifierOption.price)
                    price = price.decimalNumberByAdding(modifierPrice)
                }
            }
        }
        
        self.priceLabel.text = CommonFunction.formatCurrency(price)
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
