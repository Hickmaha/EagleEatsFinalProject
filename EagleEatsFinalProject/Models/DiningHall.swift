//
//  DiningHall.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 10/29/24.
//

import Foundation
import FirebaseFirestore

struct DiningHall: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var hourStart: Int
    var hourEnd: Int
    var dayStart: Int
    var dayEnd: Int
    var latitude: Double
    var longitude: Double
    
    init(id: String? = nil, name: String = "", hourStart: Int = 0, hourEnd: Int = 18, dayStart: Int = 6, dayEnd: Int = 7, latitude: Double = 0.0, longitude: Double = 0.0) {
        self.id = id
        self.name = name
        self.hourStart = hourStart
        self.hourEnd = hourEnd
        self.dayStart = dayStart
        self.dayEnd = dayEnd
        self.latitude = latitude
        self.longitude = longitude
    }
}
