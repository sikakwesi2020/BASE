//
//  ContentView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    @StateObject var authViewModel = AuthViewModel()
    @State private var selectionTab = 0
    
    @State private var loadTeams:Bool = false
    
    @State private var isSignedIn = false
    @State private var signInWindow = false
 
    
    var body: some View {
       
        TabView(selection: $selectionTab, content: {
            Home()
                .tabItem {
                    VStack {
                        Image(systemName: "baseball.fill")
                        Text("BASE")
                    }
                }
                .tag(0)
            
            SchduleView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Schedule")
                    }
                }
                .tag(1)
            
            LeagueStandings()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet.clipboard")
                        Text("Standings")
                    }
                }
                .tag(2)
            HighLights()
                .tabItem {
                    VStack {
                        Image(systemName: "play.display")
                        Text("Highlights")
                    }
                }
                .tag(3)
        })
        .tint(Color.red)
        .fullScreenCover(isPresented: $signInWindow, content: {
            VStack {
             
                    GoogleSignInButton(action: authViewModel.signIn)
                  
                
            }
            .onChange(of: authViewModel.authToken) { _, upd in
                if let token = upd {
                    viewModel.accessToken = token
                     signInWindow = false
                }
            }
        })
        .fullScreenCover(isPresented: $loadTeams, content: {
            TeamsSelectionView(showCancel: .constant(false))
        })
        .onAppear {
            loadTeams.toggle()
            viewModel.loadSchedules()
            viewModel.fetchTeams()
            viewModel.fetchFavorites()
            
           // checkSignInStatus()

        }
        
        
        
    }
   
    
    func checkSignInStatus() {
           if let user = GIDSignIn.sharedInstance.currentUser {
               authViewModel.isSignedIn = true
              
               if let token = user.idToken?.tokenString {
                   authViewModel.authToken = token
                   viewModel.accessToken = token
               }
           } else {
               signInWindow.toggle()
           }
       }

}

struct GoogleSignInButton: View {
    @Environment(\.dismiss) var dismiss
    var action: () -> Void
    
    var body: some View {
        VStack {
            Image("hackImage")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            Button(action: action) {
                HStack {
                    Image(systemName: "g.circle.fill").foregroundColor(.red)
                    Text("Sign in with Google")
                        .foregroundColor(.primary)
                        .bold()
                }
                .padding()
                .frame(width: 300)
                .background(Color(.systemGray6))
                .cornerRadius(28)
            }
            
            Spacer()
        }
    }
}


//struct GoogleSignInButton: View {
//    var body: some View {
//        HStack {
//            Image(systemName: "googlelogo")
//                .resizable()
//                .frame(width: 20, height: 20)
//            Text("Sign in with Google")
//                .fontWeight(.medium)
//        }
//        .padding()
//        .background(Color.blue)
//        .foregroundColor(.white)
//        .cornerRadius(10)
//    }
//}

#Preview {
    ContentView()
        .environmentObject(TeamsViewModel())
}
