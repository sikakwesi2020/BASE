//
//  DisclosureContent.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/12/25.
//

import SwiftUI

struct DisclosureContent: View {
    
    @EnvironmentObject var viewModel:TeamsViewModel
    
    var Plays: [String: Any]
     
    var body: some View {
        VStack {
//            
//            if let play = Plays as? [String: Any],
//               let playEvents = play["playEvents"] as? [[String: Any]] {
//                Text("\(playEvents.prefix(100))")
//                    .foregroundColor(.black)
//                  //  PlayEventTimelineView(playEvents: playEvents)
//                    .onAppear {
//                        print("full play event data: \(playEvents.count)")
//                    }
//            }
//         
            
        }
        .onAppear {
            // Assuming `Plays` is your raw JSON dictionary
            GamePlayHelper().decodePlayEvents(from: self.Plays)
        }
      
    }
  
}

#Preview {
    DisclosureContent(Plays: [:])
}
