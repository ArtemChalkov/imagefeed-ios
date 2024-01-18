//
//  UIBlockingProgressHUD.swift
//  ImageFeed


import Foundation

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        //return UIApplication.shared.windows.first
        return UIWindow.key
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }

}
