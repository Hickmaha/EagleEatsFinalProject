//
//  DeliveryView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 10/27/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DeliveryView: View {
    @FirestoreQuery(collectionPath: "dininghalls") var diningHalls: [DiningHall]
    @State private var sheetIsPresented = false
    @State private var DiningHallVM = DiningHallViewModel()
    var body: some View {
        NavigationStack {
            List {
                ForEach(diningHalls) { diningHall in
                    NavigationLink {
                        OrderView(diningHall: diningHall, OrderVM: OrderViewModel())
                    } label: {
                        HStack {
                            
                        Spacer()
                            
                            VStack {
                                if diningHall.name == "The Rat" {
                                    Text(diningHall.name)
                                        .font(.largeTitle)
                                        .bold()
                                    
                                    
                                    Text("Hours: \(diningHall.hourEnd-11)pm - \(diningHall.hourStart+12)am\nDays: \(DiningHallVM.dayOfWeekForward(number: diningHall.dayEnd)) - \(DiningHallVM.dayOfWeekBackward(number: diningHall.dayStart))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .bold()
                                    
                                    
                                } else {
                                    Text("\(diningHall.name)\nComing Soon")
                                        .multilineTextAlignment(.center)
                                        .font(.largeTitle)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(height: 150)
                        .padding()
                    }
                    .buttonStyle(.plain)
                    .disabled(DiningHallVM.isDisabled(diningHall: diningHall))
                }
            }
            .listStyle(.plain)
            .navigationTitle("Dining Halls")
            .onAppear{
                print(diningHalls)
            }
        }
    }
}

#Preview {
    NavigationStack{
        DeliveryView()
    }
}
