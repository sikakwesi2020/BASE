//
//  ContentInteractions.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/16/25.
//

import SwiftUI

struct ContentInteractions: View {
    
    @ObservedObject var viewModel:FanContentViewModel
    @State private var showSheet = false
    @State private var showArticleSheet = false
    
    @State private var previewUrl: String = ""
    @State private var previewTitle: String = ""
    
    let columns = 1
    let type: String
    
    
    var body: some View {
        
        switch type {
            case "videos":
            ScrollView(.horizontal) {
                       LazyHStack(alignment: .top, spacing: 10) {
                           ForEach(0..<(viewModel.videoFiltered.count / columns + (viewModel.videoFiltered.count % columns == 0 ? 0 : 1)), id: \.self) { rowIndex in
                               VStack(spacing: 10) {
                                   ForEach(0..<columns) { columnIndex in
                                       let itemIndex = rowIndex * columns + columnIndex
                                       if itemIndex < viewModel.videoFiltered.count {
                                           let card = viewModel.videoFiltered.shuffled()[itemIndex]
                                           VStack {
                                               HStack {
                                                   Text("\(viewModel.extractName(from:card.contentHeadline) ?? "Video")")
                                                       .foregroundStyle(.white)
                                                       .bold()
                                                   Spacer()
                                                   Image(systemName: "chevron.right")
                                                       .foregroundStyle(.red)
                                               }
                                               .frame(height: 15)
                                             .padding(10)
                                               Divider()
                                                   .background(Color.white)
                                               
                                               HStack {
                                                   Text("\(card.contentHeadline)")
                                                       .foregroundStyle(.white)
                                                       .font(.headline)
                                                       .bold()
                                                   
                                                   Spacer()
                                               }
                                               .padding(.leading, 10)
                                               
                                               Spacer()
                                               HStack {
                                                   Image(systemName: "play.circle.fill")
                                                      
                                                   Image(systemName: "network")
                                                      
                                                   Spacer()
                                                   
                                                   Text("\(viewModel.formatDateString(card.dateTimeDate) ?? "")")
                                                       .font(.caption)
                                                       .foregroundStyle(.white)
                                               }
                                               .foregroundColor(.white)
                                               .font(.title2)
                                               .padding(10)
                                           }
                                          
                                           .frame(width: 300, height: 170, alignment: .leading)
                                           .background(
                                            ZStack {
                                                Image("mlbteams")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 300, height: 170)
                                                    
                                                    .clipped()
                                                    .cornerRadius(10)
                                                RoundedRectangle(cornerRadius: 10).fill(.thinMaterial)
                                                
                                            }
                                           )
                                           .onTapGesture {
                                               
                                               previewTitle = card.contentHeadline
                                               previewUrl = "https://www.mlb.com/\(card.contentType)/\(card.slug)"
                                               showSheet.toggle()
                                           }
                                       } else {
                                           Color.clear
                                               .frame(width: 100, height: 100)
                                       }
                                   }
                               }
                           }
                       }
                   }
            .sheet(isPresented: $showSheet) {
               
                FullScreenWebView(previewUrl: $previewUrl, title: $previewTitle)
              
              
            }
        default:
            ScrollView(.horizontal) {
                       LazyHStack(alignment: .top, spacing: 20) {
                           ForEach(0..<(viewModel.articleFiltered.count / columns + (viewModel.articleFiltered.count % columns == 0 ? 0 : 1)), id: \.self) { rowIndex in
                               VStack(spacing: 10) {
                                   ForEach(0..<columns) { columnIndex in
                                       let itemIndex = rowIndex * columns + columnIndex
                                       if itemIndex < viewModel.articleFiltered.count {
                                           let card = viewModel.articleFiltered.shuffled()[itemIndex]
                                           VStack {
                                               HStack {
                                                   Text("\(viewModel.extractName(from:card.contentHeadline) ?? "Article")")
                                                       .foregroundStyle(.black)
                                                       .bold()
                                                   Spacer()
                                                   Image(systemName: "chevron.right")
                                                       .foregroundStyle(.red)
                                               }
                                               .frame(height: 15)
                                             .padding(10)
                                               Divider()
                                                   .background(Color.white)
                                               
                                               HStack {
                                                   Text("\(card.contentHeadline)")
                                                       .foregroundStyle(.black)
                                                       .font(.headline)
                                                       .bold()
                                                   
                                                   Spacer()
                                               }
                                               .padding(.leading, 10)
                                               
                                               Spacer()
                                               HStack {
                                                   Image(systemName: "text.quote")
                                                      
                                                   Image(systemName: "network")
                                                      
                                                   Spacer()
                                                   
                                                   Text("\(viewModel.formatDateString(card.dateTimeDate) ?? "")")
                                                       .font(.caption)
                                                       .foregroundStyle(.black)
                                               }
                                               .foregroundColor(.black)
                                               .font(.title)
                                               .padding()
                                           }
                                          
                                           .frame(width: 300, height: 170, alignment: .leading)
                                           .background(
                                           
                                                RoundedRectangle(cornerRadius: 10).fill(.thinMaterial)
                                                    .shadow(radius: 3)
                                                
                                            
                                           )
                                           .onTapGesture {
                                               
                                               previewTitle = card.contentHeadline
                                               previewUrl = "https://www.mlb.com/news/\(card.slug)"
                                               showArticleSheet.toggle()
                                           }
                                       } else {
                                           Color.clear
                                               .frame(width: 100, height: 100)
                                       }
                                   }
                               }
                           }
                       }
                       .padding( 3)
                   }
            .sheet(isPresented: $showArticleSheet) {
                FullScreenWebView(previewUrl: $previewUrl, title: $previewTitle)
              
            }
        }
      

    }
}

#Preview {
    ContentInteractions(viewModel: FanContentViewModel(), type: "videos")
}
