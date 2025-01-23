//
//  TranslatorApi.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/16/25.
//

import Translation
import Foundation
import Alamofire

import SwiftUI
import Translation

//@MainActor
class TranslationViewModel: ObservableObject {
    @Published var captions: [Caption] = []
    @Published var translatedCaptions: [Caption] = []
    
    @Published var languageOptions: [LanguageOption] = [
        // Most used languages
        LanguageOption(name: "English", code: "en"),
        LanguageOption(name: "Chinese", code: "zh"),
        LanguageOption(name: "Japanese", code: "ja"),
        LanguageOption(name: "Spanish", code: "es"),
        LanguageOption(name: "Korean", code: "ko"),
        
        // Other languages
        LanguageOption(name: "Abkhaz", code: "ab"),
        LanguageOption(name: "Acehnese", code: "ace"),
        LanguageOption(name: "Acholi", code: "ach"),
        LanguageOption(name: "Afrikaans", code: "af"),
        LanguageOption(name: "Albanian", code: "sq"),
        LanguageOption(name: "Alur", code: "alz"),
        LanguageOption(name: "Amharic", code: "am"),
        LanguageOption(name: "Arabic", code: "ar"),
        LanguageOption(name: "Armenian", code: "hy"),
        LanguageOption(name: "Assamese", code: "as"),
        LanguageOption(name: "Awadhi", code: "awa"),
        LanguageOption(name: "Aymara", code: "ay"),
        LanguageOption(name: "Azerbaijani", code: "az"),
        LanguageOption(name: "Balinese", code: "ban"),
        LanguageOption(name: "Bambara", code: "bm"),
        LanguageOption(name: "Bashkir", code: "ba"),
        LanguageOption(name: "Basque", code: "eu"),
        LanguageOption(name: "Batak Karo", code: "btx"),
        LanguageOption(name: "Batak Simalungun", code: "bts"),
        LanguageOption(name: "Batak Toba", code: "bbc"),
        LanguageOption(name: "Belarusian", code: "be"),
        LanguageOption(name: "Bemba", code: "bem"),
        LanguageOption(name: "Bengali", code: "bn"),
        LanguageOption(name: "Betawi", code: "bew"),
        LanguageOption(name: "Bhojpuri", code: "bho"),
        LanguageOption(name: "Bikol", code: "bik"),
        LanguageOption(name: "Bosnian", code: "bs"),
        LanguageOption(name: "Breton", code: "br"),
        LanguageOption(name: "Bulgarian", code: "bg"),
        LanguageOption(name: "Buryat", code: "bua"),
        LanguageOption(name: "Cantonese", code: "yue"),
        LanguageOption(name: "Catalan", code: "ca"),
        LanguageOption(name: "Cebuano", code: "ceb"),
        LanguageOption(name: "Chichewa (Nyanja)", code: "ny"),
        LanguageOption(name: "Chinese (Simplified)", code: "zh-CN"),
        LanguageOption(name: "Chinese (Traditional)", code: "zh-TW"),
        LanguageOption(name: "Chuvash", code: "cv"),
        LanguageOption(name: "Corsican", code: "co"),
        LanguageOption(name: "Crimean Tatar", code: "crh"),
        LanguageOption(name: "Croatian", code: "hr"),
        LanguageOption(name: "Czech", code: "cs"),
        LanguageOption(name: "Danish", code: "da"),
        LanguageOption(name: "Dinka", code: "din"),
        LanguageOption(name: "Divehi", code: "dv"),
        LanguageOption(name: "Dogri", code: "doi"),
        LanguageOption(name: "Dombe", code: "dov"),
        LanguageOption(name: "Dutch", code: "nl"),
        LanguageOption(name: "Dzongkha", code: "dz"),
        LanguageOption(name: "Esperanto", code: "eo"),
        LanguageOption(name: "Estonian", code: "et"),
        LanguageOption(name: "Ewe", code: "ee"),
        LanguageOption(name: "Fijian", code: "fj"),
        LanguageOption(name: "Filipino (Tagalog)", code: "fil"),
        LanguageOption(name: "Finnish", code: "fi"),
        LanguageOption(name: "French", code: "fr"),
        LanguageOption(name: "French (French)", code: "fr-FR"),
        LanguageOption(name: "French (Canadian)", code: "fr-CA"),
        LanguageOption(name: "Frisian", code: "fy"),
        LanguageOption(name: "Fulfulde", code: "ff"),
        LanguageOption(name: "Ga", code: "gaa"),
        LanguageOption(name: "Galician", code: "gl"),
        LanguageOption(name: "Ganda (Luganda)", code: "lg"),
        LanguageOption(name: "Georgian", code: "ka"),
        LanguageOption(name: "German", code: "de"),
        LanguageOption(name: "Greek", code: "el"),
        LanguageOption(name: "Guarani", code: "gn"),
        LanguageOption(name: "Gujarati", code: "gu"),
        LanguageOption(name: "Haitian Creole", code: "ht"),
        LanguageOption(name: "Hakha Chin", code: "cnh"),
        LanguageOption(name: "Hausa", code: "ha"),
        LanguageOption(name: "Hawaiian", code: "haw"),
        LanguageOption(name: "Hebrew", code: "iw"),
        LanguageOption(name: "Hiligaynon", code: "hil"),
        LanguageOption(name: "Hindi", code: "hi"),
        LanguageOption(name: "Hmong", code: "hmn"),
        LanguageOption(name: "Hungarian", code: "hu"),
        LanguageOption(name: "Icelandic", code: "is"),
        LanguageOption(name: "Igbo", code: "ig"),
        LanguageOption(name: "Iloko", code: "ilo"),
        LanguageOption(name: "Indonesian", code: "id"),
        LanguageOption(name: "Irish", code: "ga"),
        LanguageOption(name: "Italian", code: "it"),
        LanguageOption(name: "Japanese", code: "ja"),
        LanguageOption(name: "Javanese", code: "jw"),
        LanguageOption(name: "Kannada", code: "kn"),
        LanguageOption(name: "Kapampangan", code: "pam"),
        LanguageOption(name: "Kazakh", code: "kk"),
        LanguageOption(name: "Khmer", code: "km"),
        LanguageOption(name: "Kiga", code: "cgg"),
        LanguageOption(name: "Kinyarwanda", code: "rw"),
        LanguageOption(name: "Kituba", code: "ktu"),
        LanguageOption(name: "Konkani", code: "gom"),
        LanguageOption(name: "Korean", code: "ko"),
        LanguageOption(name: "Krio", code: "kri"),
        LanguageOption(name: "Kurdish (Kurmanji)", code: "ku"),
        LanguageOption(name: "Kurdish (Sorani)", code: "ckb"),
        LanguageOption(name: "Kyrgyz", code: "ky"),
        LanguageOption(name: "Lao", code: "lo"),
        LanguageOption(name: "Latgalian", code: "ltg"),
        LanguageOption(name: "Latin", code: "la"),
        LanguageOption(name: "Latvian", code: "lv"),
        LanguageOption(name: "Ligurian", code: "lij"),
        LanguageOption(name: "Limburgan", code: "li"),
        LanguageOption(name: "Lingala", code: "ln"),
        LanguageOption(name: "Lithuanian", code: "lt"),
        LanguageOption(name: "Lombard", code: "lmo"),
        LanguageOption(name: "Luo", code: "luo"),
        LanguageOption(name: "Luxembourgish", code: "lb"),
        LanguageOption(name: "Macedonian", code: "mk"),
        LanguageOption(name: "Maithili", code: "mai"),
        LanguageOption(name: "Makassar", code: "mak"),
        LanguageOption(name: "Malagasy", code: "mg"),
        LanguageOption(name: "Malay", code: "ms"),
        LanguageOption(name: "Malay (Jawi)", code: "ms-Arab"),
        LanguageOption(name: "Malayalam", code: "ml"),
        LanguageOption(name: "Maltese", code: "mt"),
        LanguageOption(name: "Maori", code: "mi"),
        LanguageOption(name: "Marathi", code: "mr"),
        LanguageOption(name: "Meadow Mari", code: "chm"),
        LanguageOption(name: "Meiteilon (Manipuri)", code: "mni-Mtei"),
        LanguageOption(name: "Minang", code: "min"),
        LanguageOption(name: "Mizo", code: "lus"),
        LanguageOption(name: "Mongolian", code: "mn"),
        LanguageOption(name: "Myanmar (Burmese)", code: "my"),
        LanguageOption(name: "Ndebele (South)", code: "nr"),
        LanguageOption(name: "Nepalbhasa (Newari)", code: "new"),
        LanguageOption(name: "Nepali", code: "ne"),
        LanguageOption(name: "Northern Sotho (Sepedi)", code: "nso"),
        LanguageOption(name: "Norwegian", code: "no"),
        LanguageOption(name: "Nuer", code: "nus"),
        LanguageOption(name: "Occitan", code: "oc"),
        LanguageOption(name: "Odia (Oriya)", code: "or"),
        LanguageOption(name: "Oromo", code: "om"),
        LanguageOption(name: "Pangasinan", code: "pag"),
        LanguageOption(name: "Papiamento", code: "pap"),
        LanguageOption(name: "Pashto", code: "ps"),
        LanguageOption(name: "Persian", code: "fa"),
        LanguageOption(name: "Polish", code: "pl"),
        LanguageOption(name: "Portuguese", code: "pt"),
        LanguageOption(name: "Portuguese (Portugal)", code: "pt-PT"),
        LanguageOption(name: "Portuguese (Brazil)", code: "pt-BR"),
        LanguageOption(name: "Punjabi", code: "pa"),
        LanguageOption(name: "Punjabi (Shahmukhi)", code: "pa-Arab"),
        LanguageOption(name: "Quechua", code: "qu"),
        LanguageOption(name: "Romani", code: "rom"),
        LanguageOption(name: "Romanian", code: "ro"),
        LanguageOption(name: "Rundi", code: "rn"),
        LanguageOption(name: "Russian", code: "ru"),
        LanguageOption(name: "Samoan", code: "sm"),
        LanguageOption(name: "Sango", code: "sg"),
        LanguageOption(name: "Sanskrit", code: "sa"),
        LanguageOption(name: "Scots Gaelic", code: "gd"),
        LanguageOption(name: "Serbian", code: "sr"),
        LanguageOption(name: "Sesotho", code: "st"),
        LanguageOption(name: "Seychellois Creole", code: "crs"),
        LanguageOption(name: "Shan", code: "shn"),
        LanguageOption(name: "Shona", code: "sn"),
        LanguageOption(name: "Sicilian", code: "scn"),
        LanguageOption(name: "Silesian", code: "szl"),
        LanguageOption(name: "Sindhi", code: "sd"),
        LanguageOption(name: "Sinhala (Sinhalese)", code: "si"),
        LanguageOption(name: "Slovak", code: "sk"),
        LanguageOption(name: "Slovenian", code: "sl"),
        LanguageOption(name: "Somali", code: "so"),
        LanguageOption(name: "Spanish", code: "es"),
        LanguageOption(name: "Sundanese", code: "su"),
        LanguageOption(name: "Swahili", code: "sw"),
        LanguageOption(name: "Swati", code: "ss"),
        LanguageOption(name: "Swedish", code: "sv"),
        LanguageOption(name: "Tajik", code: "tg"),
        LanguageOption(name: "Tamil", code: "ta"),
        LanguageOption(name: "Tatar", code: "tt"),
        LanguageOption(name: "Telugu", code: "te"),
        LanguageOption(name: "Tetum", code: "tet"),
        LanguageOption(name: "Thai", code: "th"),
        LanguageOption(name: "Tigrinya", code: "ti"),
        LanguageOption(name: "Tsonga", code: "ts"),
        LanguageOption(name: "Tswana", code: "tn"),
        LanguageOption(name: "Turkish", code: "tr"),
        LanguageOption(name: "Turkmen", code: "tk"),
        LanguageOption(name: "Twi (Akan)", code: "ak"),
        LanguageOption(name: "Ukrainian", code: "uk"),
        LanguageOption(name: "Urdu", code: "ur"),
        LanguageOption(name: "Uyghur", code: "ug"),
        LanguageOption(name: "Uzbek", code: "uz"),
        LanguageOption(name: "Vietnamese", code: "vi"),
        LanguageOption(name: "Welsh", code: "cy"),
        LanguageOption(name: "Xhosa", code: "xh"),
        LanguageOption(name: "Yiddish", code: "yi"),
        LanguageOption(name: "Yoruba", code: "yo"),
        LanguageOption(name: "Yucatec Maya", code: "yua"),
        LanguageOption(name: "Zulu", code: "zu")
    ]
    
    
    func reset() {
        translatedCaptions = captions
    }

