//
//  FilterController.swift
//  Tracker
//
//  Created by Andrey Lazarev on 21.07.2024.
//

import UIKit

protocol FilterControllerDelegate: AnyObject {
    func filterTrackers(filter: String)
}

final class FilterController: UIViewController {
    
    var selectedIndex: IndexPath?
    
    var currentFilter = "Все трекеры"
    
    weak var delegate: FilterControllerDelegate?
    
    private let filtersArray = [
        "Все трекеры",
        "Трекеры на сегодня",
        "Завершенные",
        "Не завершенные"
    ]
    
    private lazy var tableView = {
        let tableView = TrackerTable()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupScreen()
        
    }
    
    private func setupScreen() {
        
        title = "Фильтры"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        view.backgroundColor = .yWhite
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
    }
}

extension FilterController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedIndex = selectedIndex {
            let previouslySelectedCell = tableView.cellForRow(at: selectedIndex)
            previouslySelectedCell?.accessoryType = .none
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedIndex = indexPath
        
        let filter = filtersArray[indexPath.row]
        delegate?.filterTrackers(filter: filter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
}

extension FilterController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        filtersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = filtersArray[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .yLightGrayAlpha
        
        if filtersArray[indexPath.row] == currentFilter {
            selectedIndex = indexPath
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
}

