//
//  Modifiers.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func MlbOverlay(imageSize: CGFloat) -> some View {
        
        let lineWidth: CGFloat = 2.5
        let overlayColors: [Color] = [.red, .blue , .white]

        
        self
            .overlay(
              Circle()
                .stroke(
                  LinearGradient(colors: overlayColors, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: lineWidth)
                .frame(width: imageSize + 8, height: imageSize + 8)
            )
            .frame(width: imageSize + 10, height: imageSize + 10)
    }
}
