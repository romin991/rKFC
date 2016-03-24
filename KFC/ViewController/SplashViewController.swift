//
//  ViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/23/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoButtonYPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.animateBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoButtonClicked(sender: AnyObject) {
        let user:User = UserModel.getUser()
        if (user.customerId != ""){
            self.performSegueWithIdentifier("DrawerSegue", sender: nil)
        } else {
            self.performSegueWithIdentifier("LoginSegue", sender: nil)
        }
    }
    
    func animateBackground(){
        UIView.animateWithDuration(0.6, animations: {
            self.logoButtonYPositionConstraint.constant = 0
            self.logoButton.alpha = 1.0
            self.backgroundImageView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}

