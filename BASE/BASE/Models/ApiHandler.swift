//
//  ApiHandler.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/25/25.
//

import Foundation
import Alamofire

// Define the structure to decode the JSON
struct APIData: Decodable {
    let yt: String
    let gemini: String
}

class ApiHandler {
    
    
    
    func fetchAPIData(completion: @escaping (APIData) -> Void) {
        // URL of the JSON file
        let url = "https://firebasestorage.googleapis.com/v0/b/classcap.appspot.com/o/MlbData%2Fmlbapis?alt=media&token=3119b117-5cd0-4f28-b6a3-01aae824169e"
        
        // Perform the Alamofire request
        AF.request(url).responseDecodable(of: [APIData].self) { response in
            switch response.result {
            case .success(let data):
                completion(data.first ?? APIData(yt: "", gemini: ""))
            case .failure(_):
                completion(APIData(yt: "", gemini: ""))
                
            }
        }
    }
    
}

// Call the function to fetch data

