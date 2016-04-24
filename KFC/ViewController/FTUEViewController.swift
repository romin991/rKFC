//
//  FTUEViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/22/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class FTUEViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.backgroundImage.image = UIImage.init(named: "FTUE")?.resizableImageWithCapInsets(UIEdgeInsets.init(top: 79, left: 1, bottom: 81, right: 79))
        self.titleLabel.text = Wording.ShoppingCart.Cart[self.languageId]
        self.subtitleLabel.text = Wording.Main.HereIsYourShoppingCart[self.languageId]
    }
    
    override func viewDidLayoutSubviews() {
        print("test")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonClicked(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "FirstTime")
        self.dismissViewControllerAnimated(true, completion: nil)
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
