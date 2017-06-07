//
//  GlobalConstants.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 31.05.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import ChameleonFramework

struct GlobalConstants {
    
    struct Color {
        
        static let primaryDark = UIColor(hexString: "#89bdd3")
        
        static let primaryLight = UIColor(hexString: "#9ad3de")
        
        static let secondaryDark = UIColor(hexString: "#c9c9c9")
        
        static let secondaryLight = UIColor(hexString: "#e3e3e3")
        
    }
    
    struct YelpAPIUrls {
        
        static let GET_ACCESS_TOKEN = "https://api.yelp.com/oauth2/token"
        
        static let GET_BUSINESSES = "https://api.yelp.com/v3/businesses/"
        
        static let SEARCH = YelpAPIUrls.GET_BUSINESSES + "search"
        
        static func getReviews(id: String) -> String {
            return YelpAPIUrls.GET_BUSINESSES + id + "/reviews"
        }
        
        static func getAuthorizationHeader() -> String {
            return "Bearer \(GlobalConstants.YELP_ACCESS_TOKEN)"
        }
    }
    
    static let GOOGLE_MAPS_API_KEY = "AIzaSyCB3wCPhPX3zcyYegNN_JQBPZU8Rwmx7rY"
    
    static let YELP_CLIENT_ID = "A6jJ20wf9AauCAi_qVvuWw"
    
    static let YELP_CLIENT_SECRET = "OvN0vbq4yuH7Lq8yLmj6Jfg4hbTabM0WhKXKaSc5tqj7cgFC3yRzbZQLP6L7F2in"
    
    static var YELP_ACCESS_TOKEN = ""
    
    static let LOADING_RETRYING = 3
    
    static let TERM_OPTIONS = [
        "active": "Active Life",
        "arts": "Arts & Entertainment",
        "auto": "Automotive",
        "beautysvc": "Beauty & Spas",
        "education": "Education",
        "eventservices": "Event Planning & Services",
        "financialservices": "Financial Services",
        "food": "Food",
        "health": "Health & Medical",
        "homeservices": "Home Services",
        "hotelstravel": "Hotels & Travel",
        "localflavor": "Local Flavor",
        "localservices": "Local Services",
        "massmedia": "Mass Media",
        "nightlife": "Nightlife",
        "pets": "Pets",
        "professional": "Professional Services",
        "publicservicesgovt": "Public Services & Government",
        "realestate": "Real Estate",
        "religiousorgs": "Religious Organizations",
        "restaurants": "Restaurants",
        "shopping": "Shopping"
    ]
    
}
