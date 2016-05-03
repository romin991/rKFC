//
//  ErrorViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/3/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.titleLabel.text = Wording.Warning.Sorry[self.languageId]
        self.subtitleLabel.text = Wording.Warning.LocationOutOfRange[self.languageId]
        self.subtitleLabel.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        self.subtitleLabel.numberOfLines = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
