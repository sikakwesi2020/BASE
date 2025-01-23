//
//  LiveGameLiveActivity.swift
//  LiveGame
//
//  Created by MAXWELL TAWIAH on 1/4/25.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct GameLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GameAttributes.self) { context in
            GameLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded View
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Image(context.attributes.homeTeamImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("\(context.state.homeScore)")
                            .bold()
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Image(context.attributes.awayTeamImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("\(context.state.awayScore)")
                            .bold()
                    }
                }

                DynamicIslandExpandedRegion(.center) {
                    Text("Now Playing at \(context.attributes.stadiumName)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            } compactLeading: {
                Text("\(context.state.homeScore)")
                    .bold()
            } compactTrailing: {
                Text("\(context.state.awayScore)")
                    .bold()
            } minimal: {
                Text("\(context.state.homeScore)-\(context.state.awayScore)")
                    .bold()
            }
        }
    }
}

#Preview("Notification", as: .content, using: GameAttributes(homeTeam: "New York Yankees", awayTeam: "Boston Red Sox", stadiumName: "Yankee Stadium", homeTeamImage: "yankees_logo", awayTeamImage: "redsox_logo")) {
    GameLiveActivityWidget()
} contentStates: {
    GameAttributes.ContentState(homeScore: 3, awayScore: 2)
    GameAttributes.ContentState(homeScore: 5, awayScore: 4)
    GameAttributes.ContentState(homeScore: 6, awayScore: 6)
}
