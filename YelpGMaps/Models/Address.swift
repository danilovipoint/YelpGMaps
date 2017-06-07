//
//  Address.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 05.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Address {
    
    var city: String?
    
    var country: String?
    
    var state: String?
    
    var address1: String?
    
    var address2: String?
    
    var address3: String?
    
    var zipCode: String?
    
    init(json: JSON) {
        if let city = json["city"].string {
            if !city.isEmpty {
                self.city = city
            }
        }
        
        if let country = json["country"].string {
            if !country.isEmpty {
                self.country = country
            }
        }
        
        if let state = json["state"].string {
            if !state.isEmpty {
                self.state = state
            }
        }
        
        if let address1 = json["address1"].string {
            if !address1.isEmpty {
                self.address1 = address1
            }
        }
        
        if let address2 = json["address2"].string {
            if !address2.isEmpty {
                self.address2 = address2
            }
        }
        
        if let address3 = json["address3"].string {
            if !address3.isEmpty {
                self.address3 = address3
            }
        }
        
        if let zipCode = json["zip_code"].string {
            if !zipCode.isEmpty {
                self.zipCode = zipCode
            }
        }
        
    }
    
    func getAddressString() -> String {
        var result = ""
        if let zipCode = self.zipCode {
            if !zipCode.isEmpty {
                result += zipCode
            }
        }
        
        if let address1 = self.address1 {
            if !address1.isEmpty {
                result += " \(address1)"
            }
        } else if let address2 = address2 {
            if !address2.isEmpty {
                result += " \(address2)"
            }
        } else if let address3 = self.address3 {
            if !address3.isEmpty {
                result += " \(address3)"
            }
        }
        
        if let city = self.city {
            if !city.isEmpty {
                result += " \(city)"
            }
        }
        
        result = result.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        result = result.replacingOccurrences(of: " ", with: ", ")
        
        if result.isEmpty {
            return "No Address Provided"
        } else {
            return result
        }
    }
    
}
