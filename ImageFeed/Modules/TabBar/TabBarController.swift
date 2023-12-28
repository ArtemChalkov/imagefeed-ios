//
//  TabBarViewController.swift
//  ImageFeed
//


import UIKit

class TabBarController: UITabBarController {
    
    let imagesListController: UINavigationController = {
        let controller = ImagesListViewController()
        let tabItem = UITabBarItem.init(title: "", image: UIImage(named: "MainNoActive"), selectedImage: UIImage(named: "MainActive"))
        controller.tabBarItem = tabItem
        
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }()
    
    let profileController: ProfileViewController = {
        let controller = ProfileViewController()
        let tabItem = UITabBarItem.init(title: "", image: UIImage(named: "ProfileNoActive"), selectedImage: UIImage(named: "ProfileActive"))
        controller.tabBarItem = tabItem
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = Colors.ypBlack
        appearance.stackedLayoutAppearance.normal.iconColor = Colors.ypWhite
        appearance.stackedLayoutAppearance.selected.iconColor = Colors.ypWhite
        
        tabBar.standardAppearance = appearance
        viewControllers = [imagesListController, profileController]
    }
    
}
