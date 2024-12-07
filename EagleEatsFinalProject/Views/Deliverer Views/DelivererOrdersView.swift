//
//  DelivererOrders.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/2/24.
//

import SwiftUI
import FirebaseFirestore

struct DelivererOrdersView: View {
    @State var diningHall: DiningHall
    @FirestoreQuery(collectionPath: "orders") var orders: [Order]
    @State var users: [User]
    @State private var fee = 3.00
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(orders) { order in
                    if diningHall.name == order.diningHall.name && order.ordered && !order.displayed {
                        NavigationLink {
                            DelivererConfirmView(order: order)
                        } label: {
                            VStack {
                                HStack {
                                    let orderUserId = order.userID
                                    if let user = users.first(where: { $0.userId ==  orderUserId}) {
                                        Text("\(user.fullName)'s Order")
                                            .font(.title3)
                                            .bold()
                                    }
                                    
                                    Spacer()
                                }
                                    
                                
                                HStack {
                                    
                                    VStack(alignment: .leading) {
                                        Text("Delivery To: \(order.dorm.name)")
                                        
                                        
                                        Text("From: \(order.diningHall.name)")
                                    }
                                    .font(.title3)
                                    
                                    
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Items: \(order.items.count)")
                                            .font(.title3)
                                            
                                        Text("Fee: $\(fee, specifier: "%.2f")")
                                            .font(.title3)
                                            
                                    }
                                }
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("\(diningHall.name) Orders")
            .onAppear{
                print(users)
            }
        }
    }
}

#Preview {
    DelivererOrdersView(diningHall: DiningHall(name: "The Rat", hourStart: 0, hourEnd: 18, dayStart: 6, dayEnd: 7), users: [User(fullName: "Ted Roberts", bcIdNumber: 36141234, userId: "LTyE6XRfcZdpKlORzpMACJBxnnm2")])
}
