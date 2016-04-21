//
//  DrawerViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/14/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MMDrawerController
import MBProgressHUD

protocol DrawerDelegate{
    func openLeftMenu()
    func selectMenu(menu:String)
}

class DrawerViewController: UIViewController, DrawerDelegate {

    var drawerController:MMDrawerController?
    
    override func loadView() {
        super.loadView()
        
        let leftViewController:LeftViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as? LeftViewController)!
        leftViewController.drawerDelegate = self
        
        self.drawerController = MMDrawerController.init()
        
        self.drawerController?.leftDrawerViewController = leftViewController
        self.drawerController?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.TapCenterView
        self.drawerController?.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.None
        self.drawerController?.maximumLeftDrawerWidth = self.view.frame.width - 40
        
        self.selectMenu(Menu.Promo)
    
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
        if (menu == Menu.Account) {
            let centerViewController:ProfileViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController)!
            centerViewController.drawerDelegate = self
            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.Main){
            if (CartModel.isPendingCartNotEmpty()){
                let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
                
                let alert: UIAlertController = UIAlertController(title: Wording.Common.Alert[languageId], message: Wording.Warning.ClearShoppingCart[languageId], preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: Wording.Common.Cancel[languageId], style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default) { (action) in
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
            
        } else if (menu == Menu.History){
            let centerViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController") as? HistoryViewController)!
            centerViewController.drawerDelegate = self
            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.Menu) {
            let store = StoreModel.getSelectedStore()
            if (store.id == nil || store.id == ""){
                self.selectMenu(Menu.Main)
            } else {
                let centerViewController:CategoryViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CategoryViewController") as? CategoryViewController)!
                centerViewController.drawerDelegate = self
                self.drawerController?.centerViewController = centerViewController
            }
            
        } else if (menu == Menu.Promo){
            let centerViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AdsViewController") as? AdsViewController)!
            centerViewController.drawerDelegate = self
            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.ChangeLanguage) {
            let user = UserModel.getUser()
            if (user.languageId == LanguageID.English){
                user.languageId = LanguageID.Indonesia
            } else {
                user.languageId = LanguageID.English
            }
            LoginModel.updateLanguage(user, completion: { (status, message, user) -> Void in
                if (status == Status.Success && user != nil){
                    UserModel.updateUser(user!)
                    NSUserDefaults.standardUserDefaults().setObject(user!.languageId, forKey: "LanguageId")
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.LanguageChanged, object: nil)
                } else {
                    let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            
        } else if (menu == Menu.Logout){
            let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            activityIndicator.mode = MBProgressHUDMode.Indeterminate;
            activityIndicator.labelText = "Loading";
            
            LoginModel.logout(UserModel.getUser(), completion: { (status, message) -> Void in
                if (status == Status.Success){
                    let loginViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController"))
                    let navigationController = self.navigationController
                    navigationController?.popToRootViewControllerAnimated(false)
                    navigationController?.pushViewController(loginViewController, animated: false)
                } else {
                    let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            })
        } else if (menu == Menu.Login){
            let loginViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController"))
            let navigationController = self.navigationController
            navigationController?.popToRootViewControllerAnimated(false)
            navigationController?.pushViewController(loginViewController, animated: false)
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
