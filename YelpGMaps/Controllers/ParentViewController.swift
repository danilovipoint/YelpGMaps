//
//  ParentViewController.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 02.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    var overlay: OverlayView!
    
    var customAlert: CustomAlertView!
    
    var ignoreTouches: Bool?
    
    func showCustomAlert(view: CustomAlertView, isOverlayTransparent: Bool = true, ignoreTouches: Bool = false) {
        
        self.customAlert = view
        
        self.overlay = OverlayView(frame: UIScreen.main.bounds)
        self.overlay.alpha = 0.0
        self.overlay.backgroundColor = isOverlayTransparent == true ? UIColor.clear : UIColor.white.withAlphaComponent(0.5)
        self.overlay.addSubview(view)
        
        self.ignoreTouches = ignoreTouches
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ParentViewController.onOverlayTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.overlay.addGestureRecognizer(tapGesture)
        
        // How to add UIView on the top of all views?
        // http://stackoverflow.com/questions/6622913/how-to-add-uiview-on-the-top-of-all-views
        var window = UIApplication.shared.keyWindow
        if window == nil {
            window = UIApplication.shared.windows[0]
        }
        self.navigationController?.view.addSubview(overlay)
        
        overlay.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(window!).offset(0)
            make.left.equalTo(window!).offset(0)
            make.bottom.equalTo(window!).offset(0)
            make.right.equalTo(window!).offset(0)
        }
        
        view.displayView(onView: overlay)
    }
    
    func onOverlayTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.customAlert.alpha = 0.0
            self.overlay.alpha = 0.0
        }) { (finished: Bool) in
            self.overlay.removeFromSuperview()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let ignoreTouches = self.ignoreTouches {
            if ignoreTouches && (touch.view?.isDescendant(of: self.customAlert))! {
                return false
            }
        }
        
        return true
    }


}
