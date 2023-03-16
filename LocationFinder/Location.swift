//
//  Location.swift
//  LocationFinder
//
//  Created by Tiziano Cialfi on 16/03/23.
//

import Foundation

struct Location: Codable {
    
    struct Place: Codable {
        var placeName: String
        var longitude: String
        var state: String
        var latitude: String
        
        private enum CodingKeys: String, CodingKey {
            case placeName = "place name"
            case longitude
            case state
            case latitude
        }
    }
    
    var country: String
    var places: [Place]
}
