//
//  FanContentViewModel.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/16/25.
//

import Foundation
import SwiftUI
import Alamofire

class FanContentViewModel: ObservableObject {
    @Published var fanContents: [FanContentInteraction] = []
    @Published var errorMessage: String?
    
    
    var videoFiltered: [FanContentInteraction] {
        var seenHeadlines = Set<String>()
        return fanContents.filter { interaction in
            interaction.contentType == "video" && seenHeadlines.insert(interaction.contentHeadline).inserted
        }
    }
    
    var articleFiltered: [FanContentInteraction] {
        var seenHeadlines = Set<String>()
        return fanContents.filter { interaction in
            interaction.contentType == "article" && seenHeadlines.insert(interaction.contentHeadline).inserted
        }
    }
    
    func fetchFanContent() {
        let url = "https://firebasestorage.googleapis.com/v0/b/classcap.appspot.com/o/MlbData%2Fvalid_mlb_fan_content_combined.json?alt=media&token=ada12e9b-69d6-4391-bf34-15f24b857531"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: [FanContentInteraction].self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.fanContents = data
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error)
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
    }
    
  

    func formatDateString(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd" // Input format
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil // Return nil if the input string is invalid
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd" // Desired output format
        
        return outputFormatter.string(from: date)
    }
    
    func extractName(from sentence: String) -> String? {
        let words = sentence.split(separator: " ")
        var nameParts: [String] = []
        
        for word in words {
            if let firstChar = word.first, firstChar.isUppercase {
                nameParts.append(String(word))
            }
        }
        
        return nameParts.isEmpty ? nil : nameParts.joined(separator: " ")
    }
}
