//
//  Item.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 11/6/24.
//

import Foundation
import FirebaseFirestore

struct Item: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let price: Double
    let diningHall: String
    var number: Int
}
