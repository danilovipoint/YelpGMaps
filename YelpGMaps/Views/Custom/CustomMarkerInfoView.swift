//
//  CustomMarkerInfoWindow.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 02.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class CustomMarkerInfoView: UIView {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ratingStarsView: CosmosView!
    
    var business: Business! {
        didSet {
            if let rating = self.business.rating {
                self.ratingStarsView.rating = rating
                self.ratingLabel.text = String(format: "%.2g", rating)
            } else {
                self.ratingStarsView.removeFromSuperview()
                self.ratingLabel.text = "No Rating Provided"
            }
            
            if let name = self.business.name {
                self.nameLabel.text = name
            } else {
                self.nameLabel.text = "No Name Provided"
            }
            
            self.addressLabel.text = self.business.getAddressString()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("CustomMarkerInfoView", owner: self, options: nil)
        self.mainView.frame = self.bounds
        self.mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.mainView)
        
        self.layer.cornerRadius = 6.0
        self.layer.borderColor = GlobalConstants.Color.primaryDark?.cgColor
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
}
