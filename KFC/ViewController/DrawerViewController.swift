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
    
    override func loadView() {
        super.loadView()
        
        let leftViewController:LeftViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as? LeftViewController)!
        leftViewController.drawerDelegate = self
        
        self.drawerController = MMDrawerController.init()
        
        self.drawerController?.leftDrawerViewController = leftViewController
        self.drawerController?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.TapCenterView
        self.drawerController?.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.None
        self.drawerController?.maximumLeftDrawerWidth = self.view.frame.width - 40
        
        self.selectMenu(Menu.Main)
        
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
            let centerViewController:MainViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController") as? MainViewController)!
            centerViewController.drawerDelegate = self
            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.History){
//            let centerViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController")
//            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.Menu) {
            let centerViewController:CategoryViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CategoryViewController") as? CategoryViewController)!
            centerViewController.drawerDelegate = self
            self.drawerController?.centerViewController = centerViewController
            
        } else if (menu == Menu.Logout){
            LoginModel.logout()
            self.navigationController?.popToRootViewControllerAnimated(false)
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
