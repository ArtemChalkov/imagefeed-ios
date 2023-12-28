//
//  Window+key.swift
//  ImageFeed
//
//  Created by Artur Igberdin on 28.12.2023.
//

import UIKit

extension UIWindow {
    
    static var key: UIWindow! {
        if #available(iOS 13, *) {
            return UIApplication
                    .shared
                    .connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }
            
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
