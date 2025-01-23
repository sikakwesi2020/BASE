//
//  SystemLang.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/9/25.
//

import Foundation

import SwiftUI

struct SystemLang: View {
    
    @Environment(\.dismiss) var dismiss
//    @Binding var SelectedLanguage: String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var appState: TeamsViewModel
    
    @State private var availablelanguage:[eachLanguage] = [
        eachLanguage(langname: "English (US)", langLocal: "English", code: "en"),
        eachLanguage(langname: "Japanese", langLocal: "日本語", code: "ja"),
        eachLanguage(langname: "Spanish", langLocal: "Español", code: "es"),
        eachLanguage(langname: "Arabic", langLocal: "عربي", code: "ar"),
        eachLanguage(langname: "Hebrew", langLocal: "עִברִית", code: "he")
    ]
    @State private var localeApp = ""
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color.black)
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image("mlb")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            
                            
                            Spacer()
                        }
                        
                        (Text("MLB  ").foregroundColor(.red) + Text("FOR ALL"))
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                        
                        Text("BASE ").bold().foregroundColor(.white) + Text("is currently available in 3 different languages: English, Japanese, Spanish, and you can change your language preference at any time")
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Image(systemName: "globe.americas")
                        .font(.system(size: 80, weight: .bold))
                        .opacity(0.2)
                        .padding()
                        .vAlign(.top)
                        .foregroundStyle(.white)
                        .hAlign(.trailing)
                      
                }
                .frame(height: 250)
                
                let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 2)
                GeometryReader { reader in
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 10, content: {
                        ForEach(availablelanguage, id: \.langname) {  lang in
                            HStack {
                                VStack(spacing: 5) {
                                    Text(lang.langname)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .bold()
                                        .fontWeight(.black)
                                       
                                    
                                    Text("( \(lang.langLocal) )")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                                .frame(width: (reader.size.width - 50) / 2, height: 70)
                                .background(
                                    Rectangle()
                                        .fill( lang.code == localeApp ? Color.blue.opacity(0.8) : Color.black.opacity(0.7))
                                        .frame(width: (reader.size.width - 50) / 2, height: 70)
                                        .shadow(radius: 3)
                                        .cornerRadius(10)
                                )
                            }
                            .onTapGesture {
                                localeApp = lang.code
                            }
                            
                        }
                    })
                    .padding()
                }
            }
          
            Button {
                let newLocale = Locale(identifier: localeApp)
                LocaleManager.shared.saveLocale(locale: newLocale)
                appState.restartApp()
                
                dismiss()
            } label: {
                Text("Continue")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(Color.black.gradient)
                    .cornerRadius(30)
            }
            .vAlign(.bottom)
            .padding()
        }
        .onAppear {
            localeApp = LocaleManager.shared.fetchLocale().identifier
            print(localeApp)
        }
        .onChange(of: localeApp) { _,val in
            localeApp = val
        }
    }
}

#Preview {
    SystemLang()
        .environmentObject(TeamsViewModel())
}
