//
//  ViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/23/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var logoButtonYPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.animateBackground()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.logoButtonYPositionConstraint.constant = 0
            self.logoButton.alpha = 1.0
            self.view.layoutIfNeeded()
        }) { (finish) -> Void in
            self.logoButtonClicked(self)
        }
    }

}

