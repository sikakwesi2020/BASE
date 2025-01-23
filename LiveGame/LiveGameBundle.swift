//
//  LiveGameBundle.swift
//  LiveGame
//
//  Created by MAXWELL TAWIAH on 1/4/25.
//

import WidgetKit
import SwiftUI

@main
struct LiveGameBundle: WidgetBundle {
    var body: some Widget {
        LiveGameControl()
        GameLiveActivityWidget()
    }
}
