//
//  LoginView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 9/9/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    enum Field {
        case email, password
    }
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusField: Field?
    @State private var buttonDisabled = true
    //Query for orders then check to see if the user is in them
    @FirestoreQuery(collectionPath: "orders") var orders: [Order]
    @State private var LoginRegisterVM = LoginRegisterViewModel()
    
    var body: some View {
        NavigationStack {
            LogoView()
            
            
            Spacer()
            
            VStack {
                Text("Welcome To Eagles Eats!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                
                
                Spacer()
                
                
            }
            .frame(width: 300, height: 150)
            
            
            
            VStack{
                VStack {
                    HStack {
                        Text("Please Login:")
                            .padding([.leading], 5)
                        Spacer()
                    }
                    .frame(height: 30)
                    .padding([.leading], 5)
                    .padding(.bottom)
                    
                    
                    
                    TextField("Enter Your BC Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusField, equals: .email)
                        .onSubmit {
                            focusField = .password
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black.opacity(0.5), lineWidth: 2)
                        }
                        .frame(width: 360, height: 20)
                        .padding(5)
                        .onChange(of: password) {
                            buttonDisabled = LoginRegisterVM.enableButtonsLogin(email: email, password: password)
                        }
                    
                    SecureField("Enter Your Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .focused($focusField, equals: .password)
                        .onSubmit {
                            focusField = nil
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black.opacity(0.5), lineWidth: 2)
                        }
                        .frame(width: 360, height: 20)
                        .padding()
                        .onChange(of: password) {
                            buttonDisabled = LoginRegisterVM.enableButtonsLogin(email: email, password: password)
                        }
                    
                    
                }
                .frame(height: 200)
                .minimumScaleFactor(0.1)
                
                Button {
                    LoginRegisterVM.login(email: email, password: password)
                } label: {
                    Text("Login")
                        .frame(width: 320, height: 25)
                }
                .buttonStyle(.borderedProminent)
                .tint(.maroonBackground)
                .foregroundStyle(.goldBackground)
                .padding(7)
                .disabled(buttonDisabled)
            }
            .padding(.horizontal, 20)
            .frame(height: 200)
            
            Spacer()
            Spacer()
            Spacer()
            
            VStack (spacing: 0) {
                Text("Not Signed Up Yet?")
                    .padding([.bottom], 5)
                NavigationLink{
                    CreateAccountView()
                } label: {
                    Text("Create Your Account")
                }
            }
            .frame(width: 380, height: 120)
            
            Spacer()
            
        }
        .alert(LoginRegisterVM.alertMessage, isPresented: $LoginRegisterVM.showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if let user = Auth.auth().currentUser {
                print("Login Success!")
                print(user.email ?? "")
                LoginRegisterVM.presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $LoginRegisterVM.presentSheet) {
            if let userId = Auth.auth().currentUser?.uid {
                let activeOrder = orders.first { (($0.userID == userId) || ($0.delivererID == userId)) && ($0.delivering || $0.userID == userId)}
                if let order = activeOrder {
                    LockedOrderView(oldOrder: order)
                } else {
                    HomeView()
                }
            }
        }
        
    }
}


#Preview {
    LoginView()
}
