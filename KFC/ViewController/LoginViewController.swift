//
//  LoginViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/24/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtonClicked(sender: AnyObject) {
        LoginModel.loginWithBlock { (result, message) -> Void in
            if (result == true){
                self .performSegueWithIdentifier("MainSegue", sender: nil);
            } else {
                //should show alert error
                let alert: UIAlertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        };
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
    }
    
    @IBAction func forgotPasswordButtonClicked(sender: AnyObject) {
    }
    
    @IBAction func skipButtonClicked(sender: AnyObject) {
    }
    
    @IBAction func loginWithFacebookButtonClicked(sender: AnyObject) {
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
