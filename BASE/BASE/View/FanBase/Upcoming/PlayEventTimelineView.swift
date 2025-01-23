//
//  PlayEventTimelineView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/11/25.
//

import SwiftUI

struct PlayEventTimelineView: View {
    var playEvents: [[String: Any]]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(playEvents.indices, id: \.self) { index in
                    if let eventDetails = playEvents[index]["details"] as? [String: Any],
                       let event = eventDetails["event"] as? String,
                       let description = eventDetails["description"] as? String,
                       let awayScore = eventDetails["awayScore"] as? Int,
                       let homeScore = eventDetails["homeScore"] as? Int {
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text(event)
                                .font(.headline)
                                .foregroundColor(.blue)
                                .multilineTextAlignment(.center)
                            
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                VStack {
                                    Text("Away")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(awayScore)")
                                        .font(.title2)
                                        .bold()
                                }
                                
                                VStack {
                                    Text("Home")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(homeScore)")
                                        .font(.title2)
                                        .bold()
                                }
                            }
                        }
                        .padding()
                        .frame(width: 150)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    PlayEventTimelineView(playEvents: [])
}
