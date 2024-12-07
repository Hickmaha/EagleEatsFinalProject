//
//  ConfirmOrderView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/2/24.
//

import SwiftUI
import FirebaseFirestore
struct ConfirmOrderView: View {
    @State var order: Order
    @State private var sheetIsPresented = false
    @State private var fee = 3.00
    

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(countUniqueItems(items: order.items).keys.sorted()), id: \.self) { itemName in
                    if let item = order.items.first(where: { $0.name == itemName }) {
                        let count = countUniqueItems(items: order.items)[itemName] ?? 0
                        let totalPrice = Double(count) * item.price
                        HStack {
                            Text("\(count) x")
                                .padding(.trailing)
                            Text(itemName)
                            Spacer()
                            Text("$\(totalPrice, specifier: "%.2f")")
                        }
                    }
                }
                .bold()
            }
            .frame(height: 450)
            .listStyle(.plain)
            .navigationTitle("Confirm Order")
            
            Rectangle()
                .foregroundStyle(.gray)
                .frame(height: 1)
                .padding(.horizontal)
            Group{
                HStack {
                    Spacer()
                    Text("Food:")
                    Text("$\(order.total, specifier: "%.2f")")
                        .padding(.trailing)
                }
                HStack {
                    Spacer()
                    Text("Fee:")
                    Text("$\(fee, specifier: "%.2f")")
                        .padding(.trailing)
                }
                HStack {
                    Spacer()
                    Text("Total:")
                    Text("$\(order.total+fee, specifier: "%.2f")")
                        .padding(.trailing)
                }
            }
            .bold()
            
            Spacer()
            
            Button("Confirm Order") {
                Task {
                    order.total += fee
                    order.ordered = true
                    if let docId = await OrderViewModel.saveOrder(order: order) {
                        print(docId)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.goldBackground)
            .tint(.maroonBackground)
            .onChange(of: order.ordered) {
                sheetIsPresented.toggle()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $sheetIsPresented) {
            NavigationStack {
                LockedOrderView(oldOrder: order)
            }
        }

    }

    
    private func countUniqueItems(items: [Item]) -> [String: Int] {
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
}

#Preview {
    ConfirmOrderView(order: Order())
}
