//
//  LeftViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/14/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var drawerDelegate:DrawerDelegate?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    var menus:[String] = []
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshDataSource", name: NotificationKey.LanguageChanged, object: nil)
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
        self.refreshDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshDataSource(){
        self.languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
        self.menus = [
            Menu.Account[self.languageId]!,
            Menu.Main[self.languageId]!,
            Menu.History[self.languageId]!,
            Menu.Menu[self.languageId]!,
            Menu.Promo[self.languageId]!,
            Menu.ChangeLanguage[self.languageId]!,
            Menu.Logout[self.languageId]!
        ]
        self.tableView.reloadData()
    }
    
    //MARK: TableViewDataSource & TableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0){
            return 191
        } else if (indexPath.section == 1){
            return 56
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.selectMenu(self.menus[indexPath.row])
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        } else if (section == 1){
            return self.menus.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell
        
        if (indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier( "LogoCell", forIndexPath: indexPath) as! CustomTableViewCell
        } else if (indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
            let title:String = self.menus[indexPath.row]
            cell.mainTitleLabel.text = title
            
            if (title == Menu.Main[self.languageId]){
                cell.imageBackground.image = UIImage.init(named: "MenuMain")
            } else if (title == Menu.History[self.languageId]){
                cell.imageBackground.image = UIImage.init(named: "MenuHistory")
            } else if (title == Menu.Menu[self.languageId]){
                cell.imageBackground.image = UIImage.init(named: "MenuHistory")
            } else if (title == Menu.Promo[self.languageId]){
                cell.imageBackground.image = UIImage.init(named: "MenuPromo")
            } else if (title == Menu.ChangeLanguage[self.languageId]){
                cell.imageBackground.image = UIImage.init(named: "MenuPromo")
            } else if (title == Menu.Logout[self.languageId]){
                cell.imageBackground.image = UIImage.init(named: "MenuLogout")
            } else {
                cell.imageBackground.image = nil
            }
        } else {
            return UITableViewCell.init()
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
