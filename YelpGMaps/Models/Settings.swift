//
//  Settings.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 07.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import GoogleMaps

class Settings: NSObject, NSCoding {
    
    var term: String!
    
    var scale: Double!
    
    var entityCount: Int!
    
    var updateOnMapChanges: Bool!
    
    override init() {
        self.term = "restaurants"
        self.scale = Double((kGMSMinZoomLevel + kGMSMaxZoomLevel) / 2)
        self.entityCount = 35
        self.updateOnMapChanges = true
    }
    
    init(term: String, scale: Double, entityCount: Int, updateOnMapChanges: Bool) {
        self.term = term
        self.scale = scale
        self.entityCount = entityCount
        self.updateOnMapChanges = updateOnMapChanges
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let term = aDecoder.decodeObject(forKey: "term") as! String
        let scale = aDecoder.decodeObject(forKey: "scale") as! Double
        let entityCount = aDecoder.decodeObject(forKey: "entityCount") as! Int
        let updateOnMapChanges = aDecoder.decodeObject(forKey: "updateOnMapChanges") as! Bool
        self.init(term: term, scale: scale, entityCount: entityCount, updateOnMapChanges: updateOnMapChanges)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(term, forKey: "term")
        aCoder.encode(scale, forKey: "scale")
        aCoder.encode(entityCount, forKey: "entityCount")
        aCoder.encode(updateOnMapChanges, forKey: "updateOnMapChanges")
    }
    
}
