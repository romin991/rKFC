//
//  ProductDetailTableViewCell.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/12/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

protocol ModifierDelegate{
    func plusQuantity(modifierOption:ModifierOption)
    func minusQuantity(modifierOption:ModifierOption)
    func selectModifier(modifierOption:ModifierOption)
    func refresh()
}

class ModifierTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, ModifierDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var titleLabel:UILabel = UILabel.init()
    var totalQuantity:Int = 0
    var modifier:Modifier?
    var isFirstTime:Bool = true
    var currentQuantity:Int = 0
    var languageId = NSUserDefaults.standardUserDefaults().objectForKey("LanguageId") as! String

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshCurrentQuantity(){
        self.currentQuantity = 0
        for modifierOption in (self.modifier?.modifierOptions)!{
            self.currentQuantity += modifierOption.quantity
        }
    }

    func quantityDidChange(quantity: Int) {// tell us if quantity on parent view changed
        self.totalQuantity = quantity
    }
    
    func resetToDefault(){
        for modifierOption in (modifier?.modifierOptions)!{
            if (modifierOption.defaultSelect == true){
                modifierOption.selected = true
                let minimum : Int = self.totalQuantity * (self.modifier?.minimumSelect)!
                modifierOption.quantity = minimum
            } else {
                modifierOption.selected = false
                modifierOption.quantity = 0
            }
        }
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
        let minimum : Int = self.totalQuantity * (self.modifier?.minimumSelect)!
        let maximum : Int = self.totalQuantity * (self.modifier?.maximumSelect)!
        if (self.currentQuantity + 1 <= maximum){
            modifierOption.quantity += 1
            self.currentQuantity += 1
            
            if (self.currentQuantity >= minimum && self.currentQuantity <= maximum){
                self.modifier?.status = Status.Valid
            } else {
                self.modifier?.status = Status.Invalid
            }
            
            if (modifierOption.quantity > 0){
                modifierOption.selected = true
            } else {
                modifierOption.selected = false
            }
            self.tableView.reloadData()
        }
    }
    
    func minusQuantity(modifierOption: ModifierOption) {
        let minimum : Int = self.totalQuantity * (self.modifier?.minimumSelect)!
        let maximum : Int = self.totalQuantity * (self.modifier?.maximumSelect)!
        if (modifierOption.quantity > 0){
            modifierOption.quantity -= 1
            self.currentQuantity -= 1
            
            if (self.currentQuantity >= minimum && self.currentQuantity <= maximum){
                self.modifier?.status = Status.Valid
            } else {
                self.modifier?.status = Status.Invalid
            }
            
            if (modifierOption.quantity > 0){
                modifierOption.selected = true
            } else {
                modifierOption.selected = false
            }
            self.tableView.reloadData()
        }
    }
    
    func selectModifier(modifierOption: ModifierOption) {
        for tempModifierOption in (self.modifier?.modifierOptions)!{
            if (modifierOption == tempModifierOption){
                tempModifierOption.selected = true
                tempModifierOption.quantity = self.totalQuantity
            } else {
                tempModifierOption.selected = false
                tempModifierOption.quantity = 0
            }
        }
        self.tableView.reloadData()
    }
    
    func validateModifier(){
        var tempTotalQuantity : Int = 0
        let minimum : Int = totalQuantity * (self.modifier?.minimumSelect)!
        let maximum : Int = totalQuantity * (self.modifier?.maximumSelect)!
        
        for tempModifierOption in (self.modifier?.modifierOptions)!{
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
        let cell : ModifierDetailTableViewCell
        
        if (indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! ModifierDetailTableViewCell
            cell.titleLabel.text = modifier?.names.filter{$0.languageId == self.languageId}.first?.name
            
        } else if (indexPath.section == 1){
            let modifierOption = self.modifier?.modifierOptions[indexPath.row]
            
            if (modifier?.multipleSelect == true){
                cell = tableView.dequeueReusableCellWithIdentifier( "MultipleCell", forIndexPath: indexPath) as! ModifierDetailTableViewCell
                cell.modifierOption = modifierOption
                cell.titleLabel.text = modifierOption?.names.filter{$0.languageId == self.languageId}.first?.name
                cell.delegate = self
                cell.quantityLabel.text = "\((modifierOption?.quantity)!)"
                
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier( "SingleCell", forIndexPath: indexPath) as! ModifierDetailTableViewCell
                cell.modifierOption = modifierOption
                cell.titleLabel.text = modifierOption?.names.filter{$0.languageId == self.languageId}.first?.name
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
