//
//  ReportView.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 07.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit

class ReportView: CustomAlertView {
    
    @IBOutlet var mainView: CustomView!
    
    @IBOutlet weak var termInfoLabel: UILabel!
    
    @IBOutlet weak var entitiesCountInfoLabel: UILabel!
    
    @IBOutlet weak var scaleInfoLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    
    private func setup() {
        Bundle.main.loadNibNamed("ReportView", owner: self, options: nil)
        self.mainView.frame = self.bounds
        self.mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.mainView)
        self.mainView.borderColor = GlobalConstants.Color.primaryDark!.cgColor
        
        if let termKey = CurrentValues.currentSettings.term {
            if let termVal = GlobalConstants.TERM_OPTIONS[termKey] {
                self.termInfoLabel.text = self.termInfoLabel.text! + termVal
            }
        }
        
        self.entitiesCountInfoLabel.text = self.entitiesCountInfoLabel.text! + "\(CurrentValues.loadedEntitiesCount)/\(CurrentValues.currentSettings.entityCount!)"
        
        self.scaleInfoLabel.text = self.scaleInfoLabel.text! + "\(CurrentValues.mapScaling)"
        
        
    }
    
    override func displayView(onView: UIView) {
        self.overlay = onView
        self.alpha = 0.0
        self.overlay.alpha = 0.0
        onView.addSubview(self)
        
        self.snp.updateConstraints { (make) -> Void in
            make.center.equalTo(self.overlay)
            make.height.equalTo(self.bounds.height)
            make.width.equalTo(self.bounds.width)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.overlay.alpha = 1.0
            self.alpha = 1.0
        }
    }

}
