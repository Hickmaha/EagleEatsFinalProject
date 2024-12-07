//
//  ConfirmOrderView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/2/24.
//

import SwiftUI
import FirebaseFirestore
struct ConfirmOrderView: View {
    @State private var sheetIsPresented = false
    @State private var fee = 3.00
    @State var OrderVM: OrderViewModel
    

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(OrderVM.countUniqueItems(items: OrderVM.order.items).keys.sorted()), id: \.self) { itemName in
                    if let item = OrderVM.order.items.first(where: { $0.name == itemName }) {
                        let count = OrderVM.countUniqueItems(items: OrderVM.order.items)[itemName] ?? 0
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
                    Text("$\(OrderVM.order.total, specifier: "%.2f")")
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
                    Text("$\(OrderVM.order.total+fee, specifier: "%.2f")")
                        .padding(.trailing)
                }
            }
            .bold()
            
            Spacer()
            
            Button("Confirm Order") {
                Task {
                    print(OrderVM.order)
                    OrderVM.order.total += fee
                    OrderVM.order.ordered = true
                    if let docId = await OrderViewModel.saveOrder(order: OrderVM.order) {
                        print(docId)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.goldBackground)
            .tint(.maroonBackground)
            .onChange(of: OrderVM.order.ordered) {
                sheetIsPresented.toggle()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $sheetIsPresented) {
            NavigationStack {
                LockedOrderView(oldOrder: OrderVM.order)
            }
        }
        

    }

    
    
}

#Preview {
    ConfirmOrderView(OrderVM: OrderViewModel())
}
