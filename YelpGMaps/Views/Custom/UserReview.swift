//
//  UserReview.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 02.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import Alamofire
import AlamofireImage

class UserReview: UIView {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    @IBOutlet weak var linkToReviewLabel: UILabel!
    
    @IBOutlet weak var separatorLineView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var ratingStarsView: CosmosView!
    
    @IBOutlet weak var reviewDateTimeLabel: UILabel!
    
    var review: Review! {
        didSet {
            self.reviewTextLabel.text = self.review.text
            if let rating = self.review.rating {
                self.ratingLabel.text = String(format: "%.2g", rating)
                self.ratingStarsView.rating = rating
            } else {
                self.ratingStarsView.removeFromSuperview()
                self.ratingLabel.text = "No Rating Provided"
            }
            if let timeCreated = self.review.timeCreated {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let dateObj = dateFormatter.date(from: timeCreated) {
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .short
                    self.reviewDateTimeLabel.text = dateFormatter.string(from: dateObj)
                } else {
                    self.reviewDateTimeLabel.text = timeCreated
                }
            } else {
                self.reviewDateTimeLabel.text = "Created Time is Unknown"
            }
            
            
            if let user = self.review.user {
                if let username = user.name {
                    self.usernameLabel.text = username
                } else {
                    self.usernameLabel.text = "No Username Provided"
                }
                
                if let userImageUrlStr = user.imageUrlStr {
                    if let userImageUrl = URL(string: userImageUrlStr) {
                        let imageFilter = RoundedCornersFilter(radius: 16.0)
                        self.userImageView.af_setImage(withURL: userImageUrl, filter: imageFilter)
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        Bundle.main.loadNibNamed("UserReview", owner: self, options: nil)
        self.mainView.frame = self.bounds
        self.mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.mainView)
        self.configureLinkLabel()
        
        self.ratingStarsView.settings.emptyBorderColor = .lightGray
        self.ratingStarsView.settings.emptyColor = .lightGray
        
    }
    
    func configureLinkLabel() {
        let str = "See full review on www.yelp.com"
        let attributedString = NSMutableAttributedString(string: str)
        let textRange = NSMakeRange(0, (str.characters.count))
        
        let boldItalicsFont = UIFont(name: "Avenir-HeavyOblique", size: 18.0)!
        
        attributedString.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        
        attributedString.addAttribute(
            NSLinkAttributeName, value: str,
            range: textRange)
        
        attributedString.addAttribute(
            NSForegroundColorAttributeName, value: UIColor.blue,
            range: textRange)
        
        attributedString.addAttribute(NSFontAttributeName, value: boldItalicsFont, range: textRange)
        
        self.linkToReviewLabel.isUserInteractionEnabled = true
        self.linkToReviewLabel.attributedText = attributedString
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserReview.linkClicked))
        self.linkToReviewLabel.isUserInteractionEnabled = true
        self.linkToReviewLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    func linkClicked() {
        if let urlStr = self.review.urlStr {
            if let url = URL(string: urlStr) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
