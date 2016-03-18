//
//  ProductDetailTableViewCell.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

protocol ProductDetailModifierDelegate{
    func plusQuantity(modifierOption:ModifierOption)
    func minusQuantity(modifierOption:ModifierOption)
    func selectModifier(modifierOption:ModifierOption)
    func refresh()
}

class ProductDetailTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, ProductDetailModifierDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var titleLabel:UILabel = UILabel.init()
    var productDetailDelegate:ProductDetailDelegate?
    var totalQuantity:Int = 0
    var modifier:Modifier? {
        didSet{
            for modifierOption in (modifier?.modifierOptions)!{
                if (modifierOption.defaultSelect == true){
                    modifierOption.quantity = (self.modifier?.minimumSelect)!
                    self.totalQuantity = modifierOption.quantity
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: ProductDetailModifierDelegate
    func refresh(){
        self.tableView.layer.shadowColor = UIColor.blackColor().CGColor
        self.tableView.layer.shadowOpacity = 0.5
        self.tableView.layer.shadowRadius = 2.0
        self.tableView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        self.tableView.layer.masksToBounds = false
        self.tableView.reloadData()
    }
    
    func plusQuantity(modifierOption: ModifierOption) {
        if (self.productDetailDelegate != nil){
            let minimum : Int = (self.productDetailDelegate?.getQuantity())! * (self.modifier?.minimumSelect)!
            let maximum : Int = (self.productDetailDelegate?.getQuantity())! * (self.modifier?.maximumSelect)!
            if (self.totalQuantity + 1 <= maximum){
                modifierOption.quantity += 1
                self.totalQuantity += 1
                
                if (self.totalQuantity >= minimum && self.totalQuantity <= maximum){
                    self.modifier?.status = Status.Valid
                } else {
                    self.modifier?.status = Status.Invalid
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func minusQuantity(modifierOption: ModifierOption) {
        if (self.productDetailDelegate != nil){
            let minimum : Int = (self.productDetailDelegate?.getQuantity())! * (self.modifier?.minimumSelect)!
            let maximum : Int = (self.productDetailDelegate?.getQuantity())! * (self.modifier?.maximumSelect)!
            if (modifierOption.quantity > 0){
                modifierOption.quantity -= 1
                self.totalQuantity -= 1
                
                if (self.totalQuantity >= minimum && self.totalQuantity <= maximum){
                    self.modifier?.status = Status.Valid
                } else {
                    self.modifier?.status = Status.Invalid
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func selectModifier(modifierOption: ModifierOption) {
        let quantity : Int = (self.productDetailDelegate?.getQuantity())!
        for tempModifierOption in (self.modifier?.modifierOptions)!{
            if (modifierOption == tempModifierOption){
                tempModifierOption.selected = true
                tempModifierOption.quantity = quantity
            } else {
                tempModifierOption.selected = false
                tempModifierOption.quantity = 0
            }
        }
        self.tableView.reloadData()
    }
    
    func validateModifier(){
        var tempTotalQuantity : Int = 0
        let minimum : Int = (self.productDetailDelegate?.getQuantity())! * (self.modifier?.minimumSelect)!
        let maximum : Int = (self.productDetailDelegate?.getQuantity())! * (self.modifier?.maximumSelect)!
        
        for tempModifierOption in (self.modifier?.modifierOptions)!{
            if (self.modifier?.multipleSelect == false && tempModifierOption.selected == true){
                tempModifierOption.quantity = (self.productDetailDelegate?.getQuantity())!
            }
            tempTotalQuantity += tempModifierOption.quantity
        }
        
        if (tempTotalQuantity >= minimum && tempTotalQuantity <= maximum){
            self.modifier?.status = Status.Valid
        } else {
            self.modifier?.status = Status.Invalid
        }
    }
    
    //MARK: UITableViewDelegate && UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        } else if (section == 1){
            return self.modifier != nil ? (self.modifier?.modifierOptions.count)! : 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ProductDetailModifierTableViewCell
        
        if (indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! ProductDetailModifierTableViewCell
            cell.titleLabel.text = modifier?.name
            
        } else if (indexPath.section == 1){
            let modifierOption = self.modifier?.modifierOptions[indexPath.row]
            
            if (modifier?.multipleSelect == true){
                cell = tableView.dequeueReusableCellWithIdentifier( "MultipleCell", forIndexPath: indexPath) as! ProductDetailModifierTableViewCell
                cell.modifierOption = modifierOption
                cell.titleLabel.text = modifierOption?.name
                cell.delegate = self
                cell.quantityLabel.text = "\((modifierOption?.quantity)!)"
                
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier( "SingleCell", forIndexPath: indexPath) as! ProductDetailModifierTableViewCell
                cell.modifierOption = modifierOption
                cell.titleLabel.text = modifierOption?.name
                cell.delegate = self
                if (modifierOption?.selected != nil && modifierOption?.selected == true){
                    cell.selectedButton.selected = true
                } else {
                    cell.selectedButton.selected = false
                }
                
            }
        } else  {
            return UITableViewCell.init()
        }
        
        return cell
    }
}
