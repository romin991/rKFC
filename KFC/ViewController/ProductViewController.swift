//
//  ProductViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var shoppingCartBadgesView: UIView!
    @IBOutlet weak var shoppingCartBadgesLabel: UILabel!
    @IBOutlet weak var navigationTItleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shoppingCartButton: UIButton!
    
    var products = [Product]()
    var category : Category!
    var selectedProduct : Product?
    var drawerDelegate:DrawerDelegate?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refresh", name: NotificationKey.ImageItemDownloaded, object: nil)
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
        self.products = ProductModel.getProductByCategory(category)
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        self.navigationTItleLabel.text = self.category.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
    }
    
    func loadFTUE(){
        let ftueViewController:FTUEViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FTUEViewController") as? FTUEViewController)!
        ftueViewController.view.layoutSubviews()
        ftueViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        ftueViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.presentViewController(ftueViewController, animated: true, completion: nil)
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
        
        let firstTime = NSUserDefaults.standardUserDefaults().objectForKey("FirstTime") as! Bool
        if (cart.cartItems.count > 0  && firstTime == true){
            self.loadFTUE()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(){
        self.collectionView?.reloadData()
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shoppingCartButtonClicked(sender: AnyObject) {
        let cartViewController:ShoppingCartViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingCartViewController") as? ShoppingCartViewController)!
        cartViewController.drawerDelegate = self.drawerDelegate
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    //MARK: UICollectionViewDelegate && UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.collectionView.frame.size.width / 2.0, self.collectionView.frame.size.width / 2.0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier( "Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        let product:Product = self.products[indexPath.row]
        cell.titleLabel?.text = product.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
        cell.priceLabel?.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string: product.price))
        let path = CommonFunction.generatePathAt(Path.ProductImage, filename: product.id!)
        let data = NSFileManager.defaultManager().contentsAtPath(path)
        if (data != nil) {
            cell.imageView?.image = UIImage.init(data: data!)
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
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
                let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
                
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })

    }
    
    
    //MARK: UITableViewDelegate && UITableViewDataSource
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        if (indexPath.section == 0){
//            return 166
//        } else if (indexPath.section == 1){
//            let product:Product = self.products[indexPath.row]
//            let subtitle = product.notes.filter{$0.languageId == self.languageId}.first?.name ?? ""
//            let title = product.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
//            
//            let subtitleHeight = NSString.init(string: subtitle).boundingRectWithSize(CGSizeMake(self.maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.subtitleFont!], context: nil).height
//            let titleHeight = NSString.init(string: title).boundingRectWithSize(CGSizeMake(self.maxWidth, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.titleFont!], context: nil).height
//            
//            let height = ceil(subtitleHeight) + ceil(titleHeight) + 72
//            
//            return height
//        } else {
//            return 0
//        }
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        if (indexPath.section == 1){
//            self.selectedProduct = self.products[indexPath.row]
//            
//            let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            activityIndicator.mode = MBProgressHUDMode.Indeterminate;
//            activityIndicator.labelText = "Loading";
//            
//            let store = StoreModel.getSelectedStore()
//            
//            MainModel.getProductDetail(self.selectedProduct!, store:store, completion: { (status, message, modifiers) -> Void in
//                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                
//                if (status == Status.Success){
//                    self.performSegueWithIdentifier("ProductDetailSegue", sender: modifiers)
//                } else {
//                    let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
//                    
//                    let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                }
//            })
//        }
//    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (section == 0){
//            return 1
//        } else if (section == 1){
//            return self.products.count
//        } else {
//            return 0
//        }
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell : CustomTableViewCell
//        
//        if (indexPath.section == 0){
//            cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
//            
//            cell.mainTitleLabel?.text = self.category.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
//            
//            let path = CommonFunction.generatePathAt(Path.CategoryImage, filename: self.category.id!)
//            let data = NSFileManager.defaultManager().contentsAtPath(path)
//            if (data != nil) {
//                cell.imageBackground?.image = UIImage.init(data: data!)
//                cell.imageBackground?.backgroundColor = UIColor.whiteColor()
//            } else {
//                cell.imageBackground?.image = nil
//                cell.imageBackground?.backgroundColor = UIColor.grayColor()
//            }
//            
//        } else if (indexPath.section == 1){
//            cell = tableView.dequeueReusableCellWithIdentifier( "ProductCell", forIndexPath: indexPath) as! CustomTableViewCell
//            
//            let product:Product = self.products[indexPath.row]
//            cell.mainTitleLabel?.text = product.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
//            cell.subtitleLabel?.text = product.notes.filter{$0.languageId == self.languageId}.first?.name ?? ""
//            cell.priceLabel?.text = CommonFunction.formatCurrency(NSDecimalNumber.init(string: product.price))
//            let path = CommonFunction.generatePathAt(Path.ProductImage, filename: product.id!)
//            let data = NSFileManager.defaultManager().contentsAtPath(path)
//            if (data != nil) {
//                cell.imageBackground?.image = UIImage.init(data: data!)
//            } else {
//                cell.imageBackground?.image = nil
//            }
//            
//        } else {
//            return UITableViewCell.init()
//        }
//        
//        return cell
//    }

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
