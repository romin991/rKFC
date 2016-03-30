//
//  HistoryTableViewCell.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/29/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderDetailLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if (self.borderView != nil){
            CustomView.custom(borderView, borderColor: borderView.backgroundColor!, cornerRadius: 8, roundingCorners: UIRectCorner.AllCorners, borderWidth: 0)

            self.borderView.layer.shadowColor = UIColor.blackColor().CGColor
            self.borderView.layer.shadowOpacity = 0.5
            self.borderView.layer.shadowRadius = 4.0
            self.borderView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
            self.borderView.layer.masksToBounds = false
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
