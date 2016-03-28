//
//  DrawerViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/14/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MMDrawerController

protocol DrawerDelegate{
    func openLeftMenu()
    func selectMenu(menu:String)
}

class DrawerViewController: UIViewController, DrawerDelegate {

    var drawerController:MMDrawerController?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    override func loadView() {
        super.loadView()
        
        let leftViewController:LeftViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as? LeftViewController)!
        leftViewController.drawerDelegate = self
        
        self.drawerController = MMDrawerController.init()
        
        self.drawerController?.leftDrawerViewController = leftViewController
        self.drawerController?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.TapCenterView
        self.drawerController?.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.None
        self.drawerController?.maximumLeftDrawerWidth = self.view.frame.width - 40
        
        if (CartModel.isPendingCartNotEmpty()){
            self.selectMenu(Menu.Menu[self.languageId]!)
        } else {
            self.selectMenu(Menu.Main[self.languageId]!)
        }
        
        self.navigationController?.pushViewController(self.drawerController!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openLeftMenu(){
         self.drawerController?.openDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    func selectMenu(menu:String){
        self.navigationController?.popToViewController(self.drawerController!, animated: true)
        if (menu == Menu.Account[self.languageId]) {
            let centerViewController:ProfileViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController)!
            centerViewController.drawerDelegate = self
            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.Main[self.languageId]){
            if (CartModel.isPendingCartNotEmpty()){
                let alert: UIAlertController = UIAlertController(title: Common.Alert[self.languageId], message: Map.WarningClearShoppingCart[self.languageId], preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: Common.Cancel[self.languageId], style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: Common.OK[self.languageId], style: UIAlertActionStyle.Default) { (action) in
                    let centerViewController:MainViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController") as? MainViewController)!
                    centerViewController.drawerDelegate = self
                    self.drawerController?.centerViewController = centerViewController
                })
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                let centerViewController:MainViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController") as? MainViewController)!
                centerViewController.drawerDelegate = self
                self.drawerController?.centerViewController = centerViewController
                
            }
            
        } else if (menu == Menu.History[self.languageId]){
//            let centerViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController")
//            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.Menu[self.languageId]) {
            let centerViewController:CategoryViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CategoryViewController") as? CategoryViewController)!
            centerViewController.drawerDelegate = self
            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.ChangeLanguage[self.languageId]) {
            let user = UserModel.getUser()
            if (user.languageId == LanguageID.English){
                user.languageId = LanguageID.Indonesia
            } else {
                user.languageId = LanguageID.English
            }
            UserModel.updateUser(user)
            self.languageId = user.languageId!
            NSUserDefaults.standardUserDefaults().setObject(user.languageId, forKey: "LanguageId")
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.LanguageChanged, object: nil)
            
        } else if (menu == Menu.Logout[self.languageId]){
            LoginModel.logout()
            let rootViewController = self.navigationController?.viewControllers.first
            self.navigationController?.popToRootViewControllerAnimated(false)
            rootViewController?.performSegueWithIdentifier("LoginSegue", sender: nil)
        }
        self.drawerController?.closeDrawerAnimated(true, completion: nil)
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
