//
//  Dorm.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/4/24.
//

import Foundation
import FirebaseFirestore

struct Dorm: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String = "None", latitude: Double = 0.0, longitude: Double = 0.0) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
