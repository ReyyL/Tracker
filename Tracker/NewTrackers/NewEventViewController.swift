//
//  NewEventViewController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 16.06.2024.
//

import UIKit

final class NewEventViewController: TrackerCreationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    override func setupScreen() {
        super.setupScreen()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Новое нерегулярное событие"
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    @objc override func saveTrackerScreen() {
        selectedDays = Weekday.allCases
        super.saveTrackerScreen()
        
    }
}

extension NewEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        chooseCategory()
    }
}

extension NewEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .yLightGrayAlpha
        cell.layer.cornerRadius = 16
        
        cell.textLabel?.text = "Категория"
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.text = selectedCategory
        cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .yGray
        
        return cell
    }
}
