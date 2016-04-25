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

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var selectLanguageLabel: UILabel!
    @IBOutlet weak var languageEnglishButton: UIButton!
    @IBOutlet weak var languageIndonesiaButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var datePicker = UIDatePicker.init()
    var username:String?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (self.username != nil && self.username != ""){
            self.emailField.text = self.username
        }
        
        self.emailLabel.text = Wording.Profile.Email[self.languageId]
        self.nameLabel.text = Wording.Profile.Name[self.languageId]
        self.phoneLabel.text = Wording.Profile.PhoneNumber[self.languageId]
        self.passwordLabel.text = Wording.Profile.Password[self.languageId]
        self.confirmPasswordLabel.text = Wording.Profile.ConfirmPassword[self.languageId]
        self.selectLanguageLabel.text = Wording.Profile.Language[self.languageId]
        self.signUpButton.setTitle(Wording.Login.Register[self.languageId], forState: UIControlState.Normal)
        self.signInButton.setTitle(NSString.init(format:"%@ $@", Wording.Login.AlreadyHaveAnAccount[self.languageId]!, Wording.Login.LoginHere[self.languageId]!) as String, forState: UIControlState.Normal)
        self.skipButton.setTitle(Wording.Login.Skip[self.languageId], forState: UIControlState.Normal)
        
        CustomView.custom(self.skipButton, borderColor: UIColor.init(red: 191.0/255.0, green: 58.0/255.0, blue: 56.0/255.0, alpha: 1.0), cornerRadius: 0, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
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
    
    @IBAction func signUpButtonClicked(sender: AnyObject) {
        //show activity indicator
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
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
            gender: "",
            address: "",
            birthdate: NSDate()
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
    
    @IBAction func skipButtonClicked(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(LanguageID.English, forKey: "LanguageId")
        UserModel.updateUser(User.init())
        let loginViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2];
        self.navigationController?.popViewControllerAnimated(false)
        loginViewController?.performSegueWithIdentifier("MainSegue", sender: nil)
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
