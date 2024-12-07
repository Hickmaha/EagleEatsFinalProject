//
//  OrderViewModel.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/2/24.
//

import Foundation
import FirebaseFirestore

@Observable
class OrderViewModel {
    var usedOrder: Order?
    var errorMessage: String?
    var order: Order = Order()
    var showAlert = false
    
    static func saveOrder(order: Order) async -> String? {
        let db = Firestore.firestore()
        
        if let id = order.id { //we have the spot
            do {
                try db.collection("orders").document(id).setData(from: order)
                print("Data updated successfully")
                return id
            }
            catch {
                print("Could not update data in 'orders' \(error.localizedDescription)")
                return id
            }
        } else { //need to add a new spot
            do {
                let docRef = try db.collection("orders").addDocument(from: order)
                print("Data added successfully")
                return docRef.documentID
            } catch {
                print("Could not create a new spot in 'orders' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static func deleteOrder(order: Order) {
        let db = Firestore.firestore()
        guard let id = order.id else {
            print("No orders.id")
            return
        }
        
        Task {
            do {
                try await db.collection("orders").document(id).delete()
            } catch {
                print("Could not delete order \(id). \(error.localizedDescription)")
                return
            }
        }
    }
    
    func addItem(item: Item) {
        if order.items.count < 5 {
            var newItem = item
            newItem.number = order.items.count + 1
            order.items.append(newItem)
            
            var total = 0.0
            for thing in order.items {
                total += thing.price
            }
            order.total = total
            print(order.items, order.userID, order.total)
            print("\n")
        } else {
            showAlert.toggle()
        }
    }
    
    func deleteItem(item: Item) {
        if let index = order.items.firstIndex(where: { $0.name == item.name }) {
            order.items.remove(at: index)
            
            // Reassign unique numbers to maintain sequential order
            for (index, var item) in order.items.enumerated() {
                item.number = index + 1
                order.items[index] = item
            }
        }
        
        var total = 0.0
        for thing in order.items {
            total += thing.price
        }
        order.total = total
        print(order.items, order.userID, order.total)
        print("\n")
    }
    
    func countUniqueItems(items: [Item]) -> [String: Int] {
        var itemCounts: [String: Int] = [:]
        
        for item in items {
            if let count = itemCounts[item.name] {
                itemCounts[item.name] = count + 1
            } else {
                itemCounts[item.name] = 1
            }
        }
        
        return itemCounts
    }
    
    func fetchOrder(withId id: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("orders").document(id)
        
        // Listen for real-time updates
        docRef.addSnapshotListener { document, error in
            if let error = error {
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
                return
            }
            
            guard let document = document, document.exists else {
                self.errorMessage = "Document does not exist"
                return
            }
            
            do {
                self.order = try document.data(as: Order.self) // Store fetched data in usedOrder
            } catch {
                self.errorMessage = "Error decoding document: \(error.localizedDescription)"
            }
        }
    }
}

