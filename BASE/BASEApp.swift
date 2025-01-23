//
//  BASEApp.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import SwiftUI
import GoogleSignIn

@main
struct BASEApp: App {
    @StateObject private var appData: TeamsViewModel = .init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState = LocalState()
    var body: some Scene {
        WindowGroup {
            if appState.needsRestart {
                EmptyView()
            } else {
                ContentView()
                    .environmentObject(appData)
                    .environment(\.locale, LocaleManager.shared.fetchInitialLocale())
                    .environmentObject(appState)
                    .onAppear {
                        appData.fetchTeams()
                    }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
