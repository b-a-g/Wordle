//
//  UserViewModel.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//

import SwiftUI
import FirebaseAuth

class UserViewModel: ObservableObject {
    @AppStorage("isSignedIn") var isSignedIn = false
    @Published var email = ""
    @Published var password = ""
    @Published var alert = false
    @Published var alertMessage = ""
    
    public var completion: (() -> Void)? = nil

    private func showAlertMessage(message: String) {
        alertMessage = message
        alert.toggle()
    }

    func login() {
        // check if all fields are inputted correctly
        if email.isEmpty || password.isEmpty {
            showAlertMessage(message: "Neither email nor password can be empty.")
            return
        }
        // sign in with email and password
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                self.alertMessage = err.localizedDescription
                self.alert.toggle()
            } else if let result = result {
                self.email = result.user.email ?? ""
                self.isSignedIn = true
                self.completion?()
            }
        }
    }

    func signUp() {
        // check if all fields are inputted correctly
        if email.isEmpty || password.isEmpty {
            showAlertMessage(message: "Neither email nor password can be empty.")
            return
        }
        // sign up with email and password
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                self.alertMessage = err.localizedDescription
                self.alert.toggle()
            } else {
                self.login()
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            email = ""
            password = ""
        } catch {
            print("Error signing out.")
        }
    }
}

let user = UserViewModel()
