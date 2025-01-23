//
//  LocaleState.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/9/25.
//

import Foundation
class LocalState: ObservableObject {
    @Published var needsRestart: Bool = false
    @Published var viewneedsRestart: Bool = false

    func restartView() { 
        viewneedsRestart = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewneedsRestart = false
        }
    }
    
    func restartApp() {
        needsRestart = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.needsRestart = false
        }
    }
}
