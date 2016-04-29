//
//  AdsViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/3/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class AdsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var drawerDelegate:DrawerDelegate?
    var ads = AdsModel.getAdsType(AdsType.General)
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String

    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshCollectionView", name: NotificationKey.ImageAdsDownloaded, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshLanguage", name: NotificationKey.LanguageChanged, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNotification()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func refreshLanguage(){
        self.languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        self.messageLabel.text = UserModel.getUser().fullname != "" ? UserModel.getUser().fullname : Wording.Main.YouAreNotLoggedIn[self.languageId]
        self.titleLabel.text = Wording.Main.Welcome[self.languageId]
        self.setLocationButton.setTitle(Wording.Main.OrderNow[self.languageId], forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CustomView.custom(self.setLocationButton, borderColor: self.setLocationButton.backgroundColor!, cornerRadius: 29, roundingCorners: UIRectCorner.AllCorners, borderWidth: 0)
        
        self.ads = AdsModel.getAdsType(AdsType.General)
        if (self.ads.count > 0){
            self.pageControl.numberOfPages = self.ads.count;
            self.ads.append(self.ads.first!)
        }
        
        self.refreshLanguage()
    }
    
    override func viewDidLayoutSubviews() {
        let layout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: self.collectionView.frame.size.height)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshCollectionView(){
        self.collectionView.reloadData()
    }
    
    @IBAction func leftMenuButtonClicked(sender: AnyObject) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.openLeftMenu()
        }
    }

    @IBAction func setLocationButtonClicked(sender: AnyObject) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.selectMenu(Menu.Main)
        }
    }
    
    @IBAction func pageControlValueChanged(sender: AnyObject) {
        self.collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forRow: self.pageControl.currentPage, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
    }
    
    //MARK:CollectionView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var page = Int(ceil(self.collectionView.contentOffset.x / self.collectionView.frame.size.width))
        if (page == self.ads.count - 1) {
            page = 0
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        }
        self.pageControl.currentPage = page
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ads.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
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
