//
//  ProductViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shoppingCartBadgesView: UIView!
    @IBOutlet weak var shoppingCartBadgesLabel: UILabel!
    
    var products = [Product]()
    var category : Category!
    var selectedProduct : Product?
    var drawerDelegate:DrawerDelegate?
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshTableView", name: NotificationKey.ImageItemDownloaded, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.products = ProductModel.getProductByCategory(category)
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let cart:Cart = CartModel.getPendingCart()
        self.shoppingCartBadgesLabel.text = "\(cart.quantity!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTableView(){
        self.tableView?.reloadData()
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shoppingCartButtonClicked(sender: AnyObject) {
        let cartViewController:ShoppingCartViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingCartViewController") as? ShoppingCartViewController)!
        cartViewController.drawerDelegate = self.drawerDelegate
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0){
            return 166
        } else if (indexPath.section == 1){
            return 108
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 1){
            self.selectedProduct = self.products[indexPath.row]
            
            let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            activityIndicator.mode = MBProgressHUDMode.Indeterminate;
            activityIndicator.labelText = "Loading";
            
            let store = StoreModel.getSelectedStore()
            
            MainModel.getProductDetail(self.selectedProduct!, store:store, completion: { (status, message, modifiers) -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if (status == Status.Success){
                    self.performSegueWithIdentifier("ProductDetailSegue", sender: modifiers)
                } else {
                    let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        } else if (section == 1){
            return self.products.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell
        
        if (indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
            
            cell.mainTitleLabel?.text = self.category.name
            
            //TODO: category image still not found in API, fix this after the API fixed
            cell.imageBackground?.backgroundColor = UIColor.grayColor()
            
        } else if (indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier( "ProductCell", forIndexPath: indexPath) as! CustomTableViewCell
            
            let product:Product = self.products[indexPath.row]
            cell.mainTitleLabel?.text = product.name
            cell.subtitleLabel?.text = product.note
            cell.priceLabel?.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string: product.price))
            let path = CommonFunction.generatePathAt(Path.ProductImage, filename: product.id!)
            let data = NSFileManager.defaultManager().contentsAtPath(path)
            if (data != nil) {
                cell.imageBackground?.image = UIImage.init(data: data!)
            } else {
                cell.imageBackground?.image = nil
            }
            
        } else {
            return UITableViewCell.init()
        }
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ProductDetailSegue"){
            if let modifiers = sender as? [Modifier] {
                let productDetailViewController:ProductDetailViewController = segue.destinationViewController as! ProductDetailViewController
                productDetailViewController.product = self.selectedProduct
                productDetailViewController.modifiers = modifiers
                productDetailViewController.category = self.category
                productDetailViewController.drawerDelegate = self.drawerDelegate
            }
        }
    }

}
