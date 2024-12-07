//
//  LockedOrderView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/2/24.
//

import SwiftUI
import FirebaseAuth
import MapKit
import FirebaseFirestore

struct LockedOrderView: View {
    @State var oldOrder: Order
    @State private var passkeyText = ""
    @State private var sheetIsPresented = false
    @State private var position = MapCameraPosition.camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 42.33618330773592, longitude: -71.1688687374547), distance: 2500))
    @FocusState private var isFocused
    @State private var locationManager = LocationManager() // Create an instance of LocationManager
    @State private var currentLocation: CLLocation?
    @State private var usedOrder: Order?
    
    // Optional error message state
    @State private var errorMessage: String?
    @FirestoreQuery(collectionPath: "users") var users: [User]
    
    var body: some View {
        NavigationStack {
            VStack {
                if let order = usedOrder { // Safely unwrap usedOrder
                    if !isFocused {
                        if order.delivering {
                            ForEach(users) { user in
                                if let yourUser = Auth.auth().currentUser?.uid {
                                    if yourUser == user.id && yourUser == order.userID {
                                        HStack {
                                            Text("Deliverer Name: \(user.fullName)")
                                                .font(.title2)
                                                .bold()
                                            
                                        }
                                        .padding()
                                    } else if yourUser == user.id && yourUser == order.delivererID {
                                        HStack {
                                            Text("Delivering To: \(user.fullName)")
                                                .font(.title2)
                                                .bold()
                                            
                                            Spacer()
                                        }
                                        .padding()
                                    }
                                }
                            }
                            
                            Map(position: $position) {
                                Marker(coordinate: CLLocationCoordinate2D(latitude: order.diningHall.latitude, longitude: order.diningHall.longitude)) {
                                    VStack {
                                        Image(systemName: "fork.knife")
                                            .font(.title)
                                        Text(order.diningHall.name)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .padding(4)
                                            .background(Color.white)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                Marker(coordinate: CLLocationCoordinate2D(latitude: order.dorm.latitude, longitude: order.dorm.longitude))  {
                                    VStack {
                                        Image(systemName: "house")
                                            .font(.title)
                                        Text(order.dorm.name)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .padding(4)
                                            .background(Color.white)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                
                                Marker(coordinate: CLLocationCoordinate2D(latitude: order.delivererLatitude, longitude: order.delivererLongitude)) {
                                    VStack {
                                        Image(systemName: "person.circle.fill")
                                            .font(.title)
                                        Text("Deliverer")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .padding(4)
                                            .background(Color.white)
                                            .cornerRadius(4)
                                    }
                                }
                                .tint(.blue)
                            }
                            .disabled(true)
                            .edgesIgnoringSafeArea(.all)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(height: 400)
                            .padding(.vertical)
                        } else {
                            ProgressView()
                                .scaleEffect(4)
                                .frame(height: 400)
                                .padding(.vertical)
                        }
                        
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Delivering To: \(order.dorm.name)")
                                Spacer()
                            }
                            HStack {
                                Text("From: \(order.diningHall.name)")
                                Spacer()
                            }
                        }
                        .font(.title2)
                        .fontWeight(.medium)
                        .navigationBarBackButtonHidden()
                        
                        if !order.delivering {
                            Spacer()
                            HStack {
                                Button("Cancel Order") {
                                    Task {
                                        OrderViewModel.deleteOrder(order: order)
                                        sheetIsPresented.toggle()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .foregroundStyle(.goldBackground)
                                .tint(.maroonBackground)
                                Spacer()
                            }
                            .padding(.leading)
                        } else if order.delivererID == Auth.auth().currentUser?.uid {
                            Spacer()
                            HStack {
                                NavigationLink("View Order Items") {
                                    ItemListView(order: order)
                                }
                                .buttonStyle(.borderedProminent)
                                .foregroundStyle(.goldBackground)
                                .tint(.maroonBackground)
                                Spacer()
                            }
                            
                        }
                    }
                    Spacer()
                    
                    if order.userID == Auth.auth().currentUser?.uid {
                        VStack {
                            Text("Order Code: " + String(order.passkey))
                                .font(.largeTitle)
                            
                        }
                    } else if order.delivererID == Auth.auth().currentUser?.uid {
                        VStack {
                            Spacer()
                            
                            TextField("Enter Passkey", text: $passkeyText)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black.opacity(0.5), lineWidth: 2)
                                }
                                .focused($isFocused)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 360, height: 20)
                                .padding(.horizontal)
                            
                            Spacer()
                            VStack {
                                if isFocused {
                                    Spacer()
                                    
                                    Button("Return") {
                                        isFocused.toggle()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .foregroundStyle(.goldBackground)
                                    .tint(.maroonBackground)
                                    
                                    Spacer()
                                }
                                Button("Finish Order") {
                                    if let attempt = Int(passkeyText) {
                                        print("\(attempt)")
                                        if attempt == order.passkey {
                                            OrderViewModel.deleteOrder(order: order) // Use the queried order
                                            sheetIsPresented = true
                                        }
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .foregroundStyle(.goldBackground)
                                .tint(.maroonBackground)
                            }
                        }
                    }
                } else if let errorMessage = errorMessage { // Show error message if fetching fails
                    Text(errorMessage).foregroundColor(.red).padding()
                } else {
                    ProgressView() // Loading indicator while fetching
                }
            }
            .navigationTitle(usedOrder?.delivering == true ? "Order On The Way" : "Looking For Deliverer...")
            .padding()
            .fullScreenCover(isPresented: $sheetIsPresented) {
                HomeView()
            }
        }
        .onChange(of: currentLocation) {
            Task {
                if let trackedOrder = usedOrder {
                    var updatedOrder = trackedOrder
                    if updatedOrder.delivererID == Auth.auth().currentUser?.uid {
                        
                        updatedOrder.delivererLatitude = currentLocation?.coordinate.latitude ?? 0.0
                        updatedOrder.delivererLongitude = currentLocation?.coordinate.longitude ?? 0.0
                        let _ = await OrderViewModel.saveOrder(order: updatedOrder)
                        print(updatedOrder.delivererLatitude)
                        print(updatedOrder.delivererLongitude)
                    }
                }
            }
        }
        .onAppear {
            print("\n")
            print(oldOrder)
            // Initialize current location with old order's deliverer coordinates
            currentLocation = CLLocation(latitude: oldOrder.delivererLatitude, longitude: oldOrder.delivererLongitude)
            
            // Fetch order data from Firestore
            if let id = oldOrder.id {
                fetchOrder(withId: id) // Replace with actual document ID if needed
            }
            
            // Set up location manager to receive updates
            locationManager.locationUpdated = { location in
                self.currentLocation = location // Update current location when it changes
                
                // Optionally update camera position on map based on deliverer's current location
//                position = .camera(MapCamera(centerCoordinate: location.coordinate, distance: 2500))
            }
        }
    }
    private func fetchOrder(withId id: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("orders").document(id)
        
        // Listen for real-time updates
        docRef.addSnapshotListener { document, error in
            if let error = error {
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
                return
            }
            
            guard let document = document, document.exists else {
                self.errorMessage = "Document does not exist"
                return
            }
            
            do {
                self.usedOrder = try document.data(as: Order.self) // Store fetched data in usedOrder
            } catch {
                self.errorMessage = "Error decoding document: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    NavigationStack {
        LockedOrderView(oldOrder: Order()) // No initial Order needed since it will be fetched from Firestore
    }
}
