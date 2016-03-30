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
import MBProgressHUD

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
        
        CustomView.custom(self.loginButton, borderColor: self.loginButton.backgroundColor!, cornerRadius: 28, roundingCorners: UIRectCorner.AllCorners, borderWidth: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtonClicked(sender: AnyObject) {
        //show activity indicator
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        let user:User = User.init(username: self.usernameField.text, password: self.passwordField.text, type: LoginType.Email)
        LoginModel.login(user, completion: { (status, message, user) -> Void in
            //TODO: need to check, if user already verified, then go to MainSegue, if not, then go to ValidationSegue
            
            if (status == Status.Success){
                self .performSegueWithIdentifier("MainSegue", sender: nil)
            } else {
                //should show alert error
                let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        })
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("RegisterSegue", sender: nil)
    }
    
    @IBAction func forgotPasswordButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("ForgotPasswordSegue", sender: nil)
    }
    
    @IBAction func skipButtonClicked(sender: AnyObject) {
//        self.performSegueWithIdentifier("MainSegue", sender: nil)
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
