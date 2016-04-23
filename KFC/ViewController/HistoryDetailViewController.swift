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
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var shoppingCartBadgesView: UIView!
    @IBOutlet weak var shoppingCartBadgesLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var subtotalValueLabel: UILabel!
    
    var drawerDelegate:DrawerDelegate?
    var cart:Cart?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    var dataSource = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.orderNumberLabel.text = Wording.History.OrderNumber[self.languageId]
        self.taxLabel.text = Wording.ShoppingCart.Tax[self.languageId]
        self.deliveryLabel.text = Wording.ShoppingCart.Delivery[self.languageId]
        self.totalLabel.text = Wording.ShoppingCart.Total[self.languageId]
        self.subtotalLabel.text = Wording.ShoppingCart.Subtotal[self.languageId]
        self.navigationTitle.text = Wording.History.OrderHistoryDetail[self.languageId]
        
        self.orderNumberValueLabel.text = NSString.init(format:"#%@", (cart?.transNo)!) as String
        self.subtotalValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart?.subtotal))
        self.taxValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart?.tax))
        self.deliveryValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart?.delivery))
        self.totalValueLabel.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string:cart?.total))
        self.addressLabel.text = cart?.address
        self.statusLabel.text = cart?.status
        
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        self.statusLabel.adjustsFontSizeToFitWidth = true
        
        self.generateDataSource()
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
    
    func generateDataSource(){
        for cartItem in (self.cart?.cartItems)!{
            let dictionary:[String:String] = [
                "CellIdentifier" : "Cell",
                "MainTitleLabel" : cartItem.names.filter{$0.languageId! == self.languageId}.first?.name ?? "",
                "QuantityLabel" : NSString.init(format: "%li", cartItem.quantity!) as String,
            ]
            self.dataSource.append(dictionary)
            
            for cartModifier in cartItem.cartModifiers{
                let dictionary:[String:String] = [
                    "CellIdentifier" : "IndentCell",
                    "MainTitleLabel" : cartModifier.names.filter{$0.languageId! == self.languageId}.first?.name ?? "",
                ]
                self.dataSource.append(dictionary)
            }
        }
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
        let data = self.dataSource[indexPath.row]
        let mainTitleString = data["MainTitleLabel"]!.string ?? ""
        var maxWidth:CGFloat = 0
        if (data["CellIdentifier"] as! String == "Cell") {
            maxWidth = self.tableView.frame.size.width - CGFloat(34)
        } else if (data["CellIdentifier"] as! String == "IndentCell"){
            maxWidth = self.tableView.frame.size.width - CGFloat(20)
        } else {
            maxWidth = 0
        }
        
        let mainTitleHeight = NSString.init(string: mainTitleString).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.init(name: "HelveticaNeue", size: 14)!], context: nil).height
        
        return mainTitleHeight + 15
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell;
        
        let data = self.dataSource[indexPath.row]
        if (data["CellIdentifier"] != nil && data["CellIdentifier"] as! String == "Cell"){
            cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
            cell.mainTitleLabel.text = data["MainTitleLabel"] as? String
            cell.quantityLabel.text = data["QuantityLabel"] as? String
        } else if (data["CellIdentifier"] != nil && data["CellIdentifier"] as! String == "IndentCell"){
            cell = tableView.dequeueReusableCellWithIdentifier( "IndentCell", forIndexPath: indexPath) as! CustomTableViewCell
            cell.mainTitleLabel.text = data["MainTitleLabel"] as? String
        } else {
            cell = CustomTableViewCell()
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
