//
//  LeftViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/14/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let menus:[String] = [Menu.Account, Menu.Main, Menu.History, Menu.Menu, Menu.Promo, Menu.ChangeLanguage, Menu.Logout]
    var drawerDelegate:DrawerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableViewDataSource & TableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0){
            return 127
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
            
            if (title == Menu.Main){
                cell.imageBackground.image = UIImage.init(named: "MenuMain")
            } else if (title == Menu.History){
                cell.imageBackground.image = UIImage.init(named: "MenuHistory")
            } else if (title == Menu.Menu){
                cell.imageBackground.image = UIImage.init(named: "MenuHistory")
            } else if (title == Menu.Promo){
                cell.imageBackground.image = UIImage.init(named: "MenuPromo")
            } else if (title == Menu.ChangeLanguage){
                cell.imageBackground.image = UIImage.init(named: "MenuPromo")
            } else if (title == Menu.Logout){
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
