//
//  ShoppingCartItemViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/23/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class ShoppingCartItemViewController: UIViewController, ModifierParentDelegate {
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quantityMinusButton: UIButton!
    @IBOutlet weak var quantityPlusButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var warningView: UIView!

    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chooseQuantityLabel: UILabel!
    
    var product : Product!
    var modifiers : [Modifier]!
    var cartItem : CartItem!
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
        // Do any additional setup after loading the view.
        
        CustomView.custom(self.quantityView, borderColor: self.quantityView.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)

        self.refreshImageView()
        self.navigationTitleLabel.text = self.product.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
        self.titleLabel.text = self.product.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
        self.subtitleLabel.text = self.product.notes.filter{$0.languageId == self.languageId}.first?.name ?? ""
        self.priceLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:self.product.price))
        
        if (self.cartItem != nil){
            self.product.quantity = (self.cartItem?.quantity)!
            self.quantityLabel.text = "\(self.product.quantity)"
            
            for modifier:Modifier in self.modifiers{
                for modifierOption:ModifierOption in modifier.modifierOptions{
                    modifierOption.quantity = 0
                    modifierOption.selected = false
                    
                    for cartModifier:CartModifier in (self.cartItem?.cartModifiers)!{
                        if (modifier.id == cartModifier.modifierId && modifierOption.id == cartModifier.modifierOptionId){
                            modifierOption.quantity = cartModifier.quantity!
                            modifierOption.selected = true
                        }
                    }
                }
            }
        }
        
        self.refreshPrice()
        
        //change language label
        self.chooseQuantityLabel.text = Wording.ShoppingCart.ChooseQuantity[self.languageId]
        self.saveButton.setTitle(Wording.Common.Save[self.languageId], forState: UIControlState.Normal)
        
        //calculate scrollview contentView
        let maxWidth:CGFloat = self.view.frame.size.width - 40
        
        let subtitleHeight = NSString.init(string: self.subtitleLabel.text!).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.subtitleLabel.font!], context: nil).height
        let titleHeight = NSString.init(string: self.titleLabel.text!).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.titleLabel.font!], context: nil).height
        
        self.baseHeight = 347.0 + subtitleHeight + titleHeight
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
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        //remove old cartItem
        //then add new cartItem
        CartModel.removeCartItem(self.cartItem)
        
        let store = StoreModel.getSelectedStore()
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
        
        let subtotal:NSDecimalNumber = price.decimalNumberByMultiplyingBy(NSDecimalNumber.init(integer:self.product.quantity))
        
        var ppn:NSDecimalNumber = NSDecimalNumber.init(string: store.ppn).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(subtotal)
        var tax:NSDecimalNumber = NSDecimalNumber.init(string: store.tax).decimalNumberByDividingBy(NSDecimalNumber.init(long:100)).decimalNumberByMultiplyingBy(subtotal)
        
        var total:NSDecimalNumber = subtotal
        
        if (self.product.taxable == true){
            total = total.decimalNumberByAdding(tax)
        } else {
            tax = NSDecimalNumber.init(long: 0)
        }
        
        if (self.product.ppn == true){
            total = total.decimalNumberByAdding(ppn)
        } else {
            ppn = NSDecimalNumber.init(long: 0)
        }
        
        let cartItem:CartItem = CartItem.init(
            guid: nil,
            cartGuid: nil,
            productId: self.product.id,
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var totalHeight = 8
        totalHeight += 38
        
        let modifier = self.modifiers[indexPath.row]
        totalHeight += modifier.modifierOptions.count * 38
        
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
        if (cell.isFirstTime == true){
            cell.isFirstTime = false
        } else {
            cell.resetToDefault()
        }
        cell.refreshCurrentQuantity()
        cell.refresh();
        cell.validateModifier()
        cell.modifierParentDelegate = self
        
        return cell
    }
    
    //MARK:ModifierParentDelegate
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