    // Function to translate all captions at once using TranslationSession
    func translateAllAtOnce(lang: String) async {
        let requests: [TranslationSession.Request] = captions.map {
            TranslationSession.Request(sourceText: $0.text)
        }
        
        await performCloudTranslation(for: requests, lang: lang)

    }
    
    func translateSingle(lang:String) {
        
    }
    
    func performCloudTranslation(for requests: [TranslationSession.Request], lang: String) async {
          // Create a TaskGroup for async tasks
          await withTaskGroup(of: Void.self) { group in
              for (index, request) in requests.enumerated() {
                  group.addTask {
                      // Translate the caption using Google API
                      await self.translateCaption(index: index, text: request.sourceText, langcode: lang)
                  }
              }
          }
      }
    
    
     func SingletranslateCaption(text: String, langcode: String) async -> String {
        let url = "https://translation.googleapis.com/language/translate/v2"
        //print("langcode is \(langcode)")
        let parameters: [String: Any] = [
            "q": text,
            "target": langcode,
            "key": "AIzaSyA2eOnBMVpGLu0vZtYYZNliVIMdPqIf5ys"
        ]

        // Perform the translation request using Alamofire
        do {
            let response = try await AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .serializingDecodable(GoogleTranslationResponse.self).value

           return response.data.translations.first?.translatedText ?? ""

        } catch {
            print("Failed to translate caption: \(error.localizedDescription)")
            return ""
        
        }
    }
    
