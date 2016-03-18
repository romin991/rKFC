//
//  CustomView.swift
//  KFC
//
//  Created by Rudy Suharyadi on 3/8/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import UIKit

class CustomView: NSObject {

    class func custom(view:UIView, borderColor:UIColor, cornerRadius:CGFloat, roundingCorners:UIRectCorner, borderWidth:CGFloat) -> UIView{
        if (roundingCorners == UIRectCorner.AllCorners){
            view.layer.masksToBounds = true
            view.layer.cornerRadius = cornerRadius
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = borderColor.CGColor
            if let oldLayer = view.layer.valueForKey("CustomLayer"){
                oldLayer.removeFromSuperlayer()
            }
        } else {
            let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let borderPath = UIBezierPath(roundedRect: CGRect(x: view.bounds.origin.x + (borderWidth / 2), y: view.bounds.origin.y + (borderWidth / 2), width: view.bounds.size.width - borderWidth, height: view.bounds.size.height - borderWidth), byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            
            let maskLayer = CAShapeLayer.init()
            maskLayer.frame = view.bounds
            maskLayer.path = maskPath.CGPath
            
            let borderLayer = CAShapeLayer.init()
            borderLayer.frame = view.bounds
            borderLayer.path = borderPath.CGPath
            borderLayer.strokeColor = borderColor.CGColor
            borderLayer.lineWidth = borderWidth
            borderLayer.fillColor = UIColor.clearColor().CGColor
            
            if let oldLayer = view.layer.valueForKey("CustomLayer"){
                oldLayer.removeFromSuperlayer()
            }
            
            view.layer.cornerRadius = 0
            view.layer.borderWidth = 0
            view.layer.addSublayer(borderLayer)
            view.layer.setValue(borderLayer, forKey: "CustomLayer")
            view.layer.mask = maskLayer
            view.layer.masksToBounds = true
        }
        return view
    }
    
}
