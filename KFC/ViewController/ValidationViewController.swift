//
//  ValidationViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/8/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class ValidationViewController: UIViewController {
    @IBOutlet weak var validationCodeField: UITextField!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var user:User?
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CustomView.custom(self.validationCodeField, borderColor: self.validationCodeField.backgroundColor!, cornerRadius: 10, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.emailField, borderColor: self.emailField.backgroundColor!, cornerRadius: 10, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.sendButton, borderColor: self.sendButton.backgroundColor!, cornerRadius: 10, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        self.navigationTitleLabel.text = Wording.Login.Validation[self.languageId]
        self.titleLabel.text = Wording.Login.OneStepCloser[self.languageId]
        self.subtitleLabel.text = Wording.Login.InputValidationCode[self.languageId]
        self.sendButton.setTitle(Wording.Common.Send[self.languageId], forState: UIControlState.Normal)
        
        if (self.user?.username != ""){
            self.emailField.text = self.user?.username
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    @IBAction func sendButtonClicked(sender: AnyObject) {
        self.validationCodeField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        user?.verificationCode = self.validationCodeField.text
        user?.username = self.emailField.text
        
        LoginModel.validate(user!) { (status, message) -> Void in
            if (status == Status.Success){
                var lastViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
                if (!(lastViewController is LoginViewController)) {
                    lastViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
                }
                self.navigationController?.popToViewController(lastViewController!, animated: true)
            } else {
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.validationCodeField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        
        var lastViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        if (!(lastViewController is LoginViewController)) {
            lastViewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        }
        self.navigationController?.popToViewController(lastViewController!, animated: true)
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
