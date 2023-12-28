//
//  AccessToken.swift
//  ImageFeed
//
//  Created by Artur Igberdin on 28.12.2023.
//

import Foundation

//        {
//           "access_token": "091343ce13c8ae780065ecb3b13dc903475dd22cb78a05503c2e0c69c5e98044",
//           "token_type": "bearer",
//           "scope": "public read_photos write_photos",
//           "created_at": 1436544465
//         }

// MARK: - AccessToken
struct AccessToken: Codable {
    let accessToken, tokenType, scope: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
