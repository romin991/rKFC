//
//  SelectLanguageViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/17/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class SelectLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var registerDelegate:RegisterDelegate?

    @IBOutlet weak var tableView: UITableView!
    let languages:NSDictionary = [LanguangeID.Indonesia: "Indonesia", LanguangeID.English: "English"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let key = (self.languages.allKeys[indexPath.row] as? String)!
        let value = (self.languages.objectForKey(key) as? String)!
        self.registerDelegate?.languageSelected(key, language: value)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let key = (self.languages.allKeys[indexPath.row] as? String)!
        cell.mainTitleLabel?.text = self.languages.objectForKey(key) as? String
        
        return cell
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
