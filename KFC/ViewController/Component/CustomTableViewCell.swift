//
//  CustomTableViewCell.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/10/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

protocol FavoriteAddressDelegate{
    func favoriteButtonClicked(address:Address?, favoriteButton:UIButton?)
}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var address:Address?
    var favoriteAddressDelegate:FavoriteAddressDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteButtonClicked(sender: AnyObject) {
        if (self.favoriteAddressDelegate != nil) {
            self.favoriteAddressDelegate?.favoriteButtonClicked(self.address, favoriteButton: self.favoriteButton)
        }
    }

}
