//
//  HomeView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 9/4/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            LogoView()
            
            Spacer()
            
            //TODO: Make a search bar and a centering icon to keep you on the map and find the right dining hall
            
            //TODO: Make this a map instead of an image when you learn
            
            Image(systemName: "trash.square")
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 300, height: 450)
                .padding()
            
            Spacer()
            
            
            //TODO: Make this say the actual user name from backend and if it is a delivery or pickup, default as order
            
            Text("User Delivery or Pickup or Order")
                .padding(7)
                .font(.title3)
                .padding()
            
            //TODO: Make this populate with either pickup at dining hall or delivery from dining hall to dorm depending on the option selected
            
            Spacer()
            
            Text("Delivery: 'Dining hall' >>> 'Dorm'")
                .font(.caption)
            
            Spacer()
            
            //TODO: Add action and add correct colors/formatting
            
            Button("Order Now") {
                //Button
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.black)
            .padding()
            
            Spacer()
            Spacer()
            Spacer()
            
            
        }
    }
}

#Preview {
    HomeView()
}
