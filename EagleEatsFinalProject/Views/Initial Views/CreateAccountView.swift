//
//  CreateAccountView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 9/23/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct CreateAccountView: View {
    enum Field {
        case fullname, bcIdNumber, email, password
    }
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var bcIdNumber = ""
    @FocusState private var focusField: Field?
    @State private var presentSheet = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            LogoView()
            
            Spacer()
            
            VStack {
                
                Text("Thank You For Joining!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                
                
                Spacer()
                
                
            }
            .frame(width: 300, height: 200)
            
            
            Spacer()
            
            VStack{
                VStack {
                    HStack {
                        Text("Create Your Account:")
                            .padding([.leading], 5)
                        Spacer()
                    }
                    .frame(height: 30)
                    .padding([.leading], 5)
                    .padding(.bottom)
                    
                    TextField("Enter Your Full Name", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.next)
                        .autocorrectionDisabled()
                        .focused($focusField, equals: .fullname)
                        .onSubmit {
                            focusField = .bcIdNumber
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black.opacity(0.5), lineWidth: 2)
                        }
                        .frame(width: 360, height: 20)
                        .padding(5)
                        .onChange(of: fullName) {
                            enableButtons()
                        }
                    
                    
                    TextField("Enter Your BC ID Number", text: $bcIdNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .submitLabel(.next)
                        .focused($focusField, equals: .bcIdNumber)
                        .onSubmit {
                            focusField = .email
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black.opacity(0.5), lineWidth: 2)
                        }
                        .frame(width: 360, height: 20)
                        .padding()
                        .onChange(of: bcIdNumber) {
                            enableButtons()
                        }
                    
                    
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
                        .onChange(of: email) {
                            enableButtons()
                        }
                    
                    SecureField("Enter Your Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .minimumScaleFactor(0.1)
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
                            enableButtons()
                        }
                    
                }
                .frame(height: 250)
                .minimumScaleFactor(0.1)
                
                Button {
                    register()
                } label: {
                    Text("Create Account")
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
            
            VStack (spacing: 0) {
                Text("Already Have An Account?")
                    .padding([.bottom], 5)
                NavigationLink(destination: {
                    LoginView()
                }, label: {
                    Text("Login Here")
                })
            }
            .frame(width: 380, height: 120)
            
            Spacer()
            
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $presentSheet) {
                HomeView()
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        let nameIsGood = fullName.count > 1
        let bcId = Int(bcIdNumber) ?? 0
        let bcIdIsGood = bcId > 10000000
        buttonDisabled = !(emailIsGood && passwordIsGood && bcIdIsGood && nameIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Registration Error: \(error.localizedDescription)")
                alertMessage = "Registration Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                Task {
                    let user = User(fullName: fullName, bcIdNumber: Int(bcIdNumber) ?? 0, userId: Auth.auth().currentUser?.uid ?? "")
                    print("Registration Success!")
                    let id = await   LoginRegisterViewModel.saveUser(user: user)
                    presentSheet = true
                }
            }
        }
    }
}

#Preview {
    CreateAccountView()
}
