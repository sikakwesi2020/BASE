//
//  GoogleAuth.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/15/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var userEmail: String?
    
    @Published  var userInfo: String?
    @Published  var authToken: String?
    
    
       
       func signIn() {
           
           guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                 let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
                 let presentingViewController = keyWindow.rootViewController else {
               print("No root view controller available")
               return
           }
           
           GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
               guard error == nil else {
                   print("Error signing in: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }
               guard let user = signInResult?.user else {
                   print("No user information found")
                   return
               }
               
               // Retrieve the authentication token
               if let token = user.idToken?.tokenString {
                   self.authToken = token
                   print("Auth Token: \(token)")
               } else {
                   print("No auth token found")
               }
               
               self.isSignedIn = true
           }
       }

    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        isSignedIn = false
        userEmail = nil
    }
}
