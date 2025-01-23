//
//  ConditionalModifiers.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import Foundation
import SwiftUI
import UIKit

struct ConditionalModifier: ViewModifier {
    let condition: Bool
    let trueModifier: (Content) -> AnyView

    init(condition: Bool, trueModifier: @escaping (Content) -> AnyView) {
        self.condition = condition
        self.trueModifier = trueModifier
    }

    func body(content: Content) -> some View {
        if condition {
            return trueModifier(content)
        } else {
            return AnyView(content)
        }
    }
}

extension View {
    func applyModifier(
        if condition: Bool,
        trueModifier: @escaping (Self) -> AnyView
    ) -> some View {
        self.modifier(ConditionalModifier(condition: condition, trueModifier: { content in
            trueModifier(self)
        }))
    }
}


extension View {
    /// Apply a modifier conditionally
    @ViewBuilder func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    /// Apply a modifier conditionally without an else clause
    @ViewBuilder func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
