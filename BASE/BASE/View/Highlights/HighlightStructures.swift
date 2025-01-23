//
//  HighlightStructures.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/14/25.
//

import Foundation
import YouTubePlayerKit


enum curretnState {
    case youtube
    case podcast
    case pshomerun
}

struct YouTubePlaylistResponse: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String?
    let items: [PlaylistItem]
    let pageInfo: PageInfo
}

struct PlaylistItem: Codable {
    let kind: String
    let etag: String
    let id: String
    let snippet: Snippet
    let contentDetails: ContentDetails?
    let status: Status?
}

struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let playlistId: String
    let position: Int
    let resourceId: ResourceId
}

struct Thumbnails: Codable {
    let `default`: Thumbnail
    let medium: Thumbnail
    let high: Thumbnail
}

struct Thumbnail: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct ResourceId: Codable {
    let kind: String
    let videoId: String
}

struct ContentDetails: Codable {
    let videoId: String
    let videoPublishedAt: String
}

struct Status: Codable {
    let privacyStatus: String
}

struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct Playlist {
    let id: String
    let name: String
}
