//
//  DelivererConfirmView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/6/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DelivererConfirmView: View {
    @State var order: Order
    @State private var delivererSheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    @FirestoreQuery(collectionPath: "orders") var orders: [Order]
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                    Text("Deliver From:")
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                Text("\(order.diningHall.name)")
                        .font(.title2)
                        .padding(.top, 7)
                    
                    Text("Deliver To:")
                        .font(.title)
                        .bold()
                        .padding(.top, 7)
                    
                Text("\(order.dorm.name)")
                        .font(.title2)
                        .padding(.top, 7)
                    
                    Text("Order Items: ")
                        .font(.title)
                        .bold()
                        .padding(.top, 7)
                
                List {
                    ForEach(order.items, id: \.number) {item  in
                        HStack {
                            Text(item.name)
                            Spacer()
                        }
                    }
                }
                .listStyle(.plain)
                .padding(.top, 7)
            }
            .padding(.horizontal)
            .navigationTitle("Order Details")
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        Task{
                            order.displayed = false
                            let _ = await OrderViewModel.saveOrder(order: order)
                            dismiss()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left") // Back arrow icon
                            Text("Back")
                        }
                    }
                }
            }
                
                Spacer()
                
                Button("Confirm Order") {
                    Task{
                        order.delivering = true
                        let _ = await OrderViewModel.saveOrder(order: order)
                        delivererSheetIsPresented = true
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.maroonBackground)
                .foregroundStyle(.goldBackground)
                
            
        }
        .onAppear{
            Task{
                order.displayed = true
                order.delivererID = Auth.auth().currentUser?.uid ?? ""
                print(order)
                let _ = await OrderViewModel.saveOrder(order: order)
            }
        }
        .fullScreenCover(isPresented: $delivererSheetIsPresented) {
            LockedOrderView(oldOrder: order)
        }
        
    }
}

#Preview {
    DelivererConfirmView(order: Order(items: [Item(id: "EDpPsPfFTp88zxg4NCKd", name: "Fries", price: 3.99, diningHall: "The Rat", number: 1), Item(id: "nYaLZiHVkIVCHyj0WBZF", name: "Chicken Tenders", price: 3.99, diningHall: "The Rat", number: 2)]) )
}
