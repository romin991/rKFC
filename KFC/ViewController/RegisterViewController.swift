//
//  RegisterViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/8/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {

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
    
    var datePicker = UIDatePicker.init()
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        self.datePicker.addTarget(self, action: "updateDate:", forControlEvents: UIControlEvents.ValueChanged)
        self.birthdateField.inputView = self.datePicker
        
        CustomView.custom(self.signUpButton, borderColor: self.signUpButton.backgroundColor!, cornerRadius: 28, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        if (self.username != nil && self.username != ""){
            self.emailField.text = self.username
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:UITextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == self.phoneField){
            if (self.phoneField.text?.characters.first == "0"){
                let replacedString = NSString.init(string: self.phoneField.text!).stringByReplacingCharactersInRange(NSMakeRange(0,1), withString: "62") as String
                self.phoneField.text = replacedString
            }
        }
    }
    
    func updateDate(sender:AnyObject){
        let dateformatter = NSDateFormatter.init()
        dateformatter.dateFormat = "yyyy-MM-dd"
        self.birthdateField.text = dateformatter.stringFromDate(self.datePicker.date)
    }
    
    @IBAction func signUpButtonClicked(sender: AnyObject) {
        //show activity indicator
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        let gender = self.genderMaleButton.selected == true ? Gender.Male[LanguageID.English] : Gender.Female[LanguageID.English]
        let languageID = self.languageEnglishButton.selected == true ? LanguageID.English : LanguageID.Indonesia
        
        let formatter = NSDateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        
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
        
        LoginModel.register(user) { (status, message, user) -> Void in
            if (status == Status.Success){
                self.performSegueWithIdentifier("ValidationSegue", sender: user)
            } else {
                //should show alert error
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
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
        if (segue.identifier == "ValidationSegue"){
            if let user = sender as? User {
                let validationViewController:ValidationViewController = segue.destinationViewController as! ValidationViewController
                validationViewController.user = user
            }
        }
    }

}
