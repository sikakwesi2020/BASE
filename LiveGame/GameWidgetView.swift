//
//  GameWidgetView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/4/25.
//

import SwiftUI

import WidgetKit
import SwiftUI

struct GameLiveActivityView: View {
    let context: ActivityViewContext<GameAttributes>

    var body: some View {
        VStack {
            
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                VStack (alignment: .leading){
                    Text(context.attributes.homeTeam)
                        .font(.headline)
                    Text("Yankees")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                 Text("\(context.state.homeScore)")
                     .font(.largeTitle)
                     .bold()
            }
            
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 1)
                    
                    Text("LIVE")
                        .padding(2)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                        .background(Rectangle().cornerRadius(10))
                }
                .frame(height: 5)
            }
            
            HStack {
                
               
                    Circle()
                        .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(context.attributes.awayTeam)
                        .font(.headline)
                    Text("Red Sox")
                        .foregroundColor(.gray)
                }
                Spacer()
                    Text("\(context.state.awayScore)")
                        .font(.largeTitle)
                        .bold()
                
            }
        
//            .background(
//                RoundedRectangle(cornerRadius: 15)
//                    .fill(Color(.systemBackground))
//                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
//            )
         //   .padding()
        }
        .padding()
    }
}
#Preview("Notification", as: .content, using: GameAttributes(homeTeam: "New York Yankees", awayTeam: "Boston Red Sox", stadiumName: "Yankee Stadium", homeTeamImage: "Mets2", awayTeamImage: "Mets")) {
    GameLiveActivityWidget()
} contentStates: {
    GameAttributes.ContentState(homeScore: 3, awayScore: 2)
    GameAttributes.ContentState(homeScore: 5, awayScore: 4)
    GameAttributes.ContentState(homeScore: 6, awayScore: 6)
}
