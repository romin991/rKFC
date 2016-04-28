//
//  CustomCollectionViewCell.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/14/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ribbonView: UIImageView!
    @IBOutlet weak var breakfastFilterView: UIView!
    @IBOutlet weak var breakfastTimeLabel: UILabel!
    @IBOutlet weak var breakfastTitleLabel: UILabel!
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if (self.ribbonView != nil){
//            CustomView.custom(self.ribbonView, borderColor: UIColor.clearColor(), cornerRadius: 5.0, roundingCorners: UIRectCorner.BottomLeft, borderWidth: 0)
//        }
        
        if (self.borderView != nil){
            CustomView.custom(self.borderView, borderColor: self.borderView.backgroundColor!, cornerRadius: 5.0, roundingCorners: UIRectCorner.AllCorners, borderWidth: 0)
            self.borderView.layer.masksToBounds = false
            self.borderView.layer.shadowColor = UIColor.blackColor().CGColor
            self.borderView.layer.shadowOpacity = 0.5
            self.borderView.layer.shadowRadius = 1.0
            self.borderView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        }
    }

}
