//
//  HomeView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 9/4/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import MapKit

struct HomeView: View {
    @State private var sheetIsPresent = false
    @Environment(\.dismiss) var dismiss
    @FirestoreQuery(collectionPath: "users") var users: [User]
    @State private var locationManager = LocationManager()
    
    var body: some View {
        
        NavigationStack {
            if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .notDetermined {
                VStack {
                    ForEach(users) { user in
                        if user.userId == Auth.auth().currentUser?.uid {
                            HStack {
                                Text("Welcome \(user.fullName)!")
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                    NavigationLink {
                        DeliveryView()
                    } label: {
                        ZStack(alignment: .leading) {
                            Image("deliveryImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 350, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("Order Food")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                            .opacity(0.9)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.black, lineWidth: 1)
                                            )
                                    )
                                    .padding()
                            }
                            
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.black, lineWidth: 1)
                                .foregroundStyle(.clear)
                        }
                        .frame(width: 350, height: 200)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        DelivererView()
                    } label: {
                        ZStack(alignment: .leading) {
                            Image("delivererImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 350, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("Deliver Orders")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white)
                                            .opacity(0.9)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.black, lineWidth: 1)
                                            )
                                    )
                                    .padding()
                            }
                            
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.black, lineWidth: 1)
                                .foregroundStyle(.clear)
                        }
                        .frame(width: 350, height: 200)
                    }
                    
                    Spacer()
                    Spacer()
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                dismiss()
                                print("Log out sucessful")
                            } catch {
                                print("Error: Could not sign out!")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.maroonBackground)
                        .foregroundStyle(.goldBackground)
                    }
                }
            } else {
                Spacer()
                Text("You Need To Allow Location Services To Use This App")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                    .foregroundStyle(.maroonBackground)
                    .bold()
                    .padding()
                
                    Spacer()
            }
        }
    }
}


#Preview {
    HomeView()
}
