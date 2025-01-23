//
//  CaptionStructures.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/15/25.
//

import Foundation

// Root response
struct YouTubeCaptionsResponse: Decodable {
    let items: [CaptionItem]
}

// Caption item
struct CaptionItem: Decodable {
    let id: String
    let snippet: CaptionSnippet
}

// Caption snippet
struct CaptionSnippet: Decodable {
    let language: String
    let name: String?
    let videoId: String
}


struct DecodedCaption: Decodable {
    let language: String
    let name: String
    let content: String
}

struct TranscriptResponse: Codable {
    let video_id: String
    let captions: [Caption]
}

struct Caption: Codable {
    var text: String
    let start: Double
    let duration: Double
}

struct GoogleTranslationResponse: Decodable {
    let data: TranslationData
}

struct TranslationData: Decodable {
    let translations: [Translation]
}

struct Translation: Decodable {
    let translatedText: String
}

struct LanguageOption {
    let name: String
    let code: String
}
