//
//  UIView+Extensions.swift
//  TwitMore
//
//  Created by Scott McCoy on 4/17/20.
//  Copyright © 2020 Vrtcal Markets, Inc. All rights reserved.
//

import UIKit

extension UIView {
    func addFillSuperViewContraints() {
        guard let superview = self.superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item:self, attribute:.left, relatedBy:.equal, toItem:superview, attribute:.left, multiplier: 1.0, constant:0.0)
        let right = NSLayoutConstraint(item:self, attribute:.right, relatedBy:.equal, toItem:superview, attribute:.right, multiplier: 1.0, constant:0.0)
        let top = NSLayoutConstraint(item:self, attribute:.top, relatedBy:.equal, toItem:superview, attribute:.top, multiplier: 1.0, constant:0.0)
        let bottom = NSLayoutConstraint(item:self, attribute:.bottom, relatedBy:.equal, toItem:superview, attribute:.bottom, multiplier: 1.0, constant:0.0)
        let constraints = [left,right,top,bottom]
        NSLayoutConstraint.activate(constraints);
        superview.addConstraints(constraints)
    }
    
    func addOffScreenConstraints() {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 1000).isActive = true
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 1000).isActive = true
        
    }
}
