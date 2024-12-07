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
    @State private var buttonDisabled = true
    @State private var LoginRegisterVM = LoginRegisterViewModel()
    
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
                            buttonDisabled = LoginRegisterVM.enableButtonsRegister(email: email, password: password, fullName: fullName, bcIdNumber: bcIdNumber)
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
                            buttonDisabled = LoginRegisterVM.enableButtonsRegister(email: email, password: password, fullName: fullName, bcIdNumber: bcIdNumber)
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
                            buttonDisabled = LoginRegisterVM.enableButtonsRegister(email: email, password: password, fullName: fullName, bcIdNumber: bcIdNumber)
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
                            buttonDisabled = LoginRegisterVM.enableButtonsRegister(email: email, password: password, fullName: fullName, bcIdNumber: bcIdNumber)
                        }
                    
                }
                .frame(height: 250)
                .minimumScaleFactor(0.1)
                
                Button {
                    LoginRegisterVM.register(email: email, password: password, fullName: fullName, bcIdNumber: bcIdNumber)
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
        .alert(LoginRegisterVM.alertMessage, isPresented: $LoginRegisterVM.showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $LoginRegisterVM.presentSheet) {
                HomeView()
        }
    }
}

#Preview {
    CreateAccountView()
}
