//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 02.06.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let trackerRecordStore = TrackerRecordStore()
    
    private var completedTrackers: [TrackerRecord] = []
    
    private lazy var mainView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.yRed.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var titleLabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .yBlack
        label.text = ""
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var subLabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .yBlack
        label.text = NSLocalizedString("done_trackers", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStat()
    }
    
    private func updateStat() {
        completedTrackers = trackerRecordStore.fetchTrackerRecords()
        titleLabel.text = "\(completedTrackers.count)"
    }
    
    private func setupScreen() {
        view.backgroundColor = .yWhite
        
        view.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(subLabel)
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            
            subLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            subLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            subLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainView.heightAnchor.constraint(equalToConstant: 90),
            mainView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
