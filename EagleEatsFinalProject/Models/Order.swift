//
//  Order.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 11/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    var userID: String
    var delivererID: String
    var diningHall: DiningHall
    var dorm: Dorm
    var items: [Item]
    var total: Double
    var ordered: Bool
    var displayed: Bool
    var delivering: Bool
    let passkey: Int
    var delivererLatitude: Double
    var delivererLongitude: Double
    
    
    init(id: String? = nil, userID: String = Auth.auth().currentUser?.uid ?? "n/a", delivererID: String = "", diningHall: DiningHall = DiningHall(), dorm: Dorm = Dorm(), items: [Item] = [], total: Double = 0.0, ordered: Bool = false, displayed: Bool = false,  delivering: Bool = false, passkey: Int = Int.random(in: 100000...999999), delivererLatitude: Double = 0.0, delivererLongitude: Double = 0.0) {
        self.id = id
        self.userID = userID
        self.delivererID = delivererID
        self.diningHall = diningHall
        self.dorm = dorm
        self.items = items
        self.total = total
        self.ordered = ordered
        self.displayed = displayed
        self.delivering = delivering
        self.passkey = passkey
        self.delivererLatitude = delivererLatitude
        self.delivererLongitude = delivererLongitude
        
    }
}
