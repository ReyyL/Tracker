//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 02.06.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackerViewController = TrackerViewController()
        
        let statisticViewController = StatisticViewController()
        
        trackerViewController.title = "Трекеры"
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackerIcon"),
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticIcon"),
            selectedImage: nil
        )
        
        trackerNavigationController.navigationBar.prefersLargeTitles = true
        
        self.viewControllers = [trackerNavigationController, statisticNavigationController]
        
        tabBar.unselectedItemTintColor = .yGray
    }
}
