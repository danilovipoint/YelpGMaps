//
//  CustomButton.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 06.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                let newColor = UIColor(cgColor: self.borderColor).withAlphaComponent(1.0)
                self.borderColor = newColor.cgColor
            } else {
                let newColor = UIColor(cgColor: self.borderColor).withAlphaComponent(0.5)
                self.borderColor = newColor.cgColor
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.backgroundColor = GlobalConstants.Color.primaryDark
                self.borderWidth = 0.0
            } else {
                self.backgroundColor = UIColor.clear
                self.borderWidth = 1.0
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                let newColor = UIColor(cgColor: self.borderColor).withAlphaComponent(0.5)
                self.borderColor = newColor.cgColor
            } else {
                let newColor = UIColor(cgColor: self.borderColor).withAlphaComponent(1.0)
                self.borderColor = newColor.cgColor
            }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: CGColor {
        get {
            return self.layer.borderColor!
        }
        set {
            self.layer.borderColor = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureButton()
    }
    
    func configureButton() {
        self.clipsToBounds = true
    }
    
}

