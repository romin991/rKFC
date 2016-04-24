//
//  ForgotPasswordViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/30/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!

    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CustomView.custom(self.emailAddressField, borderColor: self.emailAddressField.backgroundColor!, cornerRadius: 10, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        CustomView.custom(self.sendButton, borderColor: self.sendButton.backgroundColor!, cornerRadius: 10, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
        
        self.navigationTitleLabel.text = Wording.Login.ForgotPassword[self.languageId]
        self.titleLabel.text = Wording.Login.ForgotPassword[self.languageId]
        self.subtitleLabel.text = Wording.Login.InputValidationCode[self.languageId]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonClicked(sender: AnyObject) {
        self.emailAddressField.resignFirstResponder()
        
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        LoginModel.forgotPassword(self.emailAddressField.text!) { (status, message) -> Void in
            if (status == Status.Success){
                self.navigationController?.popViewControllerAnimated(true)
            } else {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
