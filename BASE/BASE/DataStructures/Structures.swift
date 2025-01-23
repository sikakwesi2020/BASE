//
//  Structures.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import Foundation
import SwiftUI

struct MiniCard {
    let id: UUID
    let name: String
    let image: String
    let description: String
    let type: String
    let view: AnyView?
}

struct BaseCards {
    let miniLeagueTitle: String
    let title: String
    let minititle: String
    let forgroundimage: String
    let icon: String
    let view: AnyView
}

