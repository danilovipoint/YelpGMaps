//
//  Business.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 02.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

class Business: NSObject {
    
    var rating: Double?
    
    var price: String?
    
    var phone: String?
    
    var id: String?
    
    var categories: Array<Category>?
    
    var name: String?
    
    var urlStr: String?
    
    var imageUrlStr: String?
    
    var address: Address?
    
    var coordinate: CLLocationCoordinate2D?
    
    init(json: JSON) {
        if let rating = json["rating"].double {
            self.rating = rating
        }
        
        if let price = json["price"].string {
            if !price.isEmpty {
                self.price = price
            }
        }
        
        if let phone = json["phone"].string {
            if !phone.isEmpty {
                self.phone = phone
            }
        }
        
        if let id = json["id"].string {
            if !id.isEmpty {
                self.id = id
            }
        }
        
        if let categories = json["categories"].array {
            self.categories = Array<Category>()
            for item in categories {
                let category = Category(json: item)
                self.categories?.append(category)
            }
        }
        
        if let name = json["name"].string {
            if !name.isEmpty {
                self.name = name
            }
        }
        
        if let urlStr = json["url"].string {
            if !urlStr.isEmpty {
                self.urlStr = urlStr
            }
        }
        
        let coordinates = json["coordinates"]
        if coordinates.exists() {
            if let latitude = coordinates["latitude"].double,
                let longitude = coordinates["longitude"].double {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.coordinate = coordinate
            }
        }
        
        let addressJson = json["location"]
        if addressJson.exists() {
            self.address = Address(json: addressJson)
        }
        
        if let imageUrlStr = json["image_url"].string {
            if !imageUrlStr.isEmpty {
                self.imageUrlStr = imageUrlStr
            }
        }
    }
    
    func getCategoriesString() -> String {
        var catStr = ""
        if let categories = self.categories {
            for i in 0...(categories.count - 1) {
                let cat = categories[i]
                if let title = cat.title {
                    catStr += title
                    if i != (categories.count - 1) {
                        catStr += ", "
                    }
                }
            }
        }
        return catStr
    }
    
    func getAddressString() -> String {
        if let address = self.address {
            return address.getAddressString()
        } else {
            return "No Address Provided"
        }
        
    }
    
}
