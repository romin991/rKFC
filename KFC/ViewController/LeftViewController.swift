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
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshLanguage", name: NotificationKey.LanguageChanged, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshDataSource", name: NotificationKey.Login, object: nil)
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
    
    func refreshDataSource(){
        if (UserModel.getUser().customerId == ""){
            self.menus = [
                Menu.Home,
                Menu.Main,
                Menu.Menu,
                Menu.ChangeLanguage,
                Menu.Toc,
                Menu.Login
            ]
        } else {
            self.menus = [
                Menu.Account,
                Menu.Home,
                Menu.Main,
                Menu.History,
                Menu.Menu,
                Menu.ChangeLanguage,
                Menu.Toc,
                Menu.Logout
            ]
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshLanguage(){
        self.languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
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
            let menu:String = self.menus[indexPath.row]
            cell.imageBackground.contentMode = UIViewContentMode.Center
            
            if (menu == Menu.Account){
                cell.imageBackground.image = UIImage.init(named: "MenuAccount")
                cell.mainTitleLabel.text = Wording.Menu.Account[self.languageId]
            } else if (menu == Menu.Main){
                cell.imageBackground.image = UIImage.init(named: "MenuMain")
                cell.mainTitleLabel.text = Wording.Menu.Main[self.languageId]
            } else if (menu == Menu.History){
                cell.imageBackground.image = UIImage.init(named: "MenuHistory")
                cell.mainTitleLabel.text = Wording.Menu.History[self.languageId]
            } else if (menu == Menu.Menu){
                cell.imageBackground.image = UIImage.init(named: "MenuMenu")
                cell.mainTitleLabel.text = Wording.Menu.Menu[self.languageId]
            } else if (menu == Menu.Home){
                cell.imageBackground.image = UIImage.init(named: "MenuHome")
                cell.mainTitleLabel.text = Wording.Menu.Home[self.languageId]
            } else if (menu == Menu.ChangeLanguage){
                cell.imageBackground.image = UIImage.init(named: "MenuLanguage")
                cell.mainTitleLabel.text = Wording.Menu.ChangeLanguage[self.languageId]
            } else if (menu == Menu.Logout){
                cell.imageBackground.image = UIImage.init(named: "MenuLogout")
                cell.mainTitleLabel.text = Wording.Menu.Logout[self.languageId]
            } else if (menu == Menu.Login){
                cell.imageBackground.image = UIImage.init(named: "MenuLogout")
                cell.mainTitleLabel.text = Wording.Menu.Login[self.languageId]
            } else if (menu == Menu.Toc){
                cell.imageBackground.image = UIImage.init(named: "MenuToc")
                cell.mainTitleLabel.text = Wording.Menu.Toc[self.languageId]
            } else {
                cell.imageBackground.image = nil
                cell.mainTitleLabel.text = ""
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
