//
//  MiniHCards.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import SwiftUI

struct MiniHCards: View {
    
    @Environment(\.colorScheme) var color
    @State private var POTW = false
    @State private var SHR = false
    
    let miniViews: [MiniCard] = [MiniCard(id: UUID(), name: NSLocalizedString("Trending plays", comment: ""), image: "play", description: NSLocalizedString("Alex Verdugo strikes out swinging.", comment: ""), type: NSLocalizedString("@Strikeout ", comment: ""), view: AnyView(ViewBuilder.smallBadge(String: NSLocalizedString("+14 Plays", comment: "")))),
                                 MiniCard(id: UUID(), name: NSLocalizedString("Season Home Run", comment: ""), image: "play-1", description: NSLocalizedString("Home Run All in One: Explore the stats, trends, and insights that define every season’s biggest hits.", comment: ""), type: NSLocalizedString("#HomeRun ", comment: ""), view: AnyView(ViewBuilder.smallBadge(String: "Videos")))]
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                
                HStack {
                    Image(miniViews[0].image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                    VStack(alignment: .leading) {
                        Text("Trending plays")
                            .font(.headline).foregroundColor(Color.black)
                        (Text("@Strikeout ").fontWeight(.semibold).foregroundColor(.red) + Text("Alex Verdugo strikes out swinging.").foregroundColor(.gray))
                            .lineLimit(3)
                            .font(.caption)
                        
                        miniViews[0].view
                        
                        Spacer()
                    }
                    .frame(width: 200, height:90 )
                    .padding()
                    
                    Spacer()
                    
                }
                .frame(width: 350, height: 100)
                .background(Color.white.gradient)
                .cornerRadius(10)
                .shadow(radius: 5)
                .onTapGesture {
                    POTW.toggle()
                }
                
                HStack {
                    Image(miniViews[1].image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                    VStack(alignment: .leading) {
                        Text("Season Home Run")
                            .font(.headline).foregroundColor(Color.black)
                        (Text("#HomeRun ").fontWeight(.semibold).foregroundColor(.red) + Text("Home Run All in One: Explore the stats, trends, and insights that define every season’s biggest hits.").foregroundColor(.gray))
                            .lineLimit(3)
                            .font(.caption)
                        
                        miniViews[1].view
                        
                        Spacer()
                    }
                    .frame(width: 200, height:90 )
                    .padding()
                    
                    Spacer()
                    
                }
                .frame(width: 350, height: 100)
                .background(Color.white.gradient)
                .cornerRadius(10)
                .shadow(radius: 5)
                .onTapGesture {
                    SHR.toggle()
                }
                
                
//                ForEach(miniViews, id: \.id) { data in
//                    card(data: data) { type in
//                        if type == "Trending plays" {
//                            POTW.toggle()
//                        }
//                        if type == "Season Home Run" {
//                            SHR.toggle()
//                        }
//                    }
//                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $POTW, content: {
            POTWView()
        })
        .fullScreenCover(isPresented: $SHR, content: {
            SHRView()
        })
    }
        
    
    
    @ViewBuilder
    func card(data: MiniCard, execute: @escaping (String) -> Void) -> some View {
        HStack {
            Image(data.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                //.clipped()
            
            VStack(alignment: .leading) {
                Text(NSLocalizedString(data.name, comment: "") )
                    .font(.headline).foregroundColor(Color.black)
                (Text(data.type).fontWeight(.semibold).foregroundColor(.red) + Text(data.description).foregroundColor(.gray))
                    .lineLimit(3)
                    .font(.caption)
                
                if let view = data.view {
                    view
                }
                
                Spacer()
            }
            .frame(width: 200, height: data.view != nil ? 90 : 80)
            .padding()
            
            Spacer()
            
        }
        .frame(width: 350, height: 100)
        .background(Color.white.gradient)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onTapGesture {
            execute(data.name)
        }
       
    }
}

#Preview {
   // ContentView()
    Home()
        .environmentObject(TeamsViewModel())
}
