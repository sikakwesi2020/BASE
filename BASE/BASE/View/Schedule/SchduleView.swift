//
//  SchduleView.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 12/28/24.
//

import SwiftUI

struct SchduleView: View {
    @EnvironmentObject var viewModel:TeamsViewModel
    
    @State private var currentDay: Date? = .init()
    @State private var selectdDaytDay: Date = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.black).ignoresSafeArea()
                    VStack {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .overlay {
                                    DatePicker("", selection: $selectdDaytDay,displayedComponents: [.date])
                                        .blendMode(.destinationOver)
                                }
                                .onChange(of: selectdDaytDay){ _,data in
                                    currentDay = data
                                    viewModel.filterGames(for: currentDay!)
                                }
                          
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 5)
                        .background(Color.black.gradient)
                        .cornerRadius(5)
                        .hAlign(.trailing)
                        .padding(.trailing)
                        .padding(.top)
                        HStack {
                            Image("mlb")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                            (Text("2024 ").foregroundStyle(.red) + Text("PostSeason"))
                                .font(.title)
                                .foregroundStyle(.white)
                                .fontWeight(.black)
                            Spacer()
                        }
                        .padding(.leading)
                        HeaderView()
                    }
                }
                .frame(height: 170)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack {
                    ForEach(viewModel.filteredGames, id: \.gamePk) { game in
                        ScheduleCard(game: game)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .onTapGesture {
                                viewModel.openSingleGameData = game
                                viewModel.openSingleGame = true
                            }
                    }
                }
                .padding(15)
                .navigationDestination(isPresented: $viewModel.openSingleGame, destination: {SingleGameView()})
            }

            
            .onAppear {
              //  viewModel.loadSchedules()
            }
        }
    }
    
    /// - Header View
    @ViewBuilder
    func HeaderView()->some View {
        VStack{
            
            HStack{
              
//                VStack(alignment: .leading, spacing: 6) {
//                    Button{
//                        //filterSheet.toggle()
//                    } label: {
//                        Image("season")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 140, height: 60, alignment: .leading)
//                    }
//                    .foregroundColor(.white)
//                }
//                .hAlign(.leading)
                
                
//                HStack {
//                    Image(systemName: "calendar")
//                        .font(.title2)
//                        .overlay {
//                            DatePicker("", selection: $selectdDaytDay,displayedComponents: [.date])
//                                .blendMode(.destinationOver)
//                        }
//                        .onChange(of: selectdDaytDay){ _,data in
//                            currentDay = data
//                            viewModel.filterGames(for: currentDay!)
//                        }
//                  
//                }
//                .foregroundColor(.white)
//                .padding(.vertical, 3)
//                .padding(.horizontal, 5)
//                .background(Color.black.gradient)
//                .cornerRadius(5)
//                .hAlign(.trailing)
                
            }
            
            // - Current Week Row
            //            ScrollView(.horizontal, showsIndicators: false) {
            WeekRow()
            
            //            }
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                //Color.white
                
                /// - Gradient Opacity Background
//                Rectangle()
//                    .fill(.thinMaterial)
//                    .frame(height: 20)
            }
            .ignoresSafeArea()
        }
    }
    
    /// - Week Row
    @ViewBuilder
    func WeekRow()->some View { 
        
        HStack(spacing: 0) {
         
            ForEach(Calendar.current.currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay!)
                VStack(spacing: 6){
                    Text(weekDay.string.prefix(3))
                        .font(.system(size: 12, weight: .medium))
                    Text(weekDay.date.toString("dd"))
                        .font(.system(size: 12, weight: .medium))
                }
                .overlay(alignment: .bottom, content: {
                    if weekDay.isToday {
                        Circle()
                            .frame(width: 6, height: 6)
                            .offset(y: 12)
                    }
                })
                .foregroundColor(status ? Color(.red) : .white)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)){
                      
                        currentDay = weekDay.date
                        selectdDaytDay = weekDay.date
                        
                        viewModel.filterGames(for: selectdDaytDay)
                    }
                }
            }
        }
        .padding(.vertical,10)
        .padding(.horizontal,-15)
      
    }
    
    
}

#Preview {
    ContentView()
     
//    SchduleView()
        .environmentObject(TeamsViewModel())
}
