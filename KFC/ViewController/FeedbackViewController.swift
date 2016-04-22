//
//  FeedbackViewController.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit
import MBProgressHUD

class FeedbackViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var oneStarButton: UIButton!
    @IBOutlet weak var twoStarButton: UIButton!
    @IBOutlet weak var threeStarButton: UIButton!
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var fiveStarButton: UIButton!
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    var rating:String = ""
    var feedbacks:[Feedback] = [Feedback]()
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
    var selectedAnswer = ""
    var selectedCart:Cart?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate;
        activityIndicator.labelText = "Loading";
        
        FeedbackModel.deleteAllFeedback()
        OrderModel.getFeedbackForm { (status, message) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        
        self.titleLabel.text = Wording.History.RateThisOrder[self.languageId]
        self.sendButton.setTitle(Wording.Common.Send[self.languageId], forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func rateButtonClicked(sender: AnyObject) {
        self.oneStarButton.selected = false
        self.twoStarButton.selected = false
        self.threeStarButton.selected = false
        self.fourStarButton.selected = false
        self.fiveStarButton.selected = false
        
        let selectedButton = sender as! UIButton
        if (selectedButton == self.oneStarButton){
            self.oneStarButton.selected = true
            self.rating = "1"
            
        } else if (selectedButton == self.twoStarButton){
            self.oneStarButton.selected = true
            self.twoStarButton.selected = true
            self.rating = "2"
            
        } else if (selectedButton == self.threeStarButton){
            self.oneStarButton.selected = true
            self.twoStarButton.selected = true
            self.threeStarButton.selected = true
            self.rating = "3"
            
        } else if (selectedButton == self.fourStarButton){
            self.oneStarButton.selected = true
            self.twoStarButton.selected = true
            self.threeStarButton.selected = true
            self.fourStarButton.selected = true
            self.rating = "4"
            
        } else if (selectedButton == self.fiveStarButton){
            self.oneStarButton.selected = true
            self.twoStarButton.selected = true
            self.threeStarButton.selected = true
            self.fourStarButton.selected = true
            self.fiveStarButton.selected = true
            self.rating = "5"
        }
        
        self.feedbacks = FeedbackModel.getFeedbackByRating(self.rating)
        if (self.questionLabel.hidden == true) {
            self.questionLabel.hidden = false
        }
        if (self.feedbacks.count != 0) {
            self.questionLabel.text = self.feedbacks.first?.questions.filter{$0.languageId == self.languageId}.first?.name ?? ""
        } else {
            self.questionLabel.text = ""
        }
        self.selectedAnswer = ""
        
        let titleHeight = NSString.init(string: self.questionLabel.text!).boundingRectWithSize(CGSizeMake(self.view.frame.size.width - 40, CGFloat.max), options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.questionLabel.font!], context: nil).height
        self.contentViewHeightConstraint.constant = CGFloat(385 + (self.feedbacks.count * 44)) + titleHeight
        self.tableView.reloadData()
    }
    
    @IBAction func sendButtonClicked(sender: AnyObject) {
        if (self.rating == ""){
            
        } else if (self.selectedAnswer == "") {
            
        } else {
            self.selectedCart?.feedbackRating = self.rating
            self.selectedCart?.feedbackAnswerId = self.selectedAnswer
            self.selectedCart?.feedbackNotes = self.textView.text
            OrderModel.sendFeedback(self.selectedCart!) { (status, message) -> Void in
                if (status == Status.Success){
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    let languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String
                    let alert: UIAlertController = UIAlertController(title: Status.Error, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: Wording.Common.OK[languageId], style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feedback = self.feedbacks[indexPath.row]
        self.selectedAnswer = feedback.id!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedbacks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let feedback = self.feedbacks[indexPath.row]
        cell.mainTitleLabel.text = feedback.answers.filter{$0.languageId == self.languageId}.first?.name ?? ""
        
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
