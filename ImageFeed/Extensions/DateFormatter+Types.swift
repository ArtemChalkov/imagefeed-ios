//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Artur Igberdin on 06.02.2024.
//

import Foundation

extension DateFormatter {
    static let mediumDateFormatter: DateFormatter = {

        //dateFormatter.dateFormat = "d LLLL YYYY"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    static let iso6601Formatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter
    }()

    //ISO8601DateFormatter
}
