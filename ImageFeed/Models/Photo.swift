//
//  Photo.swift
//  ImageFeed
//
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String? //let description: String
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool //let likedByUser: Bool
}

struct PhotoResult: Codable {
    let id: String
    let updatedAt: String //"2016-05-03T11:00:28-04:00"
    //let createdAt: String
    let description: String?
    
    let width: Int
    let height: Int
    
    let urls: UrlsResult
    
    let likedByUser: Bool
}

struct UrlsResult: Codable {
    let raw, full, thumb, smallS3: String
    let regular, small: String
}