    private func translateCaption(index: Int, text: String, langcode: String) async {
        let url = "https://translation.googleapis.com/language/translate/v2"
        //print("langcode is \(langcode)")
        let parameters: [String: Any] = [
            "q": text,
            "target": langcode,
            "key": "AIzaSyA2eOnBMVpGLu0vZtYYZNliVIMdPqIf5ys"
        ]

        // Perform the translation request using Alamofire
        do {
            let response = try await AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .serializingDecodable(GoogleTranslationResponse.self).value

            // Update the caption with the translated text on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.translatedCaptions[index].text = response.data.translations.first?.translatedText ?? ""
               // print("updated is \(self?.captions[index].text ?? "")")
            }

        } catch {
            print("Failed to translate caption: \(error.localizedDescription)")
        }
    }
    
//    func performCloudTranslation(for requests: [TranslationSession.Request]) async {
//           let group = DispatchGroup()
//
//           for (index, request) in requests.enumerated() {
//               group.enter()
//
//               let url = "https://translation.googleapis.com/language/translate/v2"
//               let parameters: [String: Any] = [
//                   "q": request.sourceText,
//                   "target": "fr", // target language (can be dynamically set)
//                   "key": "AIzaSyA2eOnBMVpGLu0vZtYYZNliVIMdPqIf5ys"
//               ]
//
//               print("ready to run translation")
//               // Make an Alamofire request to Google Translate API
//               AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
//                   .validate()
//                   .responseDecodable(of: GoogleTranslationResponse.self) { response in
//                       switch response.result {
//                       case .success(let data):
//                           // Update the caption with the translated text
//                        
//                           DispatchQueue.main.async {
//                               captions[index].text = data.data.translations.first?.translatedText ?? ""
//                           }
//                       case .failure(let error):
//                           print("Failed to translate caption: \(error.localizedDescription)")
//                       }
//                       group.leave()
//                   }
//           }
//
//           group.wait() // Wait until all translations are done
//       }
}
