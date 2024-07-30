//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 14.07.2024.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 32, weight: .bold)
        title.numberOfLines = 2
        title.textColor = .black
        title.textAlignment = .center
        return title
    }()
    
    init(image: UIImage, title: String) {
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        backgroundImage.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    private func setupScreen() {
        
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
