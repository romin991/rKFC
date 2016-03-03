//
//  LoginViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/24/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD
import FBSDKLoginKit
import FBSDKShareKit
import TwitterKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    @IBOutlet weak var loginWithGoogleButton: UIButton!
    @IBOutlet weak var loginWithTwitterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtonClicked(sender: AnyObject) {
        LoginModel.loginWithBlock { (result, message) -> Void in
            if (result == true){
                self .performSegueWithIdentifier("MainSegue", sender: nil)
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
        self.performSegueWithIdentifier("MainSegue", sender: nil)
    }
    
    @IBAction func loginWithFacebookButtonClicked(sender: AnyObject) {
        let signIn = FBSDKLoginManager.init()
        signIn.logInWithReadPermissions(["public_profile"], fromViewController: self) { (loginResult, error) -> Void in
            if (error != nil) {
                print("Process error")
            } else if (loginResult.isCancelled) {
                print("Cancelled")
            } else {
                print("Logged in (Facebook)")
            }
        }
    }
    
    @IBAction func loginWithGoogleButtonClicked(sender: AnyObject) {
        let signIn = GIDSignInButton.init()
        signIn.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    
    @IBAction func loginWithTwitterButtonClicked(sender: AnyObject) {
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
    
//MARK: GIDSignInDelegate
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            if (error == nil) {
                // Perform any operations on signed in user here.
                //let userId = user.userID                  // For client-side use only!
                //let idToken = user.authentication.idToken // Safe to send to the server
                //let name = user.profile.name
                //let email = user.profile.email
                print("Logged in (Google)")
            } else {
                print("\(error.localizedDescription)")
            }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            // Perform any operations when the user disconnects from app here.
            // ...
    }
    
////MARK Google Sign In
//    // Stop the UIActivityIndicatorView animation that was started when the user
//    // pressed the Sign In button
//    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
//        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
//        activityIndicator.labelText = "Loading";
//    }
//    
//    // Present a view that prompts the user to sign in with Google
//    func signIn(signIn: GIDSignIn!,
//        presentViewController viewController: UIViewController!) {
//        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//        self.presentViewController(viewController, animated: true, completion: nil)
//    }
//    
//    // Dismiss the "Sign in with Google" view
//    func signIn(signIn: GIDSignIn!,
//        dismissViewController viewController: UIViewController!) {
//        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//    }
//    
//    //if you want to sign out
//    @IBAction func didTapSignOut(sender: AnyObject) {
//        GIDSignIn.sharedInstance().signOut()
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
