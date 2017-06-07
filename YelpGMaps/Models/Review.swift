//
//  Review.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 02.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Review {
    
    var rating: Double?
    
    var text: String?
    
    var timeCreated: String?
    
    var urlStr: String?
    
    var user: User?
    
    init(json: JSON) {
        if let rating = json["rating"].double {
            self.rating = rating
        }
        
        if let text = json["text"].string {
            if !text.isEmpty {
                self.text = text
            }
        }
        
        if let timeCreated = json["time_created"].string {
            if !timeCreated.isEmpty {
                self.timeCreated = timeCreated
            }
        }
        
        if let urlStr = json["url"].string {
            if !urlStr.isEmpty {
                self.urlStr = urlStr
            }
        }
        
        let userJson = json["user"]
        if userJson.exists() {
            self.user = User(json: userJson)
        }
        
    }
    
}
