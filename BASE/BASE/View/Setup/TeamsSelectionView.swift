//
//  TeamsSelectionView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/27/24.
//

import SwiftUI

struct TeamsSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:TeamsViewModel

    @State private var languageSelect = false
    @Binding var showCancel: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
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
                            
                            (Text("SETUP ").foregroundColor(.red) + Text("THE MLB EXPERIENCE"))
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .bold))
                            
                            Text("Setup favourites players and teams to unlock the full MLB experience")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    .frame(height: 170)
                    VStack(alignment: .leading, spacing: 16) {
                        if !viewModel.selectedFavourites.isEmpty {
                            Text("My Favourites")
                                .font(.system(size: 20, weight: .black))
                                .padding(.leading)
                                .padding(.leading)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.selectedFavourites) { team in
                                        VStack {
                                            Circle()
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 80, height: 80)
                                                .overlay(content: {
                                                    Image(team.teamName)
                                                        .resizable()
                                                })
                                            Text(team.teamName)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 100)
                                        
                                    }
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            VStack(alignment: .leading) {
                                Text("My Favourite")
                                    .font(.system(size: 20, weight: .black))
                                    .padding(.leading)
                                
                                ScrollView(.horizontal) {
                                    HStack {
                                        VStack {
                                            Circle()
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 80, height: 80)
                                            
                                        }
                                        .frame(width: 100)
                                        VStack {
                                            Circle()
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 80, height: 80)
                                        }
                                        .frame(width: 100)
                                        VStack {
                                            Circle()
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 80, height: 80)
                                            
                                        }
                                        .frame(width: 100)
                                        VStack {
                                            Circle()
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 80, height: 80)
                                        }
                                        .frame(width: 100)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Text("All Teams")
                            .font(.system(size: 20, weight: .black))
                            .padding(.leading)
                            .padding(.leading)
                        
                        
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                                ForEach(viewModel.teams) { team in
                                    VStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.07))
                                            .frame(width: 80, height: 80)
                                            .overlay(content: {
                                                Image(team.teamName)
                                                    .resizable()
                                            })
                                            .overlay(content: {
                                                
                                                if viewModel.selectedFavourites.firstIndex(where: {$0.id == team.id}) != nil {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .font(.title2)
                                                        .foregroundColor(.red)
                                                        .background(Circle().fill(Color.white))
                                                        .vAlign(.top)
                                                        .hAlign(.trailing)
                                                       
                                                }
                                                
                                            })
                                            
                                        Text(team.teamName)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 100)
                                    .onTapGesture(perform: {
                                        if let index = viewModel.selectedFavourites.firstIndex(where: {$0.id == team.id}) {
                                            viewModel.selectedFavourites.remove(at: index)
                                        } else {
                                            viewModel.selectedFavourites.append(team)
                                        }
                                        
                                    })
                                }
                            }
                            .padding(.horizontal)
                        }
                    
                }
                
                
                
                VStack {
                    GeometryReader { proxy in
                        NavigationLink(destination: FavouritePlayers(viewModel: viewModel, dismissHome: dismiss), label: {
                            Text("Next")
                                .bold()
                                .padding(.trailing)
                        })
                        .frame(width: proxy.size.width, alignment: .trailing)
                        .disabled(viewModel.selectedFavourites.isEmpty)
                    }
                    .frame(height: 10)
                    
                }
                .frame(height: 40)
                .background(
                    Rectangle()
                        .fill(.thinMaterial)
                        .ignoresSafeArea()
                )
                .vAlign(.bottom)
            }
            .if(showCancel) {
                $0.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button("Done") {
                            dismiss()
                        }.bold()
                    })
                }
            }
        }
        .onAppear {
            if UserDefaults.standard.string(forKey: "userLocale") == nil{
                languageSelect = true
            }
        }
        .fullScreenCover(isPresented: $languageSelect){
            SystemLang()
                .environmentObject(LocalState())
                .interactiveDismissDisabled()
        }
       
    }
}

#Preview {
    TeamsSelectionView(showCancel: .constant(true))
        .environmentObject(TeamsViewModel())
}
