//
//  LoginView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 9/9/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        LogoView()
        
        Spacer()
        
        VStack {
            TextField("Enter Your Full Name", text: $fullName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Enter Your BC Email", text: $email)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Enter Your Password", text: $password)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal, 20)
        
        
        Spacer()
    }
}

#Preview {
    LoginView()
}
