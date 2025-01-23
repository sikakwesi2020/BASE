//
//  ViewBuilders.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
 
extension ViewBuilder {
    
  
    
    @ViewBuilder
    
    static func Profile(id:Int, height: CGFloat) -> some View {
        WebImage(url: URL(string: "https://securea.mlb.com/mlb/images/players/head_shot/\(id).jpg")) { image in
               image.resizable()
           } placeholder: {
                   Rectangle().foregroundColor(.gray)
           }
           .indicator(.activity) // Activity Indicator
           .transition(.fade(duration: 0.5)) // Fade Transition with duration
           .scaledToFit()
           .frame(width: height, height: height)
    }
    
    
    static func playerPlayProfile(id:Int, type: String, height: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 65)
                .overlay(content: {
                    ZStack {
                        WebImage(url: URL(string: "https://securea.mlb.com/mlb/images/players/head_shot/\(id).jpg")) { image in
                               image.resizable()
                           } placeholder: {
                                   Rectangle().foregroundColor(.gray)
                           }
                           .indicator(.activity) // Activity Indicator
                           .transition(.fade(duration: 0.5)) // Fade Transition with duration
                           .scaledToFit()
                           .cornerRadius(40)
                        
                        
                        
                        
                        Text(type.capitalized)
                                .font(.caption)
                                .padding(.vertical, 3)
                                .padding(.horizontal, 5)
                                .bold()
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 5).fill(Color.black.gradient.opacity(0.7)))
                                .vAlign(.bottom)
                                .hAlign(.trailing)
                                .offset(x: -5, y: -5)
                        
                        
                    }
                })
        }
        .frame(height: height)
    }
    
    static func playerRosterProfile(person:Person, selected: Bool, position: String) -> some View {
        ZStack {
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 80, height: 80)
                        .overlay(content: {
                            ZStack {
//                                Image("player1")
//                                    .resizable()
//                                    .scaledToFit()
                                
                                WebImage(url: URL(string: "https://securea.mlb.com/mlb/images/players/head_shot/\(person.id).jpg")) { image in
                                       image.resizable()
                                   } placeholder: {
                                           Rectangle().foregroundColor(.gray)
                                   }
                                   .indicator(.activity) // Activity Indicator
                                   .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                   .scaledToFit()
                                   .cornerRadius(40)
                                  // .frame(width: 300, height: 300, alignment: .center)
                                  
                            }
                        })
                        .if(selected) {
                            $0.background (
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.red.gradient, lineWidth: 5)
                            )
                            .overlay(content: {
                                ZStack {
                                    Circle()
                                        .fill(.thinMaterial)
                                        .frame(width: 20,height: 20)
                                    
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .frame(width: 20,height: 20)
                                .vAlign(.top)
                                .hAlign(.trailing)
                            })
                        }
                        .if(position != "") {
                            $0.overlay(content: {
                                ZStack {
                                    Circle()
                                        .fill(.thinMaterial)
                                        .frame(width: 20,height: 20)
                                    
                                    Text(position)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                        .bold()
                                }
                                .frame(width: 20,height: 20)
                                .vAlign(.top)
                                .hAlign(.trailing)
                            })
                        }
                }
                .frame(height: 90)
                Text(person.fullName)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(height: 20)
            }
            .frame(width: 100)
          
        }
    }
    
    @ViewBuilder
    static func advancedBadge(String: String, bgColor: Color) -> some View{
        Text(String)
            .font(.caption)
            .padding(.vertical, 3)
            .padding(.horizontal, 5)
            .bold()
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 5).fill(bgColor.gradient.opacity(0.7)))
    }
    
    @ViewBuilder
    static func smallBadge(String: String) -> some View{
        Text(String)
            .font(.caption)
            .padding(.vertical, 3)
            .padding(.horizontal, 5)
            .bold()
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 5).fill(Color.blue.gradient.opacity(0.7)))
    }
    
    @ViewBuilder
     static func newHightlight(execute: @escaping () -> Void) -> some View {
        VStack {
            let overlayColors: [Color] = [.red, .red, .blue, .blue, .white]
            Circle()
                .fill(Color.white.gradient)
                .frame(width: 60, height: 60)
                .overlay(content: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.red)
                })
                .overlay(
                  Circle()
                    .stroke(
                        LinearGradient(colors: overlayColors, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5)
                    .frame(width: 60 + 8, height: 60 + 8)
                )
                .frame(width: 60 + 8, height: 60 + 8)
                .onTapGesture { execute() }

        }
    }
    
    @ViewBuilder
    static func localImage(name: String, width: CGFloat, height: CGFloat, circle: Bool, corners: CGFloat, execute: @escaping () -> Void) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .if(circle) {
                $0.clipShape(Circle())
            }
            .if(!circle) {
                $0.cornerRadius(corners)
            }
            .onTapGesture {
                execute()
            }
          
    }
    
    @ViewBuilder
    static func localImage(name: String, width: CGFloat, height: CGFloat, circle: Bool, corners: CGFloat) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .if(circle) {
                $0.clipShape(Circle())
            }
            .if(!circle) {
                $0.cornerRadius(corners)
            }
            .onTapGesture {
                
            }
          
    }
    
    @ViewBuilder
    static func Webimage(name: String) -> some View {
        let imageSize: CGFloat = 60
         let lineWidth: CGFloat = 2.5
         let overlayColors: [Color] = [.mint, .gray.opacity(0.5), .indigo, .blue]

        VStack {
            WebImage(url: URL(string:  name)) { image in
                image.resizable()
            } placeholder: {
                Image("photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(imageSize)
            }
            .resizable()
            .scaledToFill()
            .frame(width: imageSize, height: imageSize)
            .cornerRadius(imageSize)
            .overlay(
              Circle()
                .stroke(
                  LinearGradient(colors: overlayColors, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: lineWidth)
                .frame(width: imageSize + 8, height: imageSize + 8)
            )
            .frame(width: imageSize + 10, height: imageSize + 10)
        }
    }
    
    
    @ViewBuilder
    static func customHeader(title: String) -> some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Divider()
        }
        .padding()
    }

    @ViewBuilder
    static func customCard(content: String) -> some View {
        VStack {
            Text(content)
                .font(.body)
                .padding()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding()
    }
}
