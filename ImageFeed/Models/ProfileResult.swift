//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Artur Igberdin on 16.01.2024.
//

import Foundation


struct ProfileResult: Codable {
    let id: String
    //let updatedAt: Date?
    let username, firstName, lastName, twitterUsername: String?
    //let portfolioURL: JSONNull?
    let bio: String?
    //let location: ?
    let totalLikes, totalPhotos, totalCollections: Int?
    let followedByUser: Bool?
    let downloads, uploadsRemaining: Int?
    let instagramUsername, email: String?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id
        //case updatedAt = "updated_at"
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        //case portfolioURL = "portfolio_url"
        case bio
        //case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followedByUser = "followed_by_user"
        case downloads
        case uploadsRemaining = "uploads_remaining"
        case instagramUsername = "instagram_username"
        case email, links
    }
}

// MARK: - Links
class Links: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio
    }
}

