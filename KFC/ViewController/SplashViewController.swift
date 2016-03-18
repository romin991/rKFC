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
    
    //need to add this constraint
    @IBOutlet weak var heightBackgroundConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthBackgroundConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalBackgroundConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalBackgroundConstraint: NSLayoutConstraint!

    //need to remove this constraint
    @IBOutlet weak var topBackgroundConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingBackgroundConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBackgroundConstraint: NSLayoutConstraint!
    
    var loopAnimation : Bool = true
    
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
        UIView.animateWithDuration(10.0, animations: {
            self.view.removeConstraints([self.topBackgroundConstraint, self.bottomBackgroundConstraint, self.trailingBackgroundConstraint])
            self.view.addConstraints([self.verticalBackgroundConstraint, self.horizontalBackgroundConstraint])
            self.backgroundImageView.addConstraints([self.heightBackgroundConstraint, self.widthBackgroundConstraint])
            
            let randomZoom = CGFloat(self.view.frame.size.height) * self.randomZoomLevel()
            
            self.heightBackgroundConstraint.constant = randomZoom
            self.widthBackgroundConstraint.constant = randomZoom
            self.verticalBackgroundConstraint.constant = self.randomYPosition(randomZoom)
            self.horizontalBackgroundConstraint.constant = self.randomXPosition(randomZoom)
            
            self.backgroundImageView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if (self.loopAnimation){
                self.animateBackground()
            }
        })
    }

    func randomZoomLevel() -> CGFloat{
        let r : CGFloat = CGFloat(arc4random_uniform(5)) + 10
        return r / 10
    }
    
    func randomXPosition(zoomGap: CGFloat) -> CGFloat{
        let limit = (self.view.frame.size.height / 2) - (self.view.frame.size.width / 2)
        return CGFloat(arc4random_uniform(UInt32(limit * 2))) - limit
    }
    
    func randomYPosition(zoomGap: CGFloat) -> CGFloat{
        let limit = (zoomGap - self.view.frame.size.height) / 2
        return CGFloat(arc4random_uniform(UInt32(limit * 2))) - limit
    }
    
//MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoginSegue"){
            loopAnimation = false
        }
    }
}

