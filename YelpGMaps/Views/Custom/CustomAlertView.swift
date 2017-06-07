//
//  CustomAlertView.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 07.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit
import SnapKit

class CustomAlertView: UIView {
    
    var overlay: UIView!
    
    func displayView(onView: UIView) {
        self.overlay = onView
        self.alpha = 0.0
        self.overlay.alpha = 0.0
        onView.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.overlay.alpha = 1.0
            self.alpha = 1.0
        }
    }
    
    internal func hideView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlay.alpha = 0.0
            self.alpha = 0.0
        }) { (finished: Bool) in
            self.overlay.removeFromSuperview()
        }
    }
}
