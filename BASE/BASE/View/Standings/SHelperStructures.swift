//
//  HelperStructures.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/16/25.
//

import Foundation

// MARK: - AI Response Models
struct GenerateContentResponse: Decodable {
    let candidates: [CandidateResponse]
    let promptFeedback: String?
    let usageMetadata: UsageMetadata?
}

struct CandidateResponse: Decodable {
    let content: ModelContent
    let safetyRatings: [String]
    let finishReason: String?
    let citationMetadata: String?
}

struct ModelContent: Decodable {
    let role: String?
    let parts: [Part]
    
    struct Part: Decodable {
        let text: String
    }
}

struct UsageMetadata: Decodable {
    let promptTokenCount: Int
    let candidatesTokenCount: Int
    let totalTokenCount: Int
}
