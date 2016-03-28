//
//  ShoppingCartItemViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/23/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class ShoppingCartItemViewController: UIViewController {
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
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
        CustomView.custom(self.saveButton, borderColor: self.saveButton.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        if (self.product != nil){
            self.refreshImageView()
            self.navigationTitleLabel.text = self.product.names.filter{$0.languageId == self.languageId}.first?.name
            self.titleLabel.text = self.product.names.filter{$0.languageId == self.languageId}.first?.name
            self.subtitleLabel.text = self.product.notes.filter{$0.languageId == self.languageId}.first?.name
            
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
        }
        
        //change language label
        self.chooseQuantityLabel.text = ShoppingCart.ChooseQuantity[self.languageId]
        self.saveButton.setTitle(Common.Save[self.languageId], forState: UIControlState.Normal)
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
        if (cell.isFirstTime == true){
            cell.isFirstTime = false
        } else {
            cell.resetToDefault()
        }
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
