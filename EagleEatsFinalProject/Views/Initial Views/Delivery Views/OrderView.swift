//
//  OrderView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 11/30/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct OrderView: View {
    enum DormEnum: String, CaseIterable {
        case Vanderslice, Walsh, Ninety, None}
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    @FirestoreQuery(collectionPath: "dorms") var dorms: [Dorm]
    @State var diningHall: DiningHall
    @State var order: Order
    @State private var selectedDorm: DormEnum = .None
    @Environment(\.dismiss) private var dismiss
    @State private var fee = 3.00
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    
                    Text(order.dorm.name == "None" ? "Choose Your Dorm: " : "Dorm:")
                    
                    Spacer()
                    
                    Picker("Doesn’t Show on IOS", selection: $selectedDorm) {ForEach(DormEnum.allCases, id: \.self) {dorm in Text(dorm.rawValue.capitalized)}}
                        .tint(.goldBackground)
                        .onChange(of: selectedDorm) {
                            if let assignedDorm = dorms.first(where: { dorm in
                                dorm.name.contains("\(selectedDorm.rawValue.capitalized)")
                            }) {
                                order.dorm = assignedDorm
                            }
                            print(order)
                        }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(items) { item in
                        if diningHall.name == item.diningHall {
                            HStack {
                                Text(item.name)
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.2f", item.price))")
                                    .padding(.trailing)
                                
                                Button{
                                    deleteItem(item: item)
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundStyle(.goldBackground)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Button{
                                    addItem(item: item)
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(.goldBackground)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                
                
                NavigationLink {
                    ConfirmOrderView(order: order)
                } label: {
                    if order.items.count > 0 && order.dorm.name != "None" {
                        Text("Order \(order.items.count) items")
                    } else if order.dorm.name == "None"{
                        Text("Choose your Dorm")
                    } else {
                        Text("Add items")
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.maroonBackground)
                .foregroundStyle(.goldBackground)
                .disabled(order.items.count == 0 || order.dorm.name == "None")
                
                
            }
            .navigationTitle(order.diningHall.name)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        
                        ConfirmOrderView(order: order)
                    } label: {
                        HStack {
                            Image(systemName: "takeoutbag.and.cup.and.straw")
                                .foregroundStyle(.goldBackground)
                            
                            if order.items.count > 0 {
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.maroonBackground)
                                    
                                        .frame(width: 15, height: 15)
                                        .offset(x: -10, y: -10)
                                    
                                    Text("\(order.items.count)")
                                        .font(.caption2)
                                        .bold()
                                        .offset(x: -10, y: -10)
                                        .foregroundStyle(.goldBackground)
                                }
                            } else {
                                Text("")
                                    .font(.caption2)
                                    .offset(x: -10, y: -10)
                                    .foregroundStyle(.goldBackground)
                                    .frame(width: 15, height: 15)
                            }
                        }
                        
                    }
                    .disabled(order.items.count == 0 || order.dorm.name == "None")
                }
            }
            .padding()
        }
        .onAppear{
            if order.items.isEmpty {
                order = Order()
            }
            order.userID = Auth.auth().currentUser?.uid ?? "n/a"
            order.diningHall = diningHall
        }
        .alert("No More Than 5 Items In An Order", isPresented: $showAlert) {
            Button("Dismiss", role: .cancel) {}
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
}

#Preview {
    NavigationStack{
        OrderView(diningHall: DiningHall(name: "The Rat"), order: Order())
    }
}
