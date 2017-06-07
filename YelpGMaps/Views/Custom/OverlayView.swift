//
//  OverlayView.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 07.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit

class OverlayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.alpha = 0.0
        self.backgroundColor = UIColor.clear
    }
    
}
