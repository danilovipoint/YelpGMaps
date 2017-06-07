//
//  Category.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 05.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    
    var alias: String?
    
    var title: String?
    
    init(json: JSON) {
        if let alias = json["alias"].string {
            if !alias.isEmpty {
                self.alias = alias
            }
        }
        
        if let title = json["title"].string {
            if !title.isEmpty {
                self.title = title
            }
        }
    }
    
}
