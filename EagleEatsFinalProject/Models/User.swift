//
//  User.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/4/24.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var fullName: String
    var bcIdNumber: Int
    var userId: String
    
    init(id: String? = nil, fullName: String = "", bcIdNumber: Int = 000000, userId: String = "") {
        self.id = id
        self.fullName = fullName
        self.bcIdNumber = bcIdNumber
        self.userId = userId
    }
}
