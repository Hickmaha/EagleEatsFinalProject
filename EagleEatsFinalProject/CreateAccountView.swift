//
//  CreateAccountView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 9/23/24.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var bcIdNumber = ""
    
    var body: some View {
        NavigationStack {
            LogoView()
                .frame(width: 150)
                .padding()
            
            Spacer()
            
            VStack {
                Text("Thank You For Joining!")
                    .font(Font.custom("Times New Roman", size: 40))
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
                            .font(Font.custom("Times New Roman", size: 20))
                            .padding([.leading], 5)
                        Spacer()
                    }
                    .frame(height: 30)
                    .padding([.leading], 5)
                    .padding(.bottom)
                    
                    TextField("Enter Your Full Name", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                        .font(Font.custom("Times New Roman", size: 20))
                        .minimumScaleFactor(0.1)
                        .frame(width: 360, height: 20)
                        .padding(5)
                    
                    
                    TextField("Enter Your BC Id Number", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                        .font(Font.custom("Times New Roman", size: 20))
                        .keyboardType(.numberPad)
                        .minimumScaleFactor(0.1)
                        .frame(width: 360, height: 20)
                        .padding()
                    
                    
                    TextField("Enter Your BC Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .font(Font.custom("Times New Roman", size: 20))
                        .keyboardType(.emailAddress)
                        .minimumScaleFactor(0.1)
                        .frame(width: 360, height: 20)
                        .padding(5)
                    
                    SecureField("Enter Your Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .font(Font.custom("Times New Roman", size: 20))
                        .minimumScaleFactor(0.1)
                        .frame(width: 360, height: 20)
                        .padding()
                    
                }
                .frame(height: 250)
                .minimumScaleFactor(0.1)
                
                Button {
                    //Something
                } label: {
                    Text("Create Account")
                        .fontWidth(.expanded)
                        .frame(width: 320, height: 25)
                }
                .buttonStyle(.borderedProminent)
                .font(Font.custom("Times New Roman", size: 25))
                .fontWeight(.bold)
                .tint(.maroonBackground)
                .foregroundStyle(.goldBackground)
                .padding(7)
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
        .minimumScaleFactor(0.1)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CreateAccountView()
}
