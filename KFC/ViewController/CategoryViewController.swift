//
//  CategoryViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var shoppingCartBadgesView: UIView!
    @IBOutlet weak var shoppingCartBadgesLabel: UILabel!
    @IBOutlet weak var shoppingCartButton: UIButton!

    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var categories:[Category] = [Category]()
    var drawerDelegate:DrawerDelegate?
    var ads = AdsModel.getAdsType(AdsType.Store)
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshLanguage", name: NotificationKey.LanguageChanged, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshTableView", name: NotificationKey.ImageCategoryDownloaded, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNotification()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func refreshTableView(){
        self.categoryCollectionView?.reloadData()
    }
    
    func refreshLanguage(){
        self.languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        self.categoryCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.categories = CategoryModel.getAllCategory()
        CustomView.custom(self.shoppingCartBadgesView, borderColor: UIColor.whiteColor(), cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        if (self.ads.count > 0){
            self.pageControl.numberOfPages = self.ads.count;
            self.ads.append(self.ads.first!)
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftMenuButtonClicked(sender: AnyObject) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.openLeftMenu()
        }
    }

    
    @IBAction func shoppingCartButtonClicked(sender: AnyObject) {
        let cartViewController:ShoppingCartViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingCartViewController") as? ShoppingCartViewController)!
        cartViewController.drawerDelegate = self.drawerDelegate
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    @IBAction func pageControlValueChanged(sender: AnyObject) {
        self.adsCollectionView.scrollToItemAtIndexPath(NSIndexPath.init(forRow: self.pageControl.currentPage, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
    }
    
    //MARK: UICollectionViewDelegate && DataSource
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView == self.adsCollectionView){
            var page = Int(ceil(self.adsCollectionView.contentOffset.x / self.adsCollectionView.frame.size.width))
            if (page == self.ads.count - 1) {
                page = 0
                self.adsCollectionView.scrollToItemAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
            }
            self.pageControl.currentPage = page
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size:CGSize = CGSize()
        if (collectionView == self.categoryCollectionView){
            size = CGSizeMake(self.categoryCollectionView.frame.size.width / 2.0, self.categoryCollectionView.frame.size.width / 2.0)
        } else if (collectionView == self.adsCollectionView){
            size = CGSizeMake(self.adsCollectionView.frame.size.width, self.adsCollectionView.frame.size.height)
        }
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView == self.categoryCollectionView){
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            let category = self.categories[indexPath.row]
            if (category.id! != "16" || StoreModel.getSelectedStore().isBreakfast == true){ //breakfast menu category
                self.performSegueWithIdentifier("ProductListSegue", sender: category)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.categoryCollectionView){
            return self.categories.count
        } else if (collectionView == self.adsCollectionView) {
            return self.ads.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (collectionView == self.categoryCollectionView){
            let cell:CustomCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
            
            let category:Category = self.categories[indexPath.row];
            
            cell.breakfastFilterView.hidden = true
            cell.breakfastTimeLabel.hidden = true
            if (category.id! == ImportantID.Breakfast){ //breakfast menu category
                let store = StoreModel.getSelectedStore()
                if (store.isBreakfast == false){
                    cell.breakfastFilterView.hidden = false
                    cell.breakfastTitleLabel.text = Wording.Main.NotAvailable[self.languageId]?.uppercaseString
                    
                } else {
                    let now = NSDate()
                    let dateFormatter = NSDateFormatter.init()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let nowStringForDate = dateFormatter.stringFromDate(now)
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZZZZZ"
                    let breakfastStart = dateFormatter.dateFromString(NSString.init(format: "%@ %@", nowStringForDate, store.breakfastStart!) as String)
                    let breakfastEnd = dateFormatter.dateFromString(NSString.init(format: "%@ %@", nowStringForDate, store.breakfastEnd!) as String)
                    
                    if (now.compare(breakfastStart!) == NSComparisonResult.OrderedAscending || now.compare(breakfastEnd!) == NSComparisonResult.OrderedDescending){
                        //not available
                        dateFormatter.dateFormat = "HH aa"
                        
                        cell.breakfastTimeLabel.text = NSString.init(format: "%@ - %@", dateFormatter.stringFromDate(breakfastStart!), dateFormatter.stringFromDate(breakfastEnd!)) as String
                        cell.breakfastFilterView.hidden = false
                        cell.breakfastTimeLabel.hidden = false
                        cell.breakfastTitleLabel.text = Wording.Main.Close[self.languageId]?.uppercaseString
                        
                    }
                }
            }
            
            cell.titleLabel.text = category.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
            let path = CommonFunction.generatePathAt(Path.CategoryImage, filename: category.id!)
            let data = NSFileManager.defaultManager().contentsAtPath(path)
            if (data != nil) {
                cell.imageView.image = UIImage.init(data: data!)
            } else {
                cell.imageView.image = nil
            }
            
            return cell
            
        } else if (collectionView == self.adsCollectionView){
            let cell:AdsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! AdsCollectionViewCell
            
            let ads = self.ads[indexPath.row]
            let path = CommonFunction.generatePathAt((ads.image?.imagePath)!, filename: (ads.image?.guid)!)
            let data = NSFileManager.defaultManager().contentsAtPath(path)
            if (data != nil) {
                cell.image?.image = UIImage.init(data: data!)
            } else {
                cell.image?.image = nil
            }
            cell.layoutIfNeeded()
            
            return cell
        
        } else {
            return UICollectionViewCell.init()
            
        }
    }
    
    
    
    
    
    
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let category = self.categories[indexPath.row]
        self.performSegueWithIdentifier("ProductListSegue", sender: category)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let category:Category = self.categories[indexPath.row]
        cell.mainTitleLabel?.text = category.names.filter{$0.languageId == self.languageId}.first?.name ?? ""
        
        let path = CommonFunction.generatePathAt(Path.CategoryImage, filename: category.id!)
        let data = NSFileManager.defaultManager().contentsAtPath(path)
        if (data != nil) {
            cell.imageBackground?.image = UIImage.init(data: data!)
            cell.imageBackground?.backgroundColor = UIColor.whiteColor()
        } else {
            cell.imageBackground?.image = nil
            cell.imageBackground?.backgroundColor = UIColor.grayColor()
        }
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ProductListSegue"){
            if let category = sender as? Category {
                let productViewController:ProductViewController = segue.destinationViewController as! ProductViewController
                productViewController.category = category
                productViewController.drawerDelegate = self.drawerDelegate
            }
        }
    }

}
