////
////  singlePlayDisclosureCard.swift
////  BASE
////
////  Created by MAXWELL TAWIAH on 1/10/25.
////
//
//import SwiftUI
//
//struct singlePlayDisclosureCard: View {
//    let play: Play?
//    var body: some View {
//        DisclosureGroup(content: {
//            Text("Content")
//        }, label: {
//            VStack {
//                HStack(alignment: .top) {
//                    Rectangle()
//                        .frame(width: 70, height: 140)
//                        .cornerRadius(40)
//                        .overlay(content: {
//                            VStack {
//                                ViewBuilder.playerPlayProfile(id: 681911, type: "B", height: 65)
//                                
//                                Spacer()
//                                ViewBuilder.playerPlayProfile(id: 605483, type: "P", height: 65)
//                                
//                            }
//                            .padding(.vertical, 5)
//                        })
//                    
//                    VStack(alignment: .leading) {
//                        Text("@Flyout")
//                            .bold().padding(.top, 5)
//                        (Text("#Play ").bold() + Text("Shohei Ohtani flies out to center fielder Aaron Judge."))
//                            .multilineTextAlignment(.leading)
//                            .foregroundColor(.black)
//                        
//                        HStack {
//                            ViewBuilder.smallBadge(String: "Mets → 0")
//                            ViewBuilder.smallBadge(String: "Yankees → 0")
//                            Spacer()
//                        }
//                        HStack {
//                            ViewBuilder.advancedBadge(String: "Shohei Ohtani", bgColor: Color.black)
//                            ViewBuilder.advancedBadge(String: "Aaron Judge", bgColor: Color.red)
//                            Spacer()
//                        }
//                    }
//                }
//            }
//          
//        })
//        
//    }
//}
//
//#Preview {
//    singlePlayDisclosureCard(play: nil)
//}
