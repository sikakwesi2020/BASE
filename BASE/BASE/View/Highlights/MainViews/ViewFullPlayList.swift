//
//  ViewFullPlayList.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/14/25.
//

import SwiftUI
import YouTubePlayerKit
import SDWebImageSwiftUI
import Alamofire
import Translation


struct ViewFullPlayList: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:TeamsViewModel
    @ObservedObject var helper:HighlightHelper
    @StateObject private var transVM = TranslationViewModel()
    
    @State var youTubePlayer: YouTubePlayer = ""
    @State var uuid : UUID = UUID()
    @State private var isCaptionsEnabled: Bool = false
    @State private var activePlay: PlaylistItem? = nil
    

    @State private var errorMessage: String = ""
    @State private var activePlaycurrentTime: Double = 0.0
    @State private var currentCaption: String = ""
    @State private var selectedLanguage: String = "en"

    @State private var loadLangs: Bool = false
    
    // Define a configuration for the translation session
     @State private var configuration: TranslationSession.Configuration?

    
    var body: some View {
        
            if let playList = helper.activePlayList {
                
                
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.black).ignoresSafeArea()
                        VStack {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Text("Done")
                                        .bold()
                                        .foregroundColor(.red)
                                }
                                Spacer()
                            }.padding(.leading)
                            //YouTubePlayerView(youTubePlayer: youTubePlayer)
                            YouTubePlayerHelper(videoID: activePlay?.snippet.resourceId.videoId ?? "", currentTime: $activePlaycurrentTime)
                                .frame(height: 300)
                                .id(uuid)
                            
                        }
                    }
                    .frame(height: 350)
                    
                    if let activeVideo = activePlay {
                        VStack {
                            HStack {
                                Text("\(activeVideo.snippet.title)")
                                    .bold()
                                Spacer()
                            }
                            HStack {
                                Text("\(helper.timeAgo(from: activeVideo.snippet.publishedAt) ?? "")")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                               
                                Button {
                                    if !isCaptionsEnabled {
                                        isCaptionsEnabled.toggle()
                                        fetchCaptions(videoID: activeVideo.snippet.resourceId.videoId)
                                        
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "mic.fill")
                                        Image(systemName: "translate")
                                    }
                                    .bold()
                                    .padding(5)
                                    .padding(.horizontal, 5)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(20)
                                }
                            }
                            .padding(10)
                        }
                        .padding(.leading, 5)
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(playList.items, id: \.id) { item in
                                HStack {
                                    WebImage(url: URL(string: "\(item.snippet.thumbnails.medium.url)")) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Rectangle().foregroundColor(.gray)
                                    }
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFit()
                                    .frame(width: 150)
                                    .cornerRadius(10)
                                    
                                    VStack {
                                        Text("\(item.snippet.title)")
                                            .font(.caption)
                                            .bold()
                                        Spacer()
                                    }
                                    
                                    
                                    Spacer()
                                }
                                
                                .if(item.snippet.resourceId.videoId == activePlay?.snippet.resourceId.videoId ?? "") {
                                    $0.padding(5)
                                        .background (
                                            Rectangle()
                                                .fill(.thinMaterial)
                                        )
                                }
                                .onTapGesture {
                                    youTubePlayer = YouTubePlayer(stringLiteral: "https://youtube.com/watch?v=\(item.snippet.resourceId.videoId)")
                                    activePlay = item
                                    uuid = UUID()
                                    
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    .if(isCaptionsEnabled) {
                        $0.overlay(content: {
                            ZStack {
                                Rectangle()
                                    .fill(.thinMaterial).ignoresSafeArea()
                                
                                VStack {
                                    Spacer()
                                    if !transVM.translatedCaptions.isEmpty {
                                    Text(currentCaption)
                                                   .font(.title)
                                                   .multilineTextAlignment(.center)
                                                   .bold()
                                                   .foregroundColor(.red)
                                                   .padding()
                                                   
                                    } else {
                                        ProgressView()
                                    }
                                    Spacer()
                                    
                                    HStack {
                                        Button {
                                            loadLangs = true
                                        } label: {
                                            Image(systemName: "translate")
                                                .foregroundColor(.white)
                                                .font(.body)
                                            
                                            if let language = transVM.languageOptions.first(where: { $0.code == selectedLanguage }) {
                                                Text(language.name)
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                            }
                                            
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.white)
                                                .bold()
                                               
                                               
                                        }
                                        .padding(10)
                                        .padding(.horizontal, 10)
                                        .background(Color.black)
                                        .cornerRadius(40)
                                        .padding()
                                        .sheet(isPresented: $loadLangs, content: {
                                            // Most Used Languages
                                            List {
                                                Section(header: Text("Most Used")) {
                                                    ForEach(["en", "zh", "ja", "es", "ko"], id: \.self) { languageCode in
                                                        if let language = transVM.languageOptions.first(where: { $0.code == languageCode }) {
                                                            Button {
                                                                if configuration != nil {
                                                                    configuration?.invalidate()
                                                                    print("invalidated")
                                                                }
                                                                //                                                                        //transVM.translatedCaptions.removeAll()
                                                                //
                                                                selectedLanguage = language.code
                                                                triggerTranslation(to: language.code)
                                                                loadLangs = false
                                                            } label: {
                                                                Label("\(language.name)", systemImage: "list.bullet")
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                
                                                Section(header: Text("Other Languages")) {
                                                    ForEach(transVM.languageOptions, id: \.code) { language in
                                                        Button {
                                                            if configuration != nil {
                                                                configuration?.invalidate()
                                                                print("invalidated")
                                                            }
                                                            //                                                                        //transVM.translatedCaptions.removeAll()
                                                            //
                                                            selectedLanguage = language.code
                                                            triggerTranslation(to: language.code)
                                                            loadLangs = false
                                                        } label: {
                                                            Label(language.name, systemImage: "list.bullet")
                                                        }
                                                    }
                                                }
                                            }
                                            .presentationDetents([.medium, .large])
                                        })
                                        
                                        // Audio Play
                                        
                                        Button {
                                            isCaptionsEnabled = false
                                            configuration?.invalidate()
                                            
                                            transVM.translatedCaptions.removeAll()
                                        } label: {
                                            Image(systemName: "multiply")
                                                .foregroundColor(.white)
                                                .font(.body)
                                            
                                         
                                                Text("Close")
                                                .bold()
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                            
                                        }
                                        .padding(10)
                                        .padding(.horizontal, 10)
                                        .background(Color.black)
                                        .cornerRadius(40)
                                        .padding()
                                    }
                                }
                            }
                            .onChange(of: activePlaycurrentTime) { _,time in
                                //print(time)
                                updateCaption(for: time)
                            }
                            .translationTask(configuration) { _ in
                                // Use the session to translate all captions in batch
                               
                                await transVM.translateAllAtOnce(lang: selectedLanguage)
                            }
                            .onAppear {
                                transVM.reset()
                            }
                        })
                    }
                   
                }
                
                .onAppear {
                    activePlay =  helper.activePlayList?.items.first!
                    if let videoId = helper.activePlayList?.items.first?.snippet.resourceId.videoId {
                        youTubePlayer = YouTubePlayer(stringLiteral: "https://youtube.com/watch?v=\(videoId)")
                        uuid = UUID()
                    }
                }
            } else {
                ProgressView()
                    .onAppear {
                        helper.apiKey = viewModel.YtApi
                        helper.runAndCompute()
                    }
            }
        }
    
 
    func updateCaption(for time: Double) {
          // Find the current caption based on the playback time
        if let activeCaption = transVM.translatedCaptions.first(where: { time >= $0.start && time < $0.start + $0.duration }) {
              currentCaption = activeCaption.text
          } else {
              currentCaption = ""
          }
      }
    func fetchCaptions(videoID: String) {
//        let url = "https://us-central1-classcap.cloudfunctions.net/MLBCaptionFetch?video_id=\(videoID)"
       
//        http://192.168.1.91:5000/get_captions?
        
        let Ip = Bundle.main.object(forInfoDictionaryKey: "IPAddress") as? String ?? ""
        let url = "http://\(Ip)/get_captions?video_id=\(videoID)"
        

        print("ip is \(Ip)")
        AF.request(url).responseDecodable(of: TranscriptResponse.self) { response in
            switch response.result {
            case .success(let data):
                transVM.captions = data.captions
                transVM.translatedCaptions = data.captions
                //print("returened captions: \(data.captions)")
            case .failure(let error):
                errorMessage = "Failed to fetch captions: \(error.localizedDescription)"
            }
        }
    }
    
    private func triggerTranslation(to targetLanguage: String) {
         if configuration == nil {
             // Set the language pairing
             configuration = TranslationSession.Configuration(
                 source: Locale.Language(identifier: "en"),
                 target: Locale.Language(identifier: targetLanguage)
             )
            // print("tranlatoins triggered to \(targetLanguage)")
         } else {
             // Invalidate the previous configuration to start a new session
             configuration?.invalidate()
         }
     }

    
    func getLanguageName(from code: String) -> String? {
        let locale = Locale(identifier: "en") // English as the base language for names
        return locale.localizedString(forLanguageCode: code)
    }

 
    
}

#Preview {
    ViewFullPlayList(helper: HighlightHelper())
        .environmentObject(TeamsViewModel())
}
