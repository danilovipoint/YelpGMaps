//
//  AboutViewController.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 02.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit

class AboutViewController: ParentViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = "This applications is developed for demonstration purposes. Application is developed in iPoint LLC. Our site is www.ipoint-consulting.com. Displayed data is getting from https://www.yelp.com and Yelp Fusion API is used for requesting data. Google Maps are used for displaying data on the map. iPoint Logo image is property of iPoint LLC. All other icons and images are free licensed and getting from https://www.iconfinder.com and https://design.google.com/icons/ With offers and questions please write to us on emails danilov@ipoint.ru and dev@ipoint.ru. Thanks for your attention."
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        self.descriptionTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
