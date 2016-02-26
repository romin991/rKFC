//
//  ViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 2/23/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("LoginSegue", sender: nil)
    }

}

