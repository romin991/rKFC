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
    @IBOutlet weak var birthdateField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var languageEnglishButton: UIButton!
    @IBOutlet weak var languageIndonesiaButton: UIButton!
    @IBOutlet weak var genderMaleButton: UIButton!
    @IBOutlet weak var genderFemaleButton: UIButton!
    
    var state:Bool = false
    var drawerDelegate:DrawerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let user = UserModel.getUser()
        
        let formatter = NSDateFormatter.init()
        
        self.emailField.text = user.username
        self.nameField.text = user.fullname
        self.phoneField.text = user.handphone
        self.birthdateField.text = formatter.stringFromDate(user.birthdate!)
        self.addressField.text = user.address
        if (user.gender == Gender.Male){
            self.genderMaleButton.selected = true
            self.genderFemaleButton.selected = false
        } else {
            self.genderMaleButton.selected = false
            self.genderFemaleButton.selected = true
        }
        
        if (user.languageId == LanguageID.English){
            self.languageEnglishButton.selected = true
            self.languageIndonesiaButton.selected = false
        } else {
            self.languageEnglishButton.selected = false
            self.languageIndonesiaButton.selected = true
        }
        
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
            self.birthdateField.enabled = true
            self.addressField.enabled = true
            self.genderMaleButton.enabled = true
            self.genderFemaleButton.enabled = true
            self.languageEnglishButton.enabled = true
            self.languageIndonesiaButton.enabled = true
        } else {
            self.profileButton.setTitle("Edit Profile", forState: UIControlState.Normal)
            self.emailField.enabled = false
            self.nameField.enabled = false
            self.phoneField.enabled = false
            self.passwordField.enabled = false
            self.confirmPasswordField.enabled = false
            self.birthdateField.enabled = false
            self.addressField.enabled = false
            self.genderMaleButton.enabled = false
            self.genderFemaleButton.enabled = false
            self.languageEnglishButton.enabled = false
            self.languageIndonesiaButton.enabled = false
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
            
            let formatter = NSDateFormatter.init()
            
            let user = UserModel.getUser()
            user.fullname = self.nameField.text
            user.username = self.emailField.text
            user.handphone = self.phoneField.text
            user.birthdate = formatter.dateFromString(self.birthdateField.text!)
            user.address = self.addressField.text
            
            if (self.genderMaleButton.selected){
                user.gender = Gender.Male
            } else {
                user.gender = Gender.Female
            }
            
            if (self.languageEnglishButton.selected){
                user.languageId = LanguageID.English
            } else {
                user.languageId = LanguageID.Indonesia
            }
            
            //parse data to object 
            //call API update profile
            //if success then set state to false and refresh
            //else show error message
            //remove activity indicator
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        } else {
            self.state = !self.state
            self.refresh()
        }
    }
    
    @IBAction func languageButtonClicked(sender: AnyObject) {
        self.languageEnglishButton.selected = false
        self.languageIndonesiaButton.selected = false
        if let button = sender as? UIButton{
            button.selected = true
        }
    }
    
    @IBAction func genderButtonClicked(sender: AnyObject) {
        self.genderFemaleButton.selected = false
        self.genderMaleButton.selected = false
        if let button = sender as? UIButton{
            button.selected = true
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
