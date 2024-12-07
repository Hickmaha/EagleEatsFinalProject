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

struct HomeView: View {
    @State private var sheetIsPresent = false
    @Environment(\.dismiss) var dismiss
    @FirestoreQuery(collectionPath: "users") var users: [User]
    var body: some View {
        NavigationStack {
            
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
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 1)
                            .foregroundStyle(.white)
                        
                        
                        VStack (alignment: .leading) {
                            Spacer()
                            
                            Rectangle()
                                .foregroundStyle(.black)
                                .frame(maxHeight: 1)
                                .padding(.horizontal)
                            
                            
                            Text("Order Food")
                                .font(.title2)
                                .fontWeight(.bold)
                                .tint(.black)
                                .padding()
                        }
                    }
                    .frame(width: 350, height: 200)
                }
                
                Spacer()
                
                NavigationLink {
                    DelivererView()
                } label: {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 1)
                            .foregroundStyle(.white)
                        
                        
                        VStack (alignment: .leading) {
                            Spacer()
                            
                            Rectangle()
                                .foregroundStyle(.black)
                                .frame(maxHeight: 1)
                                .padding(.horizontal)
                            
                            Text("Deliver Food")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding()
                        }
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
        }
    }
}


#Preview {
    HomeView()
}
