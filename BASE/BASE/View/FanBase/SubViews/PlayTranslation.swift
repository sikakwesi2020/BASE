//
//  PlayTranslation.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/16/25.
//

import SwiftUI
import SwiftUI
import Translation



struct PlayTranslation: View {
    
    @ObservedObject var transVM:TranslationViewModel
    /// Source text for translation
    let sourceText:String

    /// Source language for translation
    var sourceLanguage: Locale.Language?

    /// Target language for translation
    var targetLanguage: Locale.Language

    /// Translated text
    @State
    private var targetText: String?

    @State
      private var configuration: TranslationSession.Configuration?

   
    
    
    var body: some View {
       
        (Text("#Play ").bold() +  Text(targetText ?? sourceText))
            .onAppear {
                Task {
                    if targetLanguage != .init(identifier: "en") {
                     
                        let response = await transVM.SingletranslateCaption(text: sourceText, langcode:  targetLanguage.minimalIdentifier)
                        
                        targetText = response
                    }
                }
//                guard configuration == nil else {
//                    configuration?.invalidate()
//                    return
//                }
//                
//                // Create a new translation session configuration
//                configuration = TranslationSession.Configuration(
//                    source: sourceLanguage,
//                    target: targetLanguage
//                )
            }
            .translationTask(configuration) { session in
                Task { @MainActor in
                    do {
                        // Perform translation
                        let response = try await session.translate(sourceText)
                        
                        // Update target text
                        targetText = response.targetText
                    } catch {
                        // code to handle error
                    }
                }
            }
//            .translationTask(
//                source: sourceLanguage,
//                target: targetLanguage
//            ) { session in
//                Task { //@MainActor in
////                    if targetLanguage != .init(identifier: "en") {
////                        do {
////                         
////                            let response = try await session.translate(sourceText)
////                            
////                            // Update target text
////                            targetText = response.targetText
////                        } catch {
////                            // code to handle error
////                        }
////                    }
//                    
//                    guard configuration == nil else {
//                        configuration?.invalidate()
//                        return
//                    }
//                    
//                    // Create a new translation session configuration
//                    configuration = TranslationSession.Configuration(
//                        source: sourceLanguage,
//                        target: targetLanguage
//                    )
//                    
//                    await performTranslation()
//                }
//            }
    }
    /// Translation logic
//    private func performTranslation() async {
//        if targetLanguage != .init(identifier: "en") {
//            do {
//                
//                // Create a new TranslationSession for each task execution
//               // let session = Translation.Session(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
//                let response = try await con.translate(sourceText)
//                await MainActor.run {
//                    targetText = response.targetText
//                }
//            } catch {
//                await MainActor.run {
//                    targetText = "Error: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
}



#Preview {
    PlayTranslation(transVM: TranslationViewModel(), sourceText: "", targetLanguage: .init(identifier: "fr"))
}
