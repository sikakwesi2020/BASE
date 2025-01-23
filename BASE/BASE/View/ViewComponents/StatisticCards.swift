//
//  StatisticCards.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/24/24.
//

import SwiftUI

struct StatisticCards: View {
    
    @State private var screenWidth = UIScreen.main.bounds.size.width
    @State private var image: UIImage?
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    
    let ShortName: String
    let LongName: String
    let LeagueName: String
    let foreImage: String
    let icon: String
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("play-of-the-week")
                    .resizable()
                    .scaleEffect(1.5)
                    .blur(radius: 40)
                    .cornerRadius(14)
                    .frame(maxWidth: (screenWidth - 20))
                    .if(isIpad) {
                        $0.frame(height: 300)
                    }
                    .if(!isIpad) {
                        $0.frame(height: 150)
                    }
                    .opacity(0.7)
                    
                
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(LeagueName)
                                    .font(.footnote)
                                    .fontWeight(.light).shadow(radius: 6)
                                    .foregroundColor(colorScheme == .dark ? .white  : .black)
                                Spacer()
                            }
                           
                               
                            Text(LongName)
                                .font(.title)
                                .bold()
                                .lineLimit(1)
                                .foregroundColor(colorScheme == .dark ? .white  : .black)
                            Label(ShortName, systemImage: icon)
                                .font(.footnote)
                                .fontWeight(.medium)
                                .shadow(radius: 6)
                                .bold()
                                .foregroundColor(colorScheme == .dark ? .white  : .black)
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                    .foregroundColor( .black)
                    Spacer()
                    HStack {
                        Spacer()
                        Image(foreImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .if(isIpad) {
                                    $0.frame(height: 170)
                                }
                                .if(!isIpad) {
                                    $0.frame(height: 20)
                                }
                                .cornerRadius(14)
                                .shadow(radius: 12)
                                .grayscale(0.2)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                   
                }
                
            }
            .if(isIpad) {
                $0.frame(height: 300)
            }
            .if(!isIpad) {
                $0.frame(height: 150)
            }
           
            .shadow(color: .white, radius: 0.2)
        }
    }
}

#Preview {
    StatisticCards(ShortName: "Mets", LongName: "New York Mets", LeagueName: "Major League Baseball", foreImage: "play-of-the-week", icon: "")
}

