//
//  DelivererView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 10/27/24.
//

import SwiftUI
import FirebaseFirestore

struct DelivererView: View {
    @FirestoreQuery(collectionPath: "dininghalls") var diningHalls: [DiningHall]
    @FirestoreQuery(collectionPath: "users") var users: [User]
    
    
    var body: some View {
            NavigationStack {
                List {
                    ForEach(diningHalls) { diningHall in
                        NavigationLink {
                            DelivererOrdersView(diningHall: diningHall, users: users)
                        } label: {
                            HStack {
                                
                            Spacer()
                                
                                VStack {
                                    if diningHall.name == "The Rat" {
                                        Text(diningHall.name)
                                            .font(.largeTitle)
                                            .bold()
                                        
                                        
                                        Text("Hours: \(diningHall.hourEnd-11)pm - \(diningHall.hourStart+12)am\nDays: \(dayOfWeekForward(number: diningHall.dayEnd)) - \(dayOfWeekBackward(number: diningHall.dayStart))")
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
//                        .disabled(isDisabled(diningHall: diningHall))
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Deliver From")
        }
    }
    func isDisabled(diningHall: DiningHall) -> Bool {
        let calendar = Calendar.current
        let timeZone = TimeZone(identifier: "America/New_York")!
        let components = calendar.dateComponents(in: timeZone, from: Date())
        
        guard let hour = components.hour, let weekday = components.weekday else {
            return false // Default to enabled if we can't determine time
        }
        
        // Only apply time restrictions to "Rat"
        if diningHall.name == "The Rat" {
            // Disable "Rat" on Friday-Saturday (6-7) or from 12 AM to 6:59 PM
            if (diningHall.dayStart...diningHall.dayEnd).contains(weekday) || (diningHall.hourStart...diningHall.hourEnd).contains(hour) {
                return true
            }
        }
        
        if diningHall.name == "Mac" {
                return true
        }
        
        // All other buttons (including "Mac") should always be enabled
        return false
    }
    
    func dayOfWeekForward(number: Int) -> String {
        let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        // Ensure the input is in the range 1-7
        
        let index = (number) % 7
        
        return days[index]
    }
    
    func dayOfWeekBackward(number: Int) -> String {
        let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        // Ensure the input is in the range 1-7
        
        let index = (7+(number-2)) % 7
        
        return days[index]
    }
}

#Preview {
    DelivererView()
}
