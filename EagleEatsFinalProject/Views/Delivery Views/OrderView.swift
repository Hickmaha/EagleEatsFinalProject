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
    @State private var selectedDorm: DormEnum = .None
    @Environment(\.dismiss) private var dismiss
    @State private var fee = 3.00
    @State var OrderVM: OrderViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    
                    Text(OrderVM.order.dorm.name == "None" ? "Choose Your Dorm: " : "Dorm:")
                    
                    Spacer()
                    
                    Picker("Doesn’t Show on IOS", selection: $selectedDorm) {ForEach(DormEnum.allCases, id: \.self) {dorm in Text(dorm.rawValue.capitalized)}}
                        .tint(.goldBackground)
                        .onChange(of: selectedDorm) {
                            if let assignedDorm = dorms.first(where: { dorm in
                                dorm.name.contains("\(selectedDorm.rawValue.capitalized)")
                            }) {
                                OrderVM.order.dorm = assignedDorm
                            }
                            print(OrderVM.order)
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
                                    OrderVM.deleteItem(item: item)
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundStyle(.goldBackground)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Button{
                                    OrderVM.addItem(item: item)
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
                    ConfirmOrderView(OrderVM: OrderVM)
                } label: {
                    if OrderVM.order.items.count > 0 && OrderVM.order.dorm.name != "None" {
                        Text("Order \(OrderVM.order.items.count) items")
                    } else if OrderVM.order.dorm.name == "None"{
                        Text("Choose your Dorm")
                    } else {
                        Text("Add items")
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.maroonBackground)
                .foregroundStyle(.goldBackground)
                .disabled(OrderVM.order.items.count == 0 || OrderVM.order.dorm.name == "None")
                
                
            }
            .navigationTitle(OrderVM.order.diningHall.name)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        
                        ConfirmOrderView(OrderVM: OrderVM)
                    } label: {
                        HStack {
                            Image(systemName: "takeoutbag.and.cup.and.straw")
                                .foregroundStyle(.goldBackground)
                            
                            if OrderVM.order.items.count > 0 {
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.maroonBackground)
                                    
                                        .frame(width: 15, height: 15)
                                        .offset(x: -10, y: -10)
                                    
                                    Text("\(OrderVM.order.items.count)")
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
                    .disabled(OrderVM.order.items.count == 0 || OrderVM.order.dorm.name == "None")
                }
            }
            .padding()
        }
        .onAppear{
            if OrderVM.order.items.isEmpty {
                OrderVM.order = Order()
            }
            OrderVM.order.userID = Auth.auth().currentUser?.uid ?? "n/a"
            OrderVM.order.diningHall = diningHall
        }
        .alert("No More Than 5 Items In An Order", isPresented: $OrderVM.showAlert) {
            Button("Dismiss", role: .cancel) {}
        }
        .onDisappear{
            OrderVM.order.userID = Auth.auth().currentUser?.uid ?? "n/a"
            print(OrderVM.order)
        }
    }
}

#Preview {
    NavigationStack{
        OrderView(diningHall: DiningHall(name: "The Rat"), OrderVM: OrderViewModel())
    }
}
