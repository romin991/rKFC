//
//  RegisterViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/8/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterViewController: UIViewController, UIPopoverPresentationControllerDelegate {

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
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CustomView.custom(self.signUpButton, borderColor: self.signUpButton.backgroundColor!, cornerRadius: 28, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonClicked(sender: AnyObject) {
        //show activity indicator
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        let gender = self.genderMaleButton.selected == true ? Gender.Male[LanguageID.English] : Gender.Female[LanguageID.English]
        let languageID = self.languageEnglishButton.selected == true ? LanguageID.English : LanguageID.Indonesia
        
        let formatter = NSDateFormatter.init()
        //TODO: set to locale gmt +7
        
        let user:User = User.init(
            username: self.emailField.text,
            fullname: self.nameField.text,
            handphone: self.phoneField.text,
            password: self.passwordField.text,
            confirmPassword: self.confirmPasswordField.text,
            languageId: languageID,
            gender: gender,
            address: self.addressField.text,
            birthdate: formatter.dateFromString(self.birthdateField.text!)
        )
        
        LoginModel.register(user) { (status, message) -> Void in
            if (status == Status.Success){
                self.performSegueWithIdentifier("ValidationSegue", sender: nil)
            } else {
                //should show alert error
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    @IBAction func signInButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }

    @IBAction func selectLanguageButtonClicked(sender: AnyObject) {
        self.languageEnglishButton.selected = false
        self.languageIndonesiaButton.selected = false
        
        if let button = sender as? UIButton {
            button.selected = true
        }
    }
    
    @IBAction func selectGenderButtonClicked(sender: AnyObject) {
        self.genderFemaleButton.selected = false
        self.genderMaleButton.selected = false
        
        if let button = sender as? UIButton {
            button.selected = true
        }
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }

}
