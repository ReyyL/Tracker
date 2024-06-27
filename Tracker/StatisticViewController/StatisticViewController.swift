//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 02.06.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yWhite
        setupView()
    }
    
    private func setupView() {
        let stub = UILabel()
        stub.text = "In progress"
        stub.textColor = .yBlack
        
        stub.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stub)
        
        NSLayoutConstraint.activate([
            stub.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stub.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
