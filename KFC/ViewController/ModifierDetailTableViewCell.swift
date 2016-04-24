//
//  ProductDetailModifierTableViewCell.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class ModifierDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityMinusButton: UIButton!
    @IBOutlet weak var quantityPlusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    var modifierOption:ModifierOption?
    var delegate:ModifierDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func quantityMinusButtonClicked(sender: AnyObject) {
        if (self.delegate != nil){
            self.delegate?.minusQuantity(self.modifierOption!)
        }
    }
    
    @IBAction func quantityPlusButtonClicked(sender: AnyObject) {
        if (self.delegate != nil){
            self.delegate?.plusQuantity(self.modifierOption!)
        }
    }
    
    @IBAction func selectedButtonClicked(sender: AnyObject) {
        if (self.delegate != nil && self.modifierOption != nil){
            self.delegate?.selectModifier(self.modifierOption!)
        }
    }
}
