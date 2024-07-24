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
        
        trackerViewController.title = NSLocalizedString("trackers", comment: "")
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers", comment: ""),
            image: UIImage(named: "TrackerIcon"),
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistic", comment: ""),
            image: UIImage(named: "StatisticIcon"),
            selectedImage: nil
        )
        
        trackerNavigationController.navigationBar.prefersLargeTitles = true
        
        self.viewControllers = [trackerNavigationController, statisticNavigationController]
        
        tabBar.unselectedItemTintColor = .yGray
        tabBar.backgroundColor = .yWhite
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.yBlackAlpha.cgColor
        tabBar.layer.addSublayer(topBorder)
    }
}
