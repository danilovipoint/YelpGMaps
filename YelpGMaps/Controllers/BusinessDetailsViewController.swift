//
//  BusinessDetailsViewController.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 01.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SnapKit
import Cosmos

class BusinessDetailsViewController: ParentViewController {
    
    var business: Business!
    
    let downloader = ImageDownloader()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in self .containerStackView.subviews {
            view.removeFromSuperview()
        }
        
        if let name = self.business.name {
            let nameLabel = UILabel()
            nameLabel.textAlignment = .center
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            nameLabel.text = name
            nameLabel.numberOfLines = 0
            self.containerStackView.addArrangedSubview(nameLabel)
            
        }
        
        if let termkey = CurrentValues.currentSettings.term {
            if let termVal = GlobalConstants.TERM_OPTIONS[termkey] {
                let termLabel = UILabel()
                termLabel.textAlignment = .center
                termLabel.font = UIFont.italicSystemFont(ofSize: 17)
                termLabel.text = "(\(termVal))"
                termLabel.numberOfLines = 0
                self.containerStackView.addArrangedSubview(termLabel)
            }
        }
        
        if let imageUrlStr = self.business.imageUrlStr {
            if let imageUrl = URL(string: imageUrlStr) {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                activityIndicator.isHidden = false
                activityIndicator.color = UIColor.black
                activityIndicator.startAnimating()
                
                imageView.addSubview(activityIndicator)
                
                self.containerStackView.insertArrangedSubview(imageView, at: 2)
                
                imageView.snp.makeConstraints({ make in
                    make.width.equalTo(self.containerStackView)
                    make.height.equalTo(self.view).multipliedBy(0.4)
                })
                
                activityIndicator.snp.makeConstraints({ make in
                    make.centerX.equalTo(imageView)
                    make.centerY.equalTo(imageView)
                })
                
                let urlRequest = URLRequest(url: imageUrl)

                downloader.download(urlRequest) { response in
                    activityIndicator.stopAnimating()
                    activityIndicator.isHidden = true
                    if let image = response.result.value {
                        let imageFilter = RoundedCornersFilter(radius: 6.0)
                        imageView.image = imageFilter.filter(image)
                    } else {
                        imageView.removeFromSuperview()
                    }
                }
            
            }
        }
        
        if let rating = self.business.rating {
            let ratingStackView = UIStackView()
            ratingStackView.axis = .horizontal
            ratingStackView.spacing = 5
            
            let ratingStarsView = CosmosView()
            ratingStackView.isUserInteractionEnabled = false
            ratingStarsView.settings.fillMode = StarFillMode(rawValue: 2)!
            ratingStarsView.settings.emptyBorderColor = .lightGray
            ratingStarsView.settings.emptyColor = .lightGray
            ratingStarsView.rating = rating
            ratingStackView.addArrangedSubview(ratingStarsView)
            
            let ratingLabel = UILabel()
            ratingLabel.textAlignment = .left
            ratingLabel.text = String(format: "%.2g", rating)
            ratingStackView.addArrangedSubview(ratingLabel)
            
            let ratingContainerView = UIView()
            ratingContainerView.addSubview(ratingStackView)
            
            self.containerStackView.addArrangedSubview(ratingContainerView)
            
            ratingStackView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(5)
                make.bottom.equalTo(-5)
            }
        }
        
        if let phone = self.business.phone {
            let attributedString = NSMutableAttributedString(string: phone)
            let textRange = NSMakeRange(0, (phone.characters.count))
            
            let boldItalicsFont = UIFont(name: "Avenir-HeavyOblique", size: 18.0)!
            
            attributedString.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            
            attributedString.addAttribute(
                NSLinkAttributeName, value: phone,
                range: textRange)
            
            attributedString.addAttribute(
                NSForegroundColorAttributeName, value: UIColor.blue,
                range: textRange)
            
            attributedString.addAttribute(NSFontAttributeName, value: boldItalicsFont, range: textRange)
            
            let phoneStackView = UIStackView()
            phoneStackView.axis = .horizontal
            phoneStackView.spacing = 5
            
            let phoneTitleLabel = UILabel()
            phoneTitleLabel.text = "Phone: "
            phoneTitleLabel.textAlignment = .right
            
            phoneStackView.addArrangedSubview(phoneTitleLabel)
            
            let phoneLabel = UILabel()
            phoneLabel.textAlignment = .left
            phoneLabel.isUserInteractionEnabled = true
            phoneLabel.attributedText = attributedString
            
            phoneStackView.addArrangedSubview(phoneLabel)
            
            let phoneContainerView = UIView()
            
            phoneContainerView.addSubview(phoneStackView)
            
            phoneStackView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(5)
                make.bottom.equalTo(-5)
            }
            
            self.containerStackView.addArrangedSubview(phoneContainerView)
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BusinessDetailsViewController.phoneClicked))
            phoneLabel.addGestureRecognizer(gestureRecognizer)
        }
        
        if let categories = self.business.categories {
            if categories.count > 0 {
                let categoriesTitleLabel = UILabel()
                categoriesTitleLabel.text = "Categories"
                categoriesTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
                categoriesTitleLabel.textAlignment = .center
                self.containerStackView.addArrangedSubview(categoriesTitleLabel)
                
                let categoriesValueLabel = UILabel()
                categoriesValueLabel.numberOfLines = 0
                categoriesValueLabel.textAlignment = .center
                categoriesValueLabel.text = self.business.getCategoriesString()
                self.containerStackView.addArrangedSubview(categoriesValueLabel)
            }
            
        }
        
        let reviewsTitleLabel = UILabel()
        reviewsTitleLabel.text = "Reviews"
        reviewsTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        reviewsTitleLabel.textAlignment = .center
        self.containerStackView.addArrangedSubview(reviewsTitleLabel)

        self.loadReviewsForBusiness()
    }
    
    func phoneClicked() {
        if let phone = self.business.phone {
            guard let number = URL(string: "telprompt://" + phone) else { return }
            
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        }
    }
    
    func loadReviewsForBusiness() {
        if let id = self.business.id {
            DataService.sharedInstance.loadReviewsForBusiness(id: id, successHandler: { reviewsArray in
                if reviewsArray.count == 0 {
                    self.handleNoReviews()
                }
                
                for item in reviewsArray {
                    let review = Review(json: item)
                    let userReview = UserReview()
                    userReview.review = review
                    self.containerStackView.addArrangedSubview(userReview)
                }
            }) { errorMessage in
                self.showAlert(title: "Error", message: errorMessage)
                self.handleNoReviews()
            }
        } else {
            self.handleNoReviews()
        }
    }
    
    func handleNoReviews() {
        let noReviewsLabel = UILabel()
        noReviewsLabel.text = "There are no reviews!"
        noReviewsLabel.textAlignment = .center
        self.containerStackView.addArrangedSubview(noReviewsLabel)
    }

}
