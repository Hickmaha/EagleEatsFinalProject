//
//  LoginRegisterViewModel.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/4/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class LoginRegisterViewModel {
    var presentSheet: Bool = false
    var showingAlert: Bool = false
    var alertMessage: String = ""
    
    static func saveUser(user: User) async -> String? {
        let db = Firestore.firestore()
        
        if let id = user.id { //we have the spot
            do {
                try db.collection("users").document(id).setData(from: user)
                print("Data updated successfully")
                return id
            }
            catch {
                print("Could not update data in 'users' \(error.localizedDescription)")
                return id
            }
        } else { //need to add a new spot
            do {
                let docRef = try db.collection("users").addDocument(from: user)
                print("Data added successfully")
                return docRef.documentID
            } catch {
                print("Could not create a new spot in 'users' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func enableButtonsLogin(email: String, password: String)->Bool {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        return !(emailIsGood && passwordIsGood)
    }
    
    func enableButtonsRegister(email: String, password: String, fullName: String, bcIdNumber: String)->Bool {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        let nameIsGood = fullName.count > 1
        let bcId = Int(bcIdNumber) ?? 0
        let bcIdIsGood = bcId > 10000000
        return !(emailIsGood && passwordIsGood && bcIdIsGood && nameIsGood)
    }
    
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                self.alertMessage = "Login Error: \(error.localizedDescription)"
                self.showingAlert = true
            } else {
                print("Login Success!")
                self.presentSheet = true
            }
        }
    }
    
    func register(email: String, password: String, fullName: String, bcIdNumber: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Registration Error: \(error.localizedDescription)")
                self.alertMessage = "Registration Error: \(error.localizedDescription)"
                self.showingAlert = true
            } else {
                Task {
                    let user = User(fullName: fullName, bcIdNumber: Int(bcIdNumber) ?? 0, userId: Auth.auth().currentUser?.uid ?? "")
                    print("Registration Success!")
                    let id = await   LoginRegisterViewModel.saveUser(user: user)
                    self.presentSheet = true
                }
            }
        }
    }
}

