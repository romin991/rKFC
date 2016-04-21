//
//  tocViewController.swift
//  KFC
//
//  Created by Romin Adi Santoso on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class tocViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var drawerDelegate:DrawerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("refreshLanguage"), name: NotificationKey.LanguageChanged, object: nil)
        
                // Do any additional setup after loading the view.
    }
    @IBOutlet weak var titleToc: UILabel!
    func refreshLanguage() -> Void {
        let url:NSURL!
        let user = UserModel.getUser()
        if (!user.languageId!.isEmpty) {
            self.titleToc.text = Wording.Menu.Toc[user.languageId!]
            if (user.languageId == LanguageID.English){
                url = NSURL(string: "http://36.66.78.251/contents/en/term.html")
            } else {
                url = NSURL(string: "http://36.66.78.251/contents/id/term.html")
            }
        }
        else{
            self.titleToc.text = Wording.Menu.Toc[LanguageID.English]
            url = NSURL(string: "http://36.66.78.251/contents/en/term.html")
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
    
    @IBAction func back(sender: AnyObject) {
        if (self.drawerDelegate != nil){
            self.drawerDelegate?.openLeftMenu()
        }
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
