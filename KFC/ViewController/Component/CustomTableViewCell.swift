//
//  CustomTableViewCell.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderView2: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if (self.borderView != nil){
            CustomView.custom(borderView, borderColor: UIColor.whiteColor(), cornerRadius: 0, roundingCorners: UIRectCorner.AllCorners, borderWidth: 2)
        }
        if (self.borderView2 != nil){
            self.borderView2.layer.shadowColor = UIColor.blackColor().CGColor
            self.borderView2.layer.shadowOpacity = 0.5
            self.borderView2.layer.shadowRadius = 1.0
            self.borderView2.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
