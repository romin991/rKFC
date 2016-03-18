//
//  RegisterViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/8/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol RegisterDelegate{
    func languageSelected(languageID:String, language:String)
}

class RegisterViewController: UIViewController, RegisterDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var selectLanguageField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var languageID:String = LanguangeID.Indonesia
    
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
        
        let user:User = User.init(
            username: self.emailField.text,
            fullname: self.nameField.text,
            handphone: self.phoneField.text,
            password: self.passwordField.text,
            confirmPassword: self.confirmPasswordField.text,
            languageId: self.languageID
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
    
    func languageSelected(languageID:String, language:String) {
        self.selectLanguageField.text = language
        self.languageID = languageID
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SelectLanguageSegue") {
            let controller : SelectLanguageViewController = segue.destinationViewController as! SelectLanguageViewController
            controller.registerDelegate = self
            controller.popoverPresentationController!.delegate = self
            controller.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 2 * 44)
        }
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
