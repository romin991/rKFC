//
//  tocViewController.swift
//  KFC
//
//  Created by Romin Adi Santoso on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class TocViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var drawerButton: UIButton!

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleToc: UILabel!
    
    var drawerDelegate:DrawerDelegate?
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"refreshLanguage", name: NotificationKey.LanguageChanged, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNotification()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let viewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        
        if (viewController is RegisterViewController){
            self.drawerButton.hidden = true
            self.backButton.hidden = false
        } else {
            self.drawerButton.hidden = false
            self.backButton.hidden = true
        }
    }
    
    func refreshLanguage() -> Void {
        let url:NSURL!
        let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String

        self.titleToc.text = Wording.Menu.Toc[languageId]
        if (languageId == LanguageID.English){
            url = NSURL(string: "http://36.66.78.251/contents/en/term.html")
        } else {
            url = NSURL(string: "http://36.66.78.251/contents/id/term.html")
        }

        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        refreshLanguage()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func drawerButtonClicked(sender: AnyObject) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.openLeftMenu()
        }
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
