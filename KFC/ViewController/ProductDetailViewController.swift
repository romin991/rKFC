//
//  ProductDetailViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

protocol ProductDetailDelegate{
    func getQuantity() -> Int
}

class ProductDetailViewController: UIViewController, ProductDetailDelegate {
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
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningHeightConstraint: NSLayoutConstraint!
    
    var product : Product!
    var category : Category!
    var modifiers : [Modifier]!
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshImageView", name: NotificationKey.ImageItemDownloaded, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CustomView.custom(self.quantityView, borderColor: self.quantityView.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.addToShoppingCartButton, borderColor: self.addToShoppingCartButton.backgroundColor!, cornerRadius: 22, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        if (self.product != nil){
            self.refreshImageView()
            self.titleLabel.text = self.product.name
            self.subtitleLabel.text = self.product.note
        }
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
        //TODO:
        //get item quantity
        //get item id
        //add to shopping cart database
        //go to shopping cart view
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
                        quantity: modifierOption.quantity,
                        name: modifierOption.name
                    )
                
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
            name: self.product.name,
            total: total.stringValue
        )
        cartItem.cartModifiers = cartModifiers
        
        CartModel.addCartItem(cartItem)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: ProductDetailDelegate
    func getQuantity() -> Int{
        return self.product.quantity
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
        let cell : ProductDetailTableViewCell
        
        cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! ProductDetailTableViewCell
        cell.tableView.delegate = cell;
        cell.tableView.dataSource = cell;
        
        let modifier = self.modifiers[indexPath.row]
        cell.modifier = modifier
        cell.productDetailDelegate = self
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
