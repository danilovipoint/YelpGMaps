//
//  User.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 05.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    var imageUrlStr: String?
    
    var name: String?
    
    init(json: JSON) {
        if let imageUrlStr = json["image_url"].string {
            if !imageUrlStr.isEmpty {
                self.imageUrlStr = imageUrlStr
            }
        }
        
        if let name = json["name"].string {
            if !name.isEmpty {
                self.name = name
            }
        }
    }
    
}

