//
//  ProfileViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileViewController: UIViewController {
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var leftMenuButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var state:Bool = false
    var drawerDelegate:DrawerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.refresh()
        
        CustomView.custom(self.profileButton, borderColor: self.profileButton.backgroundColor!, cornerRadius: 30, roundingCorners: UIRectCorner.AllCorners, borderWidth: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(){
        if (self.state == true){
            self.profileButton.setTitle("Save Profile", forState: UIControlState.Normal)
            self.emailField.enabled = true
            self.nameField.enabled = true
            self.phoneField.enabled = true
            self.passwordField.enabled = true
            self.confirmPasswordField.enabled = true
        } else {
            self.profileButton.setTitle("Edit Profile", forState: UIControlState.Normal)
            self.emailField.enabled = false
            self.nameField.enabled = false
            self.phoneField.enabled = false
            self.passwordField.enabled = false
            self.confirmPasswordField.enabled = false
        }
    }
    
    @IBAction func shoppingCartButtonClicked(sender: AnyObject) {
        let cartViewController:ShoppingCartViewController = (UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingCartViewController") as? ShoppingCartViewController)!
        cartViewController.drawerDelegate = self.drawerDelegate
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }

    @IBAction func leftMenuButtonClicked(sender: AnyObject) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.openLeftMenu()
        }
    }
    
    @IBAction func profileButtonClicked(sender: AnyObject) {
        if (self.state == true){
            //show activity indicator
            let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            activityIndicator.mode = MBProgressHUDMode.Indeterminate;
            activityIndicator.labelText = "Loading";
            
            //parse data to object 
            //call API update profile
            //if success then set state to false and refresh
            //else show error message
            //remove activity indicator
        
        } else {
            self.state = !self.state
            self.refresh()
        }
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
